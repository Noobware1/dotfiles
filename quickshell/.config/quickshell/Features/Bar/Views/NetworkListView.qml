pragma ComponentBehavior: Bound

import Material3
import QtQuick
import QtQuick.Layouts
import qs.Core
import qs.Features.Bar.Models
import Quickshell.Networking
import qs.Shared.Components

ColumnLayout {
    id: view
    readonly property NetworkModel model: NetworkModel {}
    signal backButtonPressed

    TopAppBar {
        id: appBar
        z: 1e6
        leadingItem: BackButton {
            onClicked: view.backButtonPressed()
        }
        actions: IconButton {
            icon.name: "refresh"
            icon.height: TopAppBarDefaults.iconSize
            icon.width: TopAppBarDefaults.iconSize
            onClicked: {
                const devices = Networking.devices.values;
                for (var i = 0; i < devices.length; i++) {
                    const device = devices[i];
                    if (device.type == DeviceType.Wifi) {
                        device.scannerEnabled = true;
                    }
                }
            }
        }

        headlineText: "Networks"
        Layout.fillWidth: view.width
    }

    ListView {
        id: listView

        model: view.model.networks

        // Layout.fillHeight: true
        Layout.preferredHeight: 400
        Layout.fillWidth: true

        delegate: ListItem {
            id: item
            required property var modelData

            anchors.horizontalCenter: parent?.horizontalCenter ?? undefined
            width: view.width - LayoutSemenatics.compactMargin * 2
            clickable: true
            elevation: 2

            subtitleText: modelData.conntected ? "connected" : ""

            leadingItem: Icon {
                anchors.centerIn: parent
                name: "wifi"
                size: ListDefaults.iconSize
                color: item.colors.secondaryContentColor
            }
            text: modelData?.name
            trailingItem: IconButton {
                id: button
                anchors.centerIn: parent
                icon.name: "more_vert"
                blockHover: true
            }
            states: State {
                when: item.visualFocus
                PropertyChanges {
                    item {
                        z: 1000
                    }
                }
            }
        }
    }
}
