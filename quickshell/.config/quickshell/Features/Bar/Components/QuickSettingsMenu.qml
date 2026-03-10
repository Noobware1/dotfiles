pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar.Components.QuickSettings

Rectangle {
    id: menu
    property real horizontalPadding: 16
    property real verticalPadding: 10
    color: MaterialTheme.colorScheme.surface
    readonly property real maxPileWidth: 200
    readonly property real minPileWidth: (maxPileWidth / 2) - (layout.spacing / 2)
    readonly property real pileHeight: ButtonDefaults.mediumHeight
    border.width: editMode ? 2 : -1
    border.color: MaterialTheme.colorScheme.primary
    // implicitHeight: column.implicitHeight + (verticalPadding * 2)
    // implicitWidth: column.implicitWidth + (horizontalPadding * 2)
    implicitHeight: 700
    implicitWidth: 600

    radius: 20

    property bool editMode: false
    onEditModeChanged: {
        group.lastPressedButton = null;
    }

    ButtonGroup {
        id: group
        exclusive: false
        animate: !menu.editMode
        buttons: layout.children.map(e => e != repeater)
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
            // idk why it is like this
            Layout.preferredWidth: (menu.maxPileWidth * 2) + spacing + 1
            // clip: true
            spacing: 6
            Repeater {
                id: repeater
                model: 8
                delegate: QuickButton {
                    id: button
                    required property int index
                    editMode: menu.editMode
                    selected: this === group.lastPressedButton
                    containerHeight: menu.pileHeight
                    implicitHeight: containerHeight
                    minimumWidth: menu.minPileWidth
                    maximumWidth: menu.maxPileWidth
                    icon.name: ""
                    text: index
                    onDropped: function (event) {
                        const temp = layout.children[0];
                        layout.children[0] = temp;
                        layout.children[index] = temp;
                    // console.log(event);
                    }
                }
            }

            move: Transition {
                enabled: menu.editMode
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
                    menu.editMode = !menu.editMode;
                }
            }
        }
    }
}
