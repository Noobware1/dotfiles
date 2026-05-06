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
        popup.toggle();
    }

    QsPopup {
        id: popup
        readonly property point offset: settings.parent.mapFromItem(settings, settings.pressX, settings.pressY)
        window: settings.window
        x: offset.x
        y: settings.window.implicitHeight + 2
        backgroundColor: MaterialTheme.colorScheme.surface

        property bool aboutToClose

        onAboutToHide: {
            aboutToClose = true;
        }
        onAboutToShow: {
            aboutToClose = false;
        }

        QuickSettingsMenu {
            radius: popup.radius
            backgroundColor: popup.backgroundColor
            overlay: popup.defaultOverlay
            aboutToClose: popup.aboutToClose
        }
    }

    component MIcon: Icon {
        color: settings.colors.contentColor
        size: settings.iconSize
    }
}
