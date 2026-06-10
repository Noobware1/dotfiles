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

    function autoConnect(network: WifiNetwork) {
        NetworkService.connect(network);
    }

    function connect(network: WifiNetwork, passphrase = "") {
        network.newConnection = !network.known;
        NetworkService.connect(network, passphrase);
    }

    function requiresPassword(network: WifiNetwork): bool {
        return NetworkService.requiresPassword(network);
    }

    function forget(network: WifiNetwork) {
        network.forget();
    }

    Component.onCompleted: {
        Qt.callLater(function () {
            model.wifiDevices.forEach(function (device) {
                device.scannerEnabled = true;
            });
        });
    }

    Component.onDestruction: {
        model.wifiDevices.forEach(function (device) {
            device.scannerEnabled = false;
        });
    }
}
