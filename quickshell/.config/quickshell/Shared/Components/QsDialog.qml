pragma ComponentBehavior: Bound
import QtQuick
import Material3
import Quickshell
import qs.Shared.Components

Dialog {
    id: dialog
    closePolicy: Dialog.CloseOnPressOutside

    overlay: Item {
        Rectangle {
            anchors.centerIn: parent
            property Popup popup: QsWindow.window.dismissable

            height: popup?.height ?? parent.width
            width: popup?.width ?? parent.height
            color: Qt.alpha(MaterialTheme.colorScheme.scrim, 0.4)
            radius: popup?.radius ?? 0
        }
    }
}
