pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import qs.Services
import qs.Shared.Components

ViewModel {
    id: model

    property ScriptModel pairedDevices: ScriptModel {
        values: [...BluetoothService.devices.values].filter((e => e.paired))
    }

    property ScriptModel availableDevices: ScriptModel {
        values: [...BluetoothService.devices.values].filter((e => !e.paired))
    }

    function connect(device: BluetoothDevice): void {
        if (!device) {
            return;
        }

        if (device.paired) {
            device.connect();
        } else {
            device.pair();
        }
    }

    Component.onCompleted: {
        Qt.callLater(function () {
            BluetoothService.scanEnabled = true;
        });
    }

    Component.onDestruction: {
        BluetoothService.scanEnabled = false;
    }
}
