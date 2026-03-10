import QtQuick
import qs.Core
import qs.Features.Bar.Components.QuickSettings

QtObject {

    enum Button {
        Wifi,
        Bluetooth,
        Dnd,
        DarkMode,
        PowerMode
    }

    readonly property list<int> ids: Preferences.getIntList("quick_buttons", [QuickSettingsModel.Button.Wifi, QuickSettingsModel.Button.Bluetooth, QuickSettingsModel.Button.DarkMode, QuickSettingsModel.Button.Dnd, QuickSettingsModel.Button.PowerMode])

    function isExpanded(id: int, defaultValue: bool): bool {
        return Preferences.getBool(`quick_button_${id}_exp`, defaultValue);
    }

    function getComponent(id: int): Component {
        let path = "";
        switch (id) {
        case QuickSettingsModel.Button.Wifi:
            path = "WifiButton.qml";
            break;
        case QuickSettingsModel.Button.Bluetooth:
            path = "BluetoothButton.qml";
            break;
        case QuickSettingsModel.Button.Dnd:
            path = "DoNotDisturbButton.qml";
            break;
        case QuickSettingsModel.Button.DarkMode:
            path = "DarkModeButton.qml";
            break;
        case QuickSettingsModel.Button.PowerMode:
            path = "PowerModeButton.qml";
            break;
        default:
            path = "";
            break;
        }

        if (path.length > 0) {
            path = `qrc:/${path}`;
        }
        return __emptyComponent;
    }

    final readonly property Component __emptyComponent: Component {
        QuickButton {}
    }
}
