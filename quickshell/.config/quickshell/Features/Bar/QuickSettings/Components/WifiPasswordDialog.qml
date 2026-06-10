pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Material3
import qs.Shared.Components
import Quickshell.Networking

QsDialog {
    id: dialog
    modal: true

    property string passphrase

    signal connect

    Connections {
        target: dialog.network
        function onConnectionFailed(reason: int): void {
            dialog.showProgressIndicator = false;
            dialog.connectionFailed = true;
            console.log(ConnectionFailReason.toString(reason));
        }
        function onStateChanged(): void {
            if (dialog.network && dialog.network.state == ConnectionState.Connected) {
                dialog.close();
            }
        }
    }

    required property WifiNetwork network
    property bool connectionFailed: false

    title: `Connect to ${network?.name}`

    property bool showProgressIndicator: false

    topPadding: 0
    contentItem: ColumnLayout {
        spacing: 0
        ExplicitSpacer {
            vertical: DialogDefaults.headerAndBodyPadding / 2 + (dialog.showProgressIndicator ? 0 : 4)
        }
        ProgressBar {
            Layout.fillWidth: true
            indeterminate: true
            stopIndicator: null
            visible: dialog.showProgressIndicator
        }
        ExplicitSpacer {
            vertical: DialogDefaults.headerAndBodyPadding / 2
        }
        PasswordField {
            Layout.fillWidth: true
            onTextChanged: {
                dialog.passphrase = text;
                dialog.connectionFailed = false;
            }

            colors: {
                const cs = MaterialTheme.colorScheme;
                const colors = TextFieldDefaults.colors(cs);
                colors.backgroundColor = cs.surfaceContainer;
                return colors;
            }
            hasError: dialog.connectionFailed
            onAccepted: {
                dialog.showProgressIndicator = true;
                dialog.connect();
            }
        }
        ExplicitSpacer {
            vertical: 16
        }
    }
    footer: DialogButtonBox {
        Button {
            variant: ButtonVariant.Outlined
            DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
            text: "Cancel"
        }
        Button {
            text: "Connect"
            // DialogButtonBox.buttonRole: DialogButtonBox.ActionRole
            onClicked: {
                dialog.showProgressIndicator = true;
                dialog.connect();
            }
        }
    }

    component PasswordField: TextField {
        id: field

        Layout.fillWidth: true
        focus: true
        labelText: "Password"
        echoMode: TextInput.Password
        font: visiblityOn ? TextFieldDefaults.font(MaterialTheme.typography) : MaterialTheme.typography.bodySmall
        rightPadding: TextFieldDefaults.horizontalPadding + spacing + trailing.implicitWidth
        readonly property real spacing: 6
        inputMethodHints: Qt.ImhSensitiveData
        property bool visiblityOn: false
        Loader {
            id: trailing
            sourceComponent: field.hasError ? errorIcon : visibilityToggle
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: TextFieldDefaults.horizontalPadding

            Component {
                id: errorIcon
                Item {
                    implicitHeight: IconButtonDefaults.smallHeight
                    implicitWidth: IconButtonDefaults.smallUniformPadding * 2 + icon.implicitWidth
                    Icon {
                        id: icon
                        anchors.centerIn: parent
                        name: "error"
                        size: TextFieldDefaults.iconSize
                        color: field.colors.errorIndicatorColor
                    }
                }
            }
            Component {
                id: visibilityToggle
                IconButton {
                    icon.name: checked ? "visibility" : "visibility_off"
                    checkable: true
                    iconSize: TextFieldDefaults.iconSize
                    onToggled: {
                        field.visiblityOn = checked;
                        field.echoMode = checked ? TextInput.Normal : TextInput.Password;
                    }
                }
            }
        }
    }
}
