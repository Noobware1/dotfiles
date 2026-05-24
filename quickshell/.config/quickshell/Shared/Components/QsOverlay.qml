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

        readonly property var window: QsWindow.window

        Binding {
            when: QsWindow.window instanceof QsPopup
            rect {
                x: rect.window.animatedX
                y: rect.window.animatedY
                radius: rect.window.radius
                height: rect.window.popupHeight
                width: rect.window.popupWidth
            }
        }
    }
}
