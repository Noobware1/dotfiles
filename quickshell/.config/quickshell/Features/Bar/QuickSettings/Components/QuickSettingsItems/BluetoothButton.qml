import qs.Features.Bar.QuickSettings.Components
import Quickshell.Bluetooth
import qs.Services

SplitToggleButton {
    icon.name: "bluetooth"

    readonly property BluetoothDevice activeDevice: BluetoothService.activeDevice
    text: activeDevice?.name ?? "Disconnected"

    signal openSettings

    checked: BluetoothService.enabled

    onClicked: {
        openSettings();
    }
}
