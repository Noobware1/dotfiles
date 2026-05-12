pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import Material3
import QtQuick

LazyLoader {
    id: loader
    property QtObject window
    property real x
    property real y

    function toggle() {
        if (active) {
            close();
        } else {
            open();
        }
    }

    function close() {
        if (active) {
            item.close();
        }
    }

    function open() {
        loading = true;
        // (item as PopupDelegate).dismissable.open();
    }

    default property Component content

    // component: QsPopup {
    //     anchor.window: loader.window
    //     x: loader.x
    //     y: loader.y
    //     focus: true
    //     content: Loader {
    //         sourceComponent: loader.content
    //     }
    //     onClosed: {
    //         loader.active = false;
    //     }
    // }
    // PopupWindow {
    //     id: window
    //
    //     visible: true
    //     property real x: loader.x
    //     property real y: loader.y
    //     anchor.window: loader.window
    //
    //     property real elevation: 4
    //     property real radius: 24
    //     property color backgroundColor: MaterialTheme.colorScheme.surfaceContainer
    //
    //     property real padding: 0
    //     property real horizontalPadding: padding
    //     property real verticalPadding: padding
    //     property real leftPadding: horizontalPadding
    //     property real topPadding: verticalPadding
    //     property real bottomPadding: verticalPadding
    //     property real rightPadding: horizontalPadding
    //     property bool modal: false
    //     property bool focus: false
    //     // property alias enter: popup.enter
    //     // property alias exit: popup.exit
    //     property real elevationPadding: elevation > 0 ? 6 : 0
    //     property Component content: loader.content
    //
    //     signal aboutToShow
    //     signal aboutToHide
    //     signal opened
    //     property real elevationGap: 6
    //     anchor.rect.x: window.x - elevationGap / 2
    //     anchor.rect.y: window.y - elevationGap / 2
    //
    //     implicitHeight: popup.implicitHeight + elevationGap
    //     implicitWidth: popup.implicitWidth + elevationGap
    //     color: "transparent"
    //
    //     property alias dismissable: popup
    //
    //     Popup {
    //         id: popup
    //         elevation: window.elevation
    //         radius: window.radius
    //         backgroundColor: window.backgroundColor
    //         padding: window.padding
    //         horizontalPadding: window.horizontalPadding
    //         verticalPadding: window.verticalPadding
    //         topPadding: window.topPadding
    //         leftPadding: window.leftPadding
    //         bottomPadding: window.bottomPadding
    //         rightPadding: window.rightPadding
    //         focus: true
    //         modal: true
    //         contentItem: Loader {
    //             sourceComponent: window.content
    //         }
    //
    //         onClosed: {
    //             grab.active = false;
    //             window.closed();
    //         }
    //
    //         visible: true
    //         opacity: 0
    //         onAboutToHide: {
    //             window.aboutToHide();
    //         }
    //         onAboutToShow: {
    //             window.aboutToShow();
    //         }
    //         // y: -popup.implicitHeight
    //         // x: window.elevationGap / 2
    //         x: popup.implicitWidth
    //
    //         enter: Transition {
    //             PropertyAnimation {
    //                 property: "opacity"
    //                 from: 0
    //                 to: 1
    //                 easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
    //                 easing.type: Easing.BezierSpline
    //                 duration: MotionSpecs.expressiveDefaultSpatialDuration
    //             }
    //             DefaultAnimation {
    //                 from: popup.implicitWidth
    //                 to: window.elevationGap / 2
    //             }
    //         }
    //
    //         exit: Transition {
    //             PropertyAnimation {
    //                 property: "opacity"
    //                 from: 1
    //                 to: 0
    //                 easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
    //                 easing.type: Easing.BezierSpline
    //                 duration: MotionSpecs.expressiveDefaultSpatialDuration
    //             }
    //             DefaultAnimation {
    //                 from: window.elevationGap / 2
    //                 to: popup.implicitWidth
    //             }
    //         }
    //     }
    //
    //     HyprlandFocusGrab {
    //         id: grab
    //         active: true
    //         windows: [window, window.anchor.window]
    //         onActiveChanged: {
    //             if (!active) {
    //                 popup.close();
    //             }
    //         }
    //     }
    // }

    component DefaultAnimation: NumberAnimation {
        property: "x"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}
