pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as C
import QtQuick.Layouts
import Material3
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.QuickSettings.Views
import qs.Features.Bar.QuickSettings.Models
import qs.Shared.Components
import qs.Core
import Quickshell.Networking

Page {
    id: view
    property QuickSettingsMenu menu: StackView.view as QuickSettingsMenu
    readonly property InternetViewModel model: InternetViewModel {}
    implicitHeight: menu?.implicitHeight ?? 0
    implicitWidth: menu?.implicitWidth ?? 0
    radius: menu?.radius ?? 0
    backgroundColor: menu?.backgroundColor ?? "transparent"

    PasswordDialog{ id: dialog }

    header: TopAppBar {
        focusPolicy: Qt.TabFocus
        topLeftRadius: view.radius
        topRightRadius: view.radius
        headlineText: "Internet"
        leadingItem: BackButton {
            onClicked: {
                view.StackView.view.pop();
            }
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
                label: "Saved Networks"
                model: view.model.savedNetworks
                visible: model.values.length > 0
            }
            SegmentedList {
                label: "Networks"
                model: view.model.availableNetworks
            }
        }
    }

    component SegmentedList: LabeledList {
        id: list
        Layout.fillWidth: true
        delegate: ListItem {
            id: item
            required property int index
            readonly property int lastIndex: list.lastIndex
            required property WifiNetwork modelData
            readonly property bool connected: (modelData?.connected ?? false)
            subtitleText: {
                if (connected) {
                    return "Connected";
                }
                if (modelData && modelData.state == ConnectionState.Connecting) {
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
                dialog.open(modelData);
            }
            trailing: Loader {
                anchors.centerIn: parent
                sourceComponent: (item.modelData?.known ?? false) ? moreButton : lockedIcon
                Component {
                    id: lockedIcon
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
                    id: moreButton
                    IconButton {
                        icon.name: "more_vert"
                    }
                }
            }
        }
    }

    component PasswordDialog: Loader {
        id: __loader
        active: false
        width: view.width - LayoutSemenatics.pageHorizontalPadding * 2
        property WifiNetwork network

        function open(network: WifiNetwork): void {
            if (!network) {
                return;
            }
            active = true;
        }

        onLoaded: {
            const dialog = (item as QsDialog);
            dialog.open();
        }
        sourceComponent: QsDialog {
            id: __dialog
            modal: true
            onClosed: {
                __loader.active = false;
            }
            Connections {
                target: dialog.network
                function onConnectionFailed(reason: int): void {
                    console.log(ConnectionFailReason.toString(reason));
                }
            }
            readonly property WifiNetwork network: __loader.network

            property string passphrase
            width: __loader.width
            y: LayoutSemenatics.pageVerticalPadding + height / 2
            x: (view.implicitWidth - width) / 2
            title: `Connect to ${network?.name}`
            contentItem: PasswordField {
                onTextChanged: {
                    dialog.passphrase = text;
                }
                colors: {
                    const cs = MaterialTheme.colorScheme;
                    const colors = TextFieldDefaults.colors(cs);
                    colors.backgroundColor = cs.surfaceContainer;
                    return colors;
                }
                onAccepted: {
                    view.model.connect(dialog.network, text);
                }
            }
            footer: DialogButtonBox {
                Button {
                    variant: ButtonVariant.Outlined
                    text: "Cancel"
                    onClicked: {
                        __dialog.close();
                    }
                }
                Button {
                    text: "Connect"
                    onClicked: {
                        view.model.connect(dialog.network, __dialog.passphrase);
                    }
                }
            }
        }
    }

    component PasswordField: TextField {
        id: field

        Layout.fillWidth: true
        focus: true
        labelText: "Password"
        echoMode: TextInput.Password
        font: showPassword.checked ? TextFieldDefaults.font(MaterialTheme.typography) : MaterialTheme.typography.bodySmall
        rightPadding: TextFieldDefaults.horizontalPadding + 6 + showPassword.width
        inputMethodHints: Qt.ImhSensitiveData
        IconButton {
            id: showPassword
            onToggled: {
                field.echoMode = checked ? TextInput.Normal : TextInput.Password;
            }
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: TextFieldDefaults.horizontalPadding
            icon.name: checked ? "visibility" : "visibility_off"
            checkable: true
        }
    }
}
