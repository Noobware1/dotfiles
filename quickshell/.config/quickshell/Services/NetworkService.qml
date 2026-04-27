pragma Singleton

import QtQuick
import Quickshell as QS
import Quickshell.Networking

QS.Singleton {
    id: root

    readonly property QS.ObjectModel devices: Networking.devices

    function scan(): void {
        __scan(true);
    }

    function stopScan(): void {
        __scan(false);
    }

    function __scan(scan: bool): void {
        const devices = this.devices.values;
        for (var i = 0; i < devices.length; i++) {
            const device = devices[i];
            if (device.type == DeviceType.Wifi) {
                device.scannerEnabled = scan;
            }
        }
    }

    final property Network connectedNetwork: {
        const devices = this.devices.values;
        for (var i = 0; i < devices.length; i++) {
            const networks = devices[i].networks.values;
            for (var j = 0; j < networks.length; j++) {
                const network = networks[i];
                if (network.connected) {
                    return network;
                }
            }
        }
        return null;
    }
}
