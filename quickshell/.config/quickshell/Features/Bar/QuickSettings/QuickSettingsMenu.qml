pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import Material3
import qs.Features.Bar.QuickSettings.Views
import qs.Shared.Components
import qs.Core
import qs.Features.Bar
import Quickshell
import Quickshell.Hyprland

QsPopupLoader {
    id: root

    required property int orientation
    readonly property bool horizontal: orientation == Qt.Horizontal
    required property int barDirection
    readonly property bool isLeft: barDirection == BarDirection.Left
    readonly property bool isRight: barDirection == BarDirection.Right
    readonly property bool isTop: barDirection == BarDirection.Top
    readonly property PanelWindow window: WindowManager.barWindow
    readonly property real margins: 10

    readonly property Binding __binding: Binding {
        target: GlobalState
        property: "quickSettingsMenuOpen"
        value: root.active
    }

    QsPopup {
        id: popup
        radius: 28
        anchor.window: root.window
        x: {
            switch (root.barDirection) {
            case BarDirection.Left:
                return root.window.width + root.margins;
            case BarDirection.Right:
            case BarDirection.Bottom:
            case BarDirection.Top:
            default:
                return root.window.width - width - root.margins;
            }
        }
        y: {
            switch (root.barDirection) {
            case BarDirection.Left:
            case BarDirection.Right:
            case BarDirection.Bottom:
                return root.margins;
            case BarDirection.Top:
            default:
                return root.window.height + root.margins;
            }
        }

        // don't know why but if i don't do this swipe acts weird
        property bool ready: false
        onAboutToShow: {
            ready = true;
        }
        Loader {
            active: popup.ready
            sourceComponent: StackView {
                id: stackView
                readonly property real radius: popup.radius
                readonly property color backgroundColor: popup.backgroundColor
                implicitHeight: Screen.height - root.margins * 2 - (root.horizontal ? root.window.height : 0)
                focusPolicy: Qt.TabFocus

                initialItem: QuickSettingsView {
                    id: view
                    radius: stackView.radius
                    Binding {
                        target: stackView
                        property: "implicitWidth"
                        value: view.implicitWidth
                    }
                }
            }
        }
        backgroundColor: MaterialTheme.colorScheme.surface
        focus: true
        enter: Transition {
            PropertyAction {
                property: "x"
                value: root.isLeft ? -popup.implicitWidth : popup.implicitWidth
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
                from: root.isLeft ? -popup.implicitWidth : popup.implicitWidth
                to: popup.effectiveX
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
                from: popup.effectiveX
                to: root.isLeft ? -popup.implicitWidth : popup.implicitWidth
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
