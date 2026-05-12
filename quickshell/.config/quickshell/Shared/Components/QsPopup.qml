import Quickshell
import Quickshell.Hyprland
import Material3
import QtQuick

PopupWindow {
    id: window

    property real x
    property real y

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

    anchor.rect.x: x - elevationPadding / 2
    anchor.rect.y: y - elevationPadding / 2

    implicitHeight: popup.implicitHeight + elevationPadding
    implicitWidth: popup.implicitWidth + elevationPadding

    readonly property real popupHeight: popup.implicitHeight
    readonly property real popupWidth: popup.implicitWidth

    color: "transparent"
    visible: true

    Popup {
        id: popup
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
        enter: Transition {
            PropertyAction {
                property: "x"
                value: popup.implicitWidth
            }
            PropertyAction {
                property: "opacity"
                value: 0
            }
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
                easing.type: Easing.BezierSpline
                duration: MotionSpecs.expressiveDefaultSpatialDuration
            }
            DefaultAnimation {
                from: popup.implicitWidth
                to: window.elevationPadding / 2
            }
        }

        exit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
                easing.type: Easing.BezierSpline
                duration: MotionSpecs.expressiveDefaultSpatialDuration
            }
            DefaultAnimation {
                from: window.elevationPadding / 2
                to: popup.implicitWidth
            }
        }
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

    component DefaultAnimation: NumberAnimation {
        property: "x"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}
