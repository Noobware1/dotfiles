pragma ComponentBehavior: Bound

import qs.Features.Bar.QuickSettings.Components
import qs.Features.Bar.QuickSettings.Views
import Material3
import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls as C
import qs.Core
import qs.Shared.Components
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
