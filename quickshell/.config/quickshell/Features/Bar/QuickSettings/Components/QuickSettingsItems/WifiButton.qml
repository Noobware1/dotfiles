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

// import qs.Services
// import Quickshell.Networking

SplitToggleButton {
    id: button
    icon.name: "wifi"
    required property DialogHandler dialogHandler
    // property Network network: NetworkService.connectedNetwork
    // text: {
    //     if (network) {
    //         return network.name;
    //     } else {
    //         return "[No Name]";
    //     }
    // }
    text: "PlaceHolder"
    onClicked: {
        dialogHandler.openDialog(dialogDelegate);
        // __dialog.open();
        // navigationStack.push(internetView);
    }

    Component {
        id: dialogDelegate
        // id: internetView
        Dialog {
            id: dialog
            title: "Internet"
            subtitle: "Tap a network to connect"
            modal: true
            focus: true
            height: 400
            headerSpacing: 4
            width: parent.width - LayoutSemenatics.pageHorizontalPadding * 2
            x: (parent.width - width) / 2 // center horizontally
            y: button.parent.mapToItem(parent, 0, 0).y // position on top of button parent
            header: ColumnLayout {
                width: dialog.width
                spacing: dialog.headerSpacing
                Text {
                    Layout.topMargin: dialog.headerPadding
                    Layout.fillWidth: true
                    Layout.rightMargin: dialog.rightPadding
                    Layout.leftMargin: dialog.leftPadding
                    horizontalAlignment: Text.AlignHCenter
                    text: dialog.title
                    font: DialogDefaults.titleFont(MaterialTheme.typography)
                    color: dialog.colors.titleColor
                    wrapMode: Text.WordWrap
                }
                Text {
                    Layout.fillWidth: true
                    Layout.rightMargin: dialog.rightPadding
                    Layout.leftMargin: dialog.leftPadding
                    horizontalAlignment: Text.AlignHCenter
                    text: dialog.subtitle
                    font: DialogDefaults.subtitleFont(MaterialTheme.typography)
                    color: dialog.colors.subtitleColor
                    wrapMode: Text.WordWrap
                }
                // Item {
                //     implicitHeight: DialogDefaults.headerAndBodyPadding
                //     Layout.fillWidth: true
                //     Divider {
                //         anchors.horizontalCenter: parent.horizontalCenter
                //         anchors.bottom: parent.bottom
                //         width: dialog.availableWidth
                //         height: 2
                //     }
                // }
            }
            // footer: DialogButtonBox {
            //     alignment: Qt.AlignHCenter
            //     Button {
            //         variant: ButtonVariant.Text
            //         text: "More"
            //     }
            // }
            // topPadding: 0
            // bottomPadding: 8
            // footerPadding: 8
            contentItem: C.ScrollView {
                clip: true
                verticalPadding: LayoutSemenatics.pageVerticalPadding

                ColumnLayout {
                    width: dialog.availableWidth
                    LabelAndItem {
                        label: "Saved Networks"
                        model: 4
                    }
                    VerticalSpacer {
                        value: 18
                    }
                    LabelAndItem {
                        label: "Networks"
                        model: 20
                    }
                }
            }
        }
    }

    component LabelAndItem: ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        property alias label: _label.text
        property alias model: repeater.model
        Label {
            id: _label
            text: "Saved Networks"
            font: MaterialTheme.typography.titleMedium
            color: MaterialTheme.colorScheme.onSurface
        }
        VerticalSpacer {
            value: 16
        }
        Repeater {
            id: repeater
            model: 4
            delegate: MListItem {
                Layout.fillWidth: true
                lastIndex: repeater.count - 1
            }
        }
    }

    component MListItem: ListItem {
        id: item
        required property int index
        required property int lastIndex
        property var modelData: {
            return {
                name: "SITI FIBER 5G",
                connected: false
            };
        }
        subtitleText: (modelData?.connected ?? false) ? "connected" : ""
        elevation: 0
        colors: {
            const cs = MaterialTheme.colorScheme;
            const colors = ListDefaults.colors(cs);
            colors.backgroundColor = cs.surfaceContainerHigh;
            return colors;
        }
        topLeftRadius: index == 0 ? height / 2 : radius
        topRightRadius: index == 0 ? height / 2 : radius
        bottomLeftRadius: index == lastIndex ? height / 2 : radius
        bottomRightRadius: index == lastIndex ? height / 2 : radius
        leading: Icon {
            anchors.centerIn: parent
            name: "wifi"
            size: ListDefaults.iconSize
            color: item.colors.secondaryContentColor
        }
        text: modelData?.name ?? "[No Name]"
        trailing: IconButton {
            anchors.centerIn: parent
            icon.name: "more_vert"
        }
    }
}
