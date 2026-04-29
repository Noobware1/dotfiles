pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Networking
import qs.Services
import qs.Features.Bar.Components
import qs.Features.Bar.Models

SplitToggleButton {
    id: button
    property Network network: NetworkService.connectedNetwork
    icon.name: "wifi"
    text: {
        if (network) {
            return network.name;
        } else {
            return "Not Connected";
        }
    }

    onToggled: {
        if (network) {
            // network.disconnect();
        }
    }

    property real menuHeight
    property QuickSettingsModel model

    onClicked: {
        model.goto("/networks");
    }
}
