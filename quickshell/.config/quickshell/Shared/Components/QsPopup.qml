import Quickshell
import Quickshell.Hyprland
import Material3
import QtQuick

PopupWindow {
    id: window

    property real x
    property real y
    readonly property real animatedX: popup.x
    readonly property real animatedY: popup.y

    readonly property real effectiveX: elevationPadding / 2
    readonly property real effectiveY: elevationPadding / 2

    property alias radius: popup.radius
    property alias elevation: popup.elevation
    property alias backgroundColor: popup.backgroundColor
    property alias padding: popup.padding
    property alias verticalPadding: popup.verticalPadding
    property alias horizontalPadding: popup.horizontalPadding
    property alias leftPadding: popup.leftPadding
    property alias topPadding: popup.topPadding
    property alias bottomPadding: popup.bottomPadding
    property alias rightPadding: popup.rightPadding
    property alias leftInset: popup.leftInset
    property alias topInset: popup.topInset
    property alias bottomInset: popup.bottomInset
    property alias rightInset: popup.rightInset
    property alias modal: popup.modal
    property alias focus: popup.focus
    property alias enter: popup.enter
    property alias exit: popup.exit
    property real elevationPadding: elevation > 0 ? 6 : 0
    default property alias content: popup.contentItem

    signal aboutToShow
    signal aboutToHide
    signal opened
    // already exists :(
    // signal closed

    function close() {
        popup.close();
    }

    function open() {
        popup.open();
    }

    // anchor.rect.x: x - elevationPadding / 2
    // anchor.rect.y: y - elevationPadding / 2
    anchor.rect.x: x
    anchor.rect.y: y

    // implicitHeight: popup.implicitHeight + elevationPadding
    implicitHeight: popup.implicitHeight + elevationPadding
    implicitWidth: popup.implicitWidth + elevationPadding

    readonly property real popupHeight: popup.implicitHeight
    readonly property real popupWidth: popup.implicitWidth

    color: "transparent"
    visible: true

    Popup {
        id: popup
        height: parent.height - window.elevationPadding
        width: parent.width - window.elevationPadding
        x: window.effectiveX
        y: window.effectiveY
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
        elevation: 4
        radius: 24
        backgroundColor: MaterialTheme.colorScheme.surfaceContainer

        padding: 0
        modal: false
        focus: false
    }

    HyprlandFocusGrab {
        id: grab
        active: window.focus
        windows: [window, window.anchor.window]
        onActiveChanged: {
            if (!active) {
                popup.close();
            }
        }
    }
}
