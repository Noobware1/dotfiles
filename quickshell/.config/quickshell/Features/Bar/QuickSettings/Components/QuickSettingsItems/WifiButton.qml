pragma ComponentBehavior: Bound

import qs.Features.Bar.QuickSettings.Components
import QtQuick
import Quickshell.Networking
import qs.Services

SplitToggleButton {
    id: button
    icon.name: "wifi"

    signal openSettings
    property Network network: NetworkService.connectedNetwork
    text: {
        if (network) {
            return network.name;
        } else {
            return "No Internet";
        }
    }
    onClicked: {
        openSettings();
    }
}
