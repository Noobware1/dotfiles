pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import Material3
import qs.Shared.Components
import qs.Core

LazyLoader {
    id: loader

    default property list<QtObject> data

    required property Component contentItem

    property bool autoHide: true
    property int duration: timer.interval

    // readonly property list<QtObject> __internals: [
    //
    // ]

    readonly property Timer __timer: Timer {
        id: timer
        interval: MotionSpecs.durationExtraLong4
        function maybeRestart(): void {
            if (loader.autoHide) {
                timer.restart();
            }
        }
        onTriggered: function () {
            if (loader.autoHide) {
                loader.hide();
            }
        }
    }

    function show() {
        if (loader.active) {
            const overlay = loader.item as Overlay;
            if (overlay.hovered) {
                return;
            }
            overlay.dismissable.open();
            timer.maybeRestart();
        }
        loader.loading = true;
    }

    function hide() {
        if (active) {
            const overlay = loader.item as Overlay;
            overlay.dismissable.close();
        }
    }

    Overlay {}

    component Overlay: PanelWindow {
        id: overlay
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:overlay"
        WlrLayershell.layer: WlrLayer.Overlay

        anchors {
            bottom: true
        }

        implicitHeight: __dismissable.implicitHeight + LayoutSemenatics.compactMargin // bottomPadding
        implicitWidth: __dismissable.implicitWidth

        color: "transparent"

        readonly property alias dismissable: __dismissable
        readonly property alias hovered: hoverHandler.hovered

        Dismissable {
            id: __dismissable
            horizontalPadding: LayoutSemenatics.horizontalPaddingMedium
            verticalPadding: LayoutSemenatics.verticalPaddingMedium

            elevation: 6

            HoverHandler {
                id: hoverHandler
                onHoveredChanged: {
                    if (hovered) {
                        timer.stop();
                    } else {
                        timer.maybeRestart();
                    }
                }
            }

            y: overlay.implicitHeight

            enter: Transition {
                DefaultAnimation {
                    target: __dismissable
                    from: overlay.implicitHeight
                    to: 0
                }
            }
            exit: Transition {
                DefaultAnimation {
                    target: __dismissable
                    from: 0
                    to: overlay.implicitHeight
                }
            }
            contentItem: Loader {
                anchors.centerIn: parent
                sourceComponent: loader.contentItem
            }
            delay: 0
            onAboutToShow: timer.maybeRestart()
            onClosed: {
                loader.loading = false;
                loader.active = false;
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
