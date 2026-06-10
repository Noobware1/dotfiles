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

    function requiresPassword(network: Network): bool {
        return network && network instanceof WifiNetwork && [WifiSecurityType.WpaPsk, WifiSecurityType.Wpa2Psk, WifiSecurityType.Sae].includes(network.security);
    }

    function connect(network: Network, passphrase = "") {
        console.log("CALLED");
        if (!network) {
            return;
        }

        const devices = this.devices.values;
        let found = false;

        for (let i = 0; i < devices.length; ++i) {
            const device = devices[i];

            if (device.type !== DeviceType.Wifi) {
                continue;
            }

            const networks = device.networks.values;
            if (networks.includes(network)) {
                found = true;
                break;
            }
        }

        if (!found) {
            return;
        }

        if (requiresPassword(network)) {
            if (network.known && !passphrase) {
                network.connect();
            } else {
                (network as WifiNetwork).connectWithPsk(passphrase);
            }
        } else {
            network.connect();
        }
    }

    function init(): void {
        console.debug("NetworkService: initialized");
    }
}
