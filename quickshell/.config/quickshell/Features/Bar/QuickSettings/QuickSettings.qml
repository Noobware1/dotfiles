pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.UPower
import Material3
import qs.Shared.Components

Button {
    id: settings

    variant: ButtonVariant.Text
    containerHeight: height
    implicitHeight: containerHeight
    spacing: 5
    colors.contentColor: MaterialTheme.colorScheme.onSurfaceVariant
    required property PanelWindow window
    required property real iconSize

    contentItem: Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: settings.spacing
        MIcon {
            anchors.verticalCenter: parent.verticalCenter
            name: "volume_up"
        }
        MIcon {
            anchors.verticalCenter: parent.verticalCenter
            name: "signal_wifi_4_bar"
        }
        MIcon {
            readonly property real percentage: UPower.displayDevice.percentage
            readonly property list<string> icons: ["battery_android_0", "battery_android_1", "battery_android_2", "battery_android_3", "battery_android_4", "battery_android_5", "battery_android_6", "battery_android_full"]
            anchors.verticalCenter: parent.verticalCenter
            name: icons[Math.round(Math.min(1, Math.max(0, percentage)) * 6)]
        }
    }

    onPressed: {
        popupLoader.toggle();
        // popup.visible = !popup.visible;
    }

    QsPopupLoader {
        id: popupLoader
        QsPopup {
            id: popup
            anchor.window: settings.window
            readonly property point offset: settings.parent.mapFromItem(settings, settings.pressX, settings.pressY)

            x: offset.x
            y: settings.window.implicitHeight + 2
            // don't know why but if i don't do this swipe acts weird
            property bool ready: false
            onAboutToShow: {
                ready = true;
            }
            Loader {
                active: popup.ready
                sourceComponent: QuickSettingsMenu {
                    radius: popup.radius
                    backgroundColor: popup.backgroundColor
                }
            }
            backgroundColor: MaterialTheme.colorScheme.surface
            focus: true
            enter: Transition {
                PropertyAction {
                    property: "x"
                    value: popup.implicitWidth
                }
                PropertyAction {
                    property: "opacity"
                    value: 0
                }
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
                    easing.type: Easing.BezierSpline
                    duration: MotionSpecs.expressiveDefaultSpatialDuration
                }
                DefaultAnimation {
                    from: popup.implicitWidth
                    to: popup.elevationPadding / 2
                }
            }

            exit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
                    easing.type: Easing.BezierSpline
                    duration: MotionSpecs.expressiveDefaultSpatialDuration
                }
                DefaultAnimation {
                    from: popup.elevationPadding / 2
                    to: popup.implicitWidth
                }
            }
        }
    }

    component MIcon: Icon {
        color: settings.colors.contentColor
        size: settings.iconSize
    }

    component DefaultAnimation: NumberAnimation {
        property: "x"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}
