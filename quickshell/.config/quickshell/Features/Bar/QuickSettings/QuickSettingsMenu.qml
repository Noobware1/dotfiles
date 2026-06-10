pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import Material3
import qs.Features.Bar.QuickSettings.Views
import qs.Shared.Components
import qs.Core
import qs.Features.Bar
import Quickshell

QsPopupLoader {
    id: root
    required property int barDirection
    readonly property bool isLeft: barDirection == BarDirection.Left
    readonly property bool isRigth: barDirection == BarDirection.Right
    readonly property PanelWindow window: WindowManager.barWindow
    QsPopup {
        id: popup
        radius: 28
        anchor.window: root.window
        x: {
            if (root.isLeft) {
                return root.window.width + root.window.width / 3.5;
            } else {
                return width;
            }
        }
        // color: "red"
        // y: root.window.width / 2
        y: 8

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
                implicitHeight: Screen.height - 24
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
