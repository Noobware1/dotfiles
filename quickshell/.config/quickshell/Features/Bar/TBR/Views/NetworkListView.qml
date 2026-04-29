pragma ComponentBehavior: Bound

import Material3
import QtQuick
import QtQuick.Layouts
import qs.Core
import qs.Features.Bar.Models
import Quickshell.Networking
import qs.Shared.Components

Rectangle {
    id: view
    signal backButtonPressed
    readonly property NetworkModel model: NetworkModel {}
    required property QuickSettingsModel qsettingsModel
    implicitHeight: qsettingsModel.menuHeight
    implicitWidth: qsettingsModel.menuWidth
    color: MaterialTheme.colorScheme.surface
    radius: qsettingsModel.menuRadius

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        TopAppBar {
            id: appBar
            topLeftRadius: view.qsettingsModel.menuRadius
            topRightRadius: view.qsettingsModel.menuRadius
            Layout.fillWidth: true
            leadingItem: BackButton {
                onClicked: view.backButtonPressed()
            }
            headlineText: "Networks"
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
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true

            ListView {
                id: listView
                anchors.fill: parent

                anchors.topMargin: 6
                anchors.bottomMargin: 6
                // anchors.leftMargin: LayoutSemenatics.compactMargin * 2
                // anchors.rightMargin: LayoutSemenatics.compactMargin * 2

                //: height: parent.height - 12
                // width: parent.width - LayoutSemenatics.compactMargin * 2
                model: view.model.networks

                delegate: ListItem {
                    id: item
                    visible: modelData
                    required property WifiNetwork modelData
                    width: listView.width
                    elevation: 4
                    subtitleText: (modelData?.connected ?? false) ? "connected" : ""
                    onClicked: {
                        popup.open();
                    }
                    horizontalPadding: ListDefaults.horizontalPadding + 6
                    leadingItem: Icon {
                        anchors.centerIn: parent
                        name: "wifi"
                        size: ListDefaults.iconSize
                        color: item.colors.secondaryContentColor
                    }
                    text: modelData?.name ?? ""
                    trailingItem: IconButton {
                        id: button
                        anchors.centerIn: parent
                        icon.name: "more_vert"
                    }
                    states: State {
                        when: item.visualFocus
                        PropertyChanges {
                            item {
                                z: 2
                            }
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: popup
        width: implicitContentWidth + rightPadding + leftPadding
        anchors.centerIn: parent
        modal: true
        closePolicy: Popup.CloseOnPressOutside
        title: "Connect to SITI FIBER 5G"
        contentItem: ColumnLayout {
            OutlinedTextField {
                Layout.alignment: Qt.AlignHCenter
                labelText: "Password"
            }
        }
        overlay: Item {
            Rectangle {
                radius: view.radius
                anchors.horizontalCenter: parent.horizontalCenter
                width: view.width
                height: view.height
                // color: Qt.alpha(MaterialTheme.colorScheme.scrim, 0.4)
                color: Qt.alpha("red", 0.4)
                Behavior on opacity {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }
        }
    }
}
