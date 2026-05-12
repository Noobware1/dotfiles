import QtQuick
import Quickshell
import Material3

Item {
    Behavior on opacity {
        NumberAnimation {
            duration: MotionSpecs.durationShort3
        }
    }
    Rectangle {
        id: rect
        color: Qt.alpha(MaterialTheme.colorScheme.scrim, 0.4)

        Binding {
            id: popupBinding
            when: QsWindow.window instanceof QsPopup
            readonly property QsPopup popup: when ? QsWindow.window as QsPopup : null
            rect {
                x: popupBinding.popup.elevationPadding / 2
                y: popupBinding.popup.elevationPadding / 2
                radius: popupBinding.popup.radius
                height: popupBinding.popup.implicitHeight - popupBinding.popup.elevationPadding
                width: popupBinding.popup.implicitWidth - popupBinding.popup.elevationPadding
            }
        }
    }
}
