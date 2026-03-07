pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Material3
import Material3.Shape
import qs.Shared.Components
import qs.Features.Bar.Components.QuickSettings

Rectangle {
    id: menu
    property real horizontalPadding: 16
    property real verticalPadding: 10
    color: MaterialTheme.colorScheme.surface
    readonly property real maxPileWidth: 200
    readonly property real minPileWidth: (maxPileWidth / 2) - (layout.spacing / 2)
    readonly property real pileHeight: ButtonDefaults.mediumHeight
    border.width: __editMode ? 2 : -1
    border.color: MaterialTheme.colorScheme.primary
    implicitHeight: column.implicitHeight + (verticalPadding * 2)
    implicitWidth: column.implicitWidth + (horizontalPadding * 2)
    radius: 20

    property bool __editMode: false
    on__EditModeChanged: {
        group.lastPressedButton = null;
    }

    ButtonGroup {
        id: group
        exclusive: false
        animate: !menu.__editMode
        buttons: layout.children.filter(e => e != repeater)
        property var lastPressedButton
        onClicked: function (button) {
            lastPressedButton = button;
        }
    }

    ColumnLayout {
        id: column
        anchors.centerIn: parent

        spacing: 6

        Flow {
            id: layout
            Layout.preferredHeight: (menu.pileHeight * 3) + (spacing * 2)
            Layout.preferredWidth: (menu.maxPileWidth * 2) + spacing
            clip: true
            spacing: 6
            Repeater {
                id: repeater
                model: 8
                QuickButton {
                    editMode: menu.__editMode
                    selected: this === group.lastPressedButton
                    containerHeight: menu.pileHeight
                    implicitHeight: containerHeight
                    minimumWidth: menu.minPileWidth
                    maximumWidth: menu.maxPileWidth
                }
            }

            move: Transition {
                id: moveTrans
                enabled: menu.__editMode
                NumberAnimation {
                    properties: "x,y"
                    easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
                    easing.type: Easing.BezierSpline
                    duration: MotionSpecs.expressiveDefaultSpatialDuration
                }
            }
        }

        RowLayout {
            id: footer
            Layout.fillWidth: true
            Item {
                Layout.fillWidth: true
            }
            Button {
                variant: ButtonVariant.Outlined
                icon.name: "edit"
                onClicked: {
                    menu.__editMode = !menu.__editMode;
                }
            }
        }
    }
}
