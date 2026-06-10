pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as C
import QtQuick.Layouts
import Material3
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.QuickSettings.Models
import qs.Features.Bar.QuickSettings.Components
import qs.Shared.Components
import qs.Core
import Quickshell.Bluetooth

ChildPage {
    id: view

    readonly property BluetoothViewModel model: BluetoothViewModel {}

    header: ColumnLayout {
        spacing: 0
        TopAppBar {
            Layout.fillWidth: true
            focusPolicy: Qt.TabFocus
            topLeftRadius: view.radius
            topRightRadius: view.radius
            headlineText: "Bluetooth"
            horizontalPadding: LayoutSemenatics.pageHorizontalPadding
            leading: BackButton {
                onClicked: {
                    view.StackView.view.pop();
                }
            }
        }
        ProgressBar {
            Layout.fillWidth: true
            indeterminate: true
            stopIndicator: null
        }
    }
    focusPolicy: Qt.TabFocus
    contentItem: C.ScrollView {
        clip: true

        verticalPadding: LayoutSemenatics.pageVerticalPadding
        horizontalPadding: LayoutSemenatics.pageHorizontalPadding

        ColumnLayout {
            width: view.availableWidth - LayoutSemenatics.pageHorizontalPadding * 2
            spacing: 18

            SegmentedList {
                label: "Paired Devices"
                model: view.model.pairedDevices
                visible: model.values.length > 0
            }
            SegmentedList {
                label: "Available Devices"
                model: view.model.availableDevices
            }
        }
    }

    component SegmentedList: LabeledList {
        id: list
        Layout.fillWidth: true

        delegate: BluetoothDeviceDelegate {
            lastIndex: list.lastIndex
        }
    }

    component BluetoothDeviceDelegate: ListItem {
        id: item
        required property int index
        required property int lastIndex
        required property BluetoothDevice modelData
        readonly property bool connected: modelData?.connected ?? false
        subtitleText: {
            if (connected) {
                return "Connected";
            }
            if (modelData && (modelData.pairing || modelData.state == BluetoothDeviceState.Connecting)) {
                return "Connecting";
            }
            return null;
        }
        elevation: 0
        colors: {
            const cs = MaterialTheme.colorScheme;
            const colors = ListDefaults.colors(cs);
            colors.backgroundColor = connected ? cs.secondaryContainer : cs.surfaceContainerHigh;
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
        onClicked: {
            view.model.connect(modelData);
        }

        trailing: Loader {
            sourceComponent: item.modelData?.paired ?? false ? iconButton : iconContainer

            Component {
                id: iconContainer
                Item {
                    implicitHeight: IconButtonDefaults.smallHeight
                    implicitWidth: IconButtonDefaults.smallUniformPadding * 2 + icon.implicitWidth
                    Icon {
                        id: icon
                        anchors.centerIn: parent
                        name: "lock"
                        size: ListDefaults.iconSize
                    }
                }
            }
            Component {
                id: iconButton
                IconButton {
                    icon.name: "more_vert"

                    iconSize: ListDefaults.iconSize
                    onClicked: {}
                }
            }
        }
    }
}
