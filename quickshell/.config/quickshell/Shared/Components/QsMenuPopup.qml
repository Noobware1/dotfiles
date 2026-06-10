import Quickshell
import Quickshell.Hyprland
import Material3
import QtQuick

PopupWindow {
    id: window

    property real x
    property real y
    readonly property real animatedX: menu.x
    readonly property real animatedY: menu.y

    property alias radius: menu.radius
    property alias elevation: menu.elevation
    property alias backgroundColor: menu.backgroundColor
    property alias padding: menu.padding
    property alias verticalPadding: menu.verticalPadding
    property alias horizontalPadding: menu.horizontalPadding
    property alias leftPadding: menu.leftPadding
    property alias topPadding: menu.topPadding
    property alias bottomPadding: menu.bottomPadding
    property alias rightPadding: menu.rightPadding
    property alias modal: menu.modal
    property alias focus: menu.focus
    property alias enter: menu.enter
    property alias exit: menu.exit
    property alias closePolicy: menu.closePolicy
    property real elevationPadding: elevation > 0 ? 6 : 0
    default property alias contentChildren: menu.contentChildren

    signal aboutToShow
    signal aboutToHide
    signal opened
    // already exists :(
    // signal closed

    function close() {
        menu.close();
    }

    function open() {
        menu.open();
    }

    anchor.rect.x: x - elevationPadding / 2
    anchor.rect.y: y - elevationPadding / 2

    implicitHeight: menu.implicitHeight + elevationPadding
    implicitWidth: menu.implicitWidth + elevationPadding

    readonly property real menuHeight: menu.implicitHeight
    readonly property real menuWidth: menu.implicitWidth

    color: "transparent"
    visible: true

    Menu {
        id: menu
        onAboutToHide: {
            grab.active = false;
            window.aboutToHide();
        }
        onAboutToShow: {
            window.aboutToShow();
        }
        onClosed: {
            window.closed();
        }
        onOpened: {
            window.opened();
        }
        modal: false
        focus: false

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    HyprlandFocusGrab {
        id: grab
        active: window.focus
        windows: [window, window.anchor.window]
        onActiveChanged: {
            if (!active) {
                menu.close();
            }
        }
    }
}
