pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Networking
import qs.Services
import qs.Shared.Components

ViewModel {
    id: model

    readonly property list<WifiDevice> wifiDevices: [...NetworkService.devices.values].filter(e => e.type === DeviceType.Wifi)

    property list<WifiNetwork> wifiNetworks: model.wifiDevices.reduce(function (acc, device) {
        return acc.concat(device.networks.values);
    }, [])

    property ScriptModel savedNetworks: ScriptModel {
        values: [...model.wifiNetworks].filter((e => e.known)).sort((a, b) => {
            if (a.connected !== b.connected) {
                return b.connected - a.connected;
            }
            return b.signalStrength - a.signalStrength;
        })
    }

    property ScriptModel availableNetworks: ScriptModel {
        values: [...model.wifiNetworks].filter((e => !e.known)).sort((a, b) => b.signalStrength - a.signalStrength)
    }

    Component.onCompleted: {
        Qt.callLater(function () {
            model.wifiDevices.forEach(function (device) {
                device.scannerEnabled = true;
            });
        });
    }

    function connect(network: WifiNetwork, passphrase = "") {
        NetworkService.connect(network, passphrase);
    }
}
