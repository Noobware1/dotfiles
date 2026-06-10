pragma Singleton

import QtQuick
import Quickshell as QS
import Quickshell.Bluetooth

QS.Singleton {
    id: root

    readonly property QS.ObjectModel devices: Bluetooth.devices

    readonly property BluetoothDevice activeDevice: {
        for (var i = 0; i < root.devices.values.length; i++) {
            var device = root.devices.values[i];
            if (device.connected) {
                return device;
            }
        }
        return null;
    }

    property bool scanEnabled: false

    readonly property bool enabled: Bluetooth.defaultAdapter?.enabled ?? false

    function enable(): void {
        if (Bluetooth.defaultAdapter) {
            Bluetooth.defaultAdapter.enabled = true;
        }
    }

    function disable(): void {
        if (Bluetooth.defaultAdapter) {
            Bluetooth.defaultAdapter.enabled = false;
        }
    }

    Binding {
        when: root.enabled
        target: Bluetooth.defaultAdapter
        property: "discovering"
        value: root.scanEnabled
    }
}
