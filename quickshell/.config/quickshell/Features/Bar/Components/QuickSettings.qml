pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Material3
import qs.Features.Bar.Components

Button {
    id: settings

    variant: ButtonVariant.Text
    containerHeight: height
    implicitHeight: containerHeight
    spacing: 5
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
        if (popupLoader.active) {
            (popupLoader.item as QuickMenuPopup).menu.close();
        } else {
            popupLoader.active = true;
        }
    }

    Loader {
        id: popupLoader
        active: false
        sourceComponent: QuickMenuPopup {}
    }

    component QuickMenuPopup: PopupWindow {
        id: popup
        readonly property point offset: settings.parent.mapFromItem(settings, settings.pressX, settings.pressY)
        anchor.window: settings.window
        anchor.rect.x: offset.x
        anchor.rect.y: settings.window.implicitHeight
        // implicitHeight: Screen.height - anchor.rect.y
        implicitHeight: menu.implicitHeight
        implicitWidth: menu.implicitWidth

        color: "transparent"
        visible: true

        property alias menu: _menu

        QuickSettingsMenu {
            id: _menu
            onClosed: {
                popupLoader.active = false;
            }
            // anchors.fill: parent
        }

        HyprlandFocusGrab {
            id: grab
            active: popupLoader.active
            windows: [popup]
            onActiveChanged: {
                if (!active) {
                    _menu.close();
                }
            }
        }
    }

    component MIcon: Icon {
        color: settings.colors.contentColor
        size: settings.iconSize
    }
}
