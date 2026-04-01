pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Material3
import QtQuick.Controls as C
import Quickshell
import qs.Features.Bar.Components

PanelWindow {
    implicitHeight: rect.height
    implicitWidth: rect.width
    color: "transparent"
    anchors.top: true
    anchors.right: true
    focusable: true

    Rectangle {
        id: rect
        radius: 32
        implicitHeight: flickable.contentHeight + 20
        implicitWidth: flickable.contentWidth + 20
        color: MaterialTheme.colorScheme.surface
        border.width: 2
        border.color: MaterialTheme.colorScheme.primary
        readonly property real maxPileWidth: 200
        readonly property real spacing: 6
        readonly property real minPileWidth: (maxPileWidth / 2) - (spacing / 2)
        readonly property real pileHeight: ButtonDefaults.mediumHeight

        C.SwipeView {
            id: flickable
            anchors.centerIn: parent
            contentHeight: (rect.pileHeight * 3) + (rect.spacing * 2)
            contentWidth: (rect.maxPileWidth * 2) + rect.spacing
            clip: true
            onCurrentIndexChanged: {
                console.log(currentIndex);
            }

            // orientation: Qt.Vertical
            Repeater {
                model: 4
                Flow {
                    id: layout
                    height: flickable.contentHeight
                    width: flickable.contentWidth

                    // anchors.fill: parent
                    spacing: rect.spacing

                    Repeater {
                        id: repeater
                        model: 5
                        Item {
                            required property int index
                            height: button.height
                            width: button.width

                            QuickButton {
                                id: button
                                index: -1
                                minimumWidth: rect.minPileWidth
                                maximumWidth: rect.maxPileWidth
                                containerHeight: rect.pileHeight
                                implicitHeight: containerHeight
                                expanded: true
                                dragParent: rect
                                checkable: true
                                icon.name: checked ? "do_not_disturb_off" : "do_not_disturb_off"
                                editMode: true

                                text: "Do not disturb"
                            }
                        }
                    }
                }
            }
        }
    }
}
