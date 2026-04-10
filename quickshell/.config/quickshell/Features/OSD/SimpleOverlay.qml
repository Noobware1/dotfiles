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

    readonly property list<QtObject> __internals: [
        Timer {
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
    ]

    function show() {
        if (loader.active && timer.running) {
            (loader.item as Overlay).show();
            timer.maybeRestart();
        }
        loader.loading = true;
    }

    function hide() {
        const overlay = loader.item as Overlay;
        overlay.hide();
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

        implicitHeight: surface.implicitHeight + 20
        implicitWidth: surface.implicitWidth

        color: "transparent"

        function show() {
            surface.open();
        }

        function hide() {
            surface.close();
        }

        Dismissable {
            id: surface
            horizontalPadding: LayoutSemenatics.horizontalPaddingMedium
            verticalPadding: LayoutSemenatics.verticalPaddingMedium

            HoverHandler {
                id: mouse
                onHoveredChanged: {
                    if (hovered) {
                        timer.stop();
                    } else {
                        timer.maybeRestart();
                    }
                }
            }

            y: overlay.implicitHeight
            states: [
                State {
                    name: "opened"
                    PropertyChanges {
                        surface {
                            y: 0
                        }
                    }
                },
                State {
                    name: "closed"
                    PropertyChanges {
                        surface {
                            y: overlay.implicitHeight
                        }
                    }
                }
            ]
            enter: Transition {
                DefaultAnimation {
                    target: surface
                }
            }
            exit: Transition {
                DefaultAnimation {
                    target: surface
                }
            }
            contentItem: Loader {
                anchors.centerIn: parent
                sourceComponent: loader.contentItem
            }
            delay: 0
            onEntered: timer.maybeRestart()
            onExited: {
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
