import QtQuick
import Quickshell
import Quickshell.Networking
import qs.Shared.Components
import qs.Services

ViewModel {
    id: root

    Timer {
        id: timer
        running: true
        interval: 600
        onTriggered: {
            NetworkService.scan();
        }
    }

    readonly property ScriptModel networks: ScriptModel {
        values: {
            const devices = NetworkService.devices.values;
            let list = [];
            for (var i = 0; i < devices.length; i++) {
                const device = devices[i];
                if (device.type == DeviceType.Wifi) {
                    list.push(...device.networks.values);
                }
            }

            return list.sort((a, b) => {
                if (a.connected !== b.connected) {
                    return b.connected - a.connected;
                }
                return b.signalStrength - a.signalStrength;
            });
        }
    }

    Component.onDestruction: {
        NetworkService.stopScan();
    }
}
