// pragma ComponentBehavior: Bound
import QtQuick
import Material3
import Quickshell
import qs.Shared.Components

Dialog {
    id: dialog
    closePolicy: Dialog.CloseOnPressOutside

    overlay: QsOverlay {}

    // overlay: Item {
    //     Rectangle {
    //         id: rect
    //         anchors.centerIn: parent
    //         property var window: QsWindow.window
    //         Binding {
    //             when: rect.window instanceof QsPopup
    //             rect {
    //                 height: (rect.window as QsPopup).popupHeight
    //                 width: (rect.window as QsPopup).popupWidth
    //                 radius: (rect.window as QsPopup).radius
    //             }
    //         }
    //
    //         height: parent.height
    //         width: parent.width
    //         color: Qt.alpha(MaterialTheme.colorScheme.scrim, 0.4)
    //     }
    // }
}
