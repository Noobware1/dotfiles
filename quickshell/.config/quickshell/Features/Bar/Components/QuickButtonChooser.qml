pragma ComponentBehavior: Bound

import QtQuick
import qs.Features.Bar.Components
import qs.Features.Bar.Components.QuickItems

DelegateChooser {
    id: chooser
    role: "type"
    required property bool editMode
    required property real buttonHeight
    required property real buttonMaxWidth
    required property real buttonMinWidth

    choices: [
        DelegateChoice {
            roleValue: QuickButton.Wifi
            WifiButton {
                required property bool toggled
                editMode: chooser.editMode
                containerHeight: chooser.buttonHeight
                maximumWidth: chooser.buttonMaxWidth
                minimumWidth: chooser.buttonMinWidth
                checked: toggled
                selected: false
            }
        },
        DelegateChoice {
            roleValue: QuickButton.Bluetooth
            BluetoothButton {
                required property bool toggled
                editMode: chooser.editMode
                containerHeight: chooser.buttonHeight
                maximumWidth: chooser.buttonMaxWidth
                minimumWidth: chooser.buttonMinWidth
                checked: toggled
                selected: false
            }
        },
        DelegateChoice {
            roleValue: QuickButton.Dnd
            DoNotDisturbButton {
                required property bool toggled
                editMode: chooser.editMode
                containerHeight: chooser.buttonHeight
                maximumWidth: chooser.buttonMaxWidth
                minimumWidth: chooser.buttonMinWidth
                checked: toggled
                selected: false
            }
        },
        DelegateChoice {
            roleValue: QuickButton.DarkMode
            DarkModeButton {
                required property bool toggled
                editMode: chooser.editMode
                containerHeight: chooser.buttonHeight
                maximumWidth: chooser.buttonMaxWidth
                minimumWidth: chooser.buttonMinWidth
                checked: toggled
                selected: false
            }
        },
        DelegateChoice {
            roleValue: QuickButton.PowerMode
            PowerModeButton {
                required property bool toggled
                editMode: chooser.editMode
                containerHeight: chooser.buttonHeight
                maximumWidth: chooser.buttonMaxWidth
                minimumWidth: chooser.buttonMinWidth
                checked: toggled
                selected: false
            }
        }
    ]
}
