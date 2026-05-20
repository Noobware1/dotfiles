pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Networking
import qs.Services
import qs.Shared.Components

ViewModel {
    id: model

    readonly property list<WifiDevice> wifiDevices: [...NetworkService.devices.values].filter(e => e.type === DeviceType.Wifi)

    property ScriptModel savedNetworks: ScriptModel {
        values: {
            const networks = model.wifiDevices.reduce((acc, device) => acc.concat([...device.networks.values].filter(e => e.known)), []);
            return networks.sort((a, b) => {
                if (a.connected !== b.connected) {
                    return b.connected - a.connected;
                }
                return b.signalStrength - a.signalStrength;
            });
        }
    }

    property ScriptModel availableNetworks: ScriptModel {
        values: {
            const networks = model.wifiDevices.reduce((acc, device) => acc.concat([...device.networks.values].filter(e => !e.known)), []);
            return networks.sort((a, b) => b.signalStrength - a.signalStrength);
        }
    }

    Component.onCompleted: {
        Qt.callLater(function () {
            model.wifiDevices.forEach(function (device) {
                device.scannerEnabled = true;
            });
        });
    }
}
