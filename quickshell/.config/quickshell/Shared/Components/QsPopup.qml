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

    signal aboutToHide
    signal aboutToShow

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

    property real popupHeight
    property real popupWidth

    PopupDelegate {}

    property Component defaultOverlay: Item {
        Behavior on opacity {
            NumberAnimation {
                duration: MotionSpecs.durationShort3
            }
        }
        Rectangle {
            x: loader.elevationGap / 2
            y: loader.elevationGap / 2
            radius: loader.radius
            height: loader.popupHeight
            width: loader.popupWidth
            color: Qt.alpha(MaterialTheme.colorScheme.scrim, 0.4)
        }
    }
    property real elevationGap: 6

    property Transition enter: Transition {
        PropertyAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
            easing.type: Easing.BezierSpline
            duration: MotionSpecs.expressiveDefaultSpatialDuration
        }
        DefaultAnimation {
            from: loader.popupWidth
            to: loader.elevationGap / 2
        }
    }

    property Transition exit: Transition {
        PropertyAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
            easing.type: Easing.BezierSpline
            duration: MotionSpecs.expressiveDefaultSpatialDuration
        }
        DefaultAnimation {
            from: loader.elevationGap / 2
            to: loader.popupWidth
        }
    }

    component PopupDelegate: PopupWindow {
        id: popupWindow

        Binding {
            loader {
                popupHeight: _dismissable.implicitHeight
                popupWidth: _dismissable.implicitWidth
            }
        }

        anchor.window: loader.window
        anchor.rect.x: loader.x - loader.elevationGap / 2
        anchor.rect.y: loader.y - loader.elevationGap / 2

        implicitHeight: _dismissable.implicitHeight + loader.elevationGap
        implicitWidth: _dismissable.implicitWidth + loader.elevationGap
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
            }
            onAboutToHide: {
                loader.aboutToHide();
            }
            onAboutToShow: {
                loader.aboutToShow();
            }
            onClosed: {
                loader.active = false;
                grab.active = false;
            }

            visible: true
            opacity: 0
            x: _dismissable.implicitWidth
            enter: loader.enter
            exit: loader.exit
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
        property: "x"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}
