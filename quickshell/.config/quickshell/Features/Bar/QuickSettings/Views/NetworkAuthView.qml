import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.QuickSettings.Models
import qs.Shared.Components
import qs.Core
import Quickshell.Networking

Page {
    id: view
    property QuickSettingsMenu menu: StackView.view as QuickSettingsMenu
    implicitHeight: menu?.implicitHeight ?? 0
    implicitWidth: menu?.implicitWidth ?? 0
    radius: menu?.radius ?? 0
    backgroundColor: menu?.backgroundColor ?? "transparent"
    required property WifiNetwork network
    property string password: ""

    function connect(): void {
    }

    Connections {
        target: view.network
        function onConnectionFailed(reason: int): void {
            console.log(ConnectionFailReason.toString(reason));
        }
    }

    header: TopAppBar {
        focusPolicy: Qt.TabFocus
        topLeftRadius: view.radius
        topRightRadius: view.radius
        headlineText: `Connect to ${view.network.name}`
        leadingItem: BackButton {
            onClicked: {
                view.StackView.view.pop();
            }
        }
    }
    focusPolicy: Qt.TabFocus
    verticalPadding: LayoutSemenatics.pageVerticalPadding
    horizontalPadding: LayoutSemenatics.pageHorizontalPadding
    contentItem: ColumnLayout {
        spacing: 12
        PasswordField {
            Binding {
                target: view
                property: "password"
                value: view.contentItem.children[0].text
            }
            onAccepted: connect()
        }
        ListItem {
            radius: 16
            Layout.fillWidth: true
            text: "Advanced options"
            implicitHeight: 68
            colors: {
                const cs = MaterialTheme.colorScheme;
                const colors = ListDefaults.colors(cs);
                colors.backgroundColor = cs.surfaceContainerHigh;
                return colors;
            }
            onClicked: {
                const button = trailing.children[0] as IconButton;
                button.toggle();
            }
            trailing: Item {
                implicitHeight: button.implicitHeight
                implicitWidth: button.implicitWidth
                IconButton {
                    id: button
                    anchors.centerIn: parent
                    implicitHeight: size + 12
                    variant: ButtonVariant.Filled
                    horizontalPadding: IconButtonDefaults.smallNarrowPadding
                    checkable: true
                    size: ListDefaults.iconSize
                    icon.name: checked ? "arrow_drop_up" : "arrow_drop_down"
                }
            }
        }
        RowLayout {
            Spacer {}
            Button {
                variant: ButtonVariant.Outlined
                text: "Cancel"
            }
            Button {
                text: "Connect"
                onClicked: {
                    view.connect();
                }
            }
        }
        VerticalSpacer {}
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
