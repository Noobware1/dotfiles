import QtQuick
import Quickshell.Networking

QtObject {
    id: root

    readonly property list<WifiNetwork> networks: {
        const devices = Networking.devices.values;

        let list = [];
        for (var i = 0; i < devices.length; i++) {
            const device = devices[i];
            if (device.type == DeviceType.Wifi) {
                // device.scannerEnabled = true;
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
