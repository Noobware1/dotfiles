pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import QtQuick.Effects
import Material3
import Quickshell
import Quickshell.Hyprland

LazyLoader {
    id: loader

    property QtObject window
    property real x
    property real y

    function toggle() {
        if (active) {
            close();
        } else {
            open();
        }
    }

    function close() {
        const dismissable = (item as PopupDelegate)?.dismissable;
        if (dismissable) {
            dismissable.close();
        }
    }

    function open() {
        loading = true;
        // (item as PopupDelegate).dismissable.open();
    }

    default property Component content
    property real elevation: 4
    property real radius: 24
    property color backgroundColor: MaterialTheme.colorScheme.surfaceContainer

    property real padding: 0
    property real horizontalPadding: padding
    property real verticalPadding: padding
    property real leftPadding: horizontalPadding
    property real topPadding: verticalPadding
    property real bottomPadding: verticalPadding
    property real rightPadding: horizontalPadding

    PopupDelegate {}

    component PopupDelegate: PopupWindow {
        id: popupWindow
        anchor.window: loader.window
        property real elevationGap: 6
        anchor.rect.x: loader.x - elevationGap / 2
        anchor.rect.y: loader.y - elevationGap / 2

        implicitHeight: _dismissable.implicitHeight + elevationGap
        implicitWidth: _dismissable.implicitWidth + elevationGap
        color: "transparent"

        property alias dismissable: _dismissable

        Popup {
            id: _dismissable
            elevation: loader.elevation
            radius: loader.radius
            backgroundColor: loader.backgroundColor
            padding: loader.padding
            horizontalPadding: loader.horizontalPadding
            verticalPadding: loader.verticalPadding
            topPadding: loader.topPadding
            leftPadding: loader.leftPadding
            bottomPadding: loader.bottomPadding
            rightPadding: loader.rightPadding
            focus: true
            modal: true
            contentItem: Loader {
                sourceComponent: loader.content
                // onLoaded: {
                //     _dismissable.focusPolicy = Qt.binding(() => item instanceof T.Control ? (item as T.Control).focusPolicy : Qt.NoFocus);
                // }
            }
            // contentItem: Item {
            //     implicitHeight: contentLoader.implicitHeight
            //     implicitWidth: contentLoader.implicitWidth
            //
            //     property Item mask: Item {
            //         parent: _dismissable.contentItem
            //         anchors.fill: parent
            //         layer.enabled: true
            //         visible: false
            //         Rectangle {
            //             radius: _dismissable.radius
            //             anchors.fill: parent
            //             color: _dismissable.backgroundColor
            //         }
            //     }
            //
            //     property Loader contentLoader: Loader {
            //         parent: _dismissable.contentItem
            //         layer.enabled: true
            //         anchors.fill: parent
            //         layer.effect: MultiEffect {
            //             maskSource: _dismissable.contentItem.mask
            //             maskEnabled: true
            //             maskThresholdMin: 0.5
            //             maskSpreadAtMin: 1
            //         }
            //
            //         sourceComponent: loader.content
            //     }
            // }

            onClosed: {
                loader.active = false;
                grab.active = false;
            }

            visible: true
            y: -_dismissable.implicitHeight
            x: popupWindow.elevationGap / 2

            enter: Transition {
                PropertyAction {
                    property: "visible"
                    value: true
                }
                DefaultAnimation {
                    from: -_dismissable.implicitHeight
                    to: popupWindow.elevationGap / 2
                }
            }

            exit: Transition {
                PropertyAction {
                    target: _dismissable
                    property: "elevation"
                    value: 0
                }
                PropertyAction {
                    target: _dismissable
                    property: "clip"
                    value: true
                }
                DefaultAnimation {
                    from: popupWindow.elevationGap / 2
                    to: -_dismissable.implicitHeight
                }
            }
        }

        visible: true

        HyprlandFocusGrab {
            id: grab
            active: true
            windows: [popupWindow, loader.window]
            onActiveChanged: {
                if (!active) {
                    loader.close();
                }
            }
        }
    }

    component DefaultAnimation: NumberAnimation {
        property: "y"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}
