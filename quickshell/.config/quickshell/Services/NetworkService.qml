pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell as Qs
import Quickshell.Networking

Qs.Singleton {
    id: root

    final readonly property Qs.ObjectModel devices: Networking.devices

    final readonly property Network connectedNetwork: {
        for (var i = 0; i < root.devices.values.length; i++) {
            var device = root.devices.values[i];
            for (var j = 0; j < device.networks.values.length; j++) {
                var network = device.networks.values[j];
                if (network.connected)
                    return network;
            }
        }
        return null;
    }

    final readonly property bool wifiEnabled: Networking.wifiEnabled

    function disableWifi() {
        Network.wifiEnabled = false;
    }

    function enableWifi() {
        Network.wifiEnabled = true;
    }

    function connect(network: Network, passphrase = "") {
        if (!network) {
            return;
        }

        if (network.type === DeviceType.Wifi && [WifiSecurityType.WpaPsk, WifiSecurityType.Wpa2Psk, WifiSecurityType.Sae].includes(network.security)) {
            (network as WifiNetwork).connectWithPsk(passphrase);
        } else {
            network.connect();
        }
    }

    function init(): void {
        console.debug("NetworkService: initialized");
    }
}
