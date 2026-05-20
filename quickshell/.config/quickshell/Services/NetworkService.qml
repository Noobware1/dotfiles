pragma Singleton

import QtQuick
import Quickshell as Qs
import Quickshell.Networking

Qs.Singleton {
    id: root

    readonly property Qs.ObjectModel devices: Networking.devices

    final readonly property Network connectedNetwork: {
        const devices = this.devices.values;
        for (var i = 0; i < devices.length; i++) {
            const networks = devices[i].networks.values;
            for (var j = 0; j < networks.length; j++) {
                const network = networks[i];
                if (network && network.connected) {
                    return network;
                }
            }
        }
        return null;
    }
}
