pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Material3
import qs.Features.Bar.Components
import qs.Features.Bar.Views
import Material3.internals
import qs.Core

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
        if (popupLoader.active) {
            (popupLoader.item as QuickMenuPopup).menu.close();
        } else {
            popupLoader.loading = true;
        }
    }

    LazyLoader {
        id: popupLoader
        onActiveChanged: {
            GlobalState.quickSettingsMenuOpen = active;
        }
        QuickMenuPopup {}
    }

    component QuickMenuPopup: PopupWindow {
        id: popup
        readonly property point offset: settings.parent.mapFromItem(settings, settings.pressX, settings.pressY)
        anchor.window: settings.window
        anchor.rect.x: offset.x
        anchor.rect.y: settings.window.implicitHeight + 2
        implicitHeight: menu.implicitHeight + 12
        implicitWidth: menu.implicitWidth + 12

        color: "transparent"
        visible: true

        property alias menu: _menu

        QuickSettingsView {
            id: _menu
            anchors.horizontalCenter: parent.horizontalCenter

            onClosed: {
                popupLoader.active = false;
                grab.active = false;
            }
        }

        HyprlandFocusGrab {
            id: grab
            active: true
            windows: [popup, settings.window]
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
