pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar.Models
import qs.Features.Bar.Components.QuickItems

Rectangle {
    id: menu
    property real horizontalPadding: 16
    property real verticalPadding: 10
    color: MaterialTheme.colorScheme.surface
    readonly property real maxPileWidth: 200
    readonly property real minPileWidth: (maxPileWidth / 2) - (layout.spacing / 2)
    readonly property real pileHeight: ButtonDefaults.mediumHeight
    border.width: -1
    border.color: MaterialTheme.colorScheme.primary
    implicitHeight: 700
    implicitWidth: 600

    radius: 20

    property bool editMode: false
    onEditModeChanged: {
        // group.lastPressedButton = null;
        if (!editMode) {
            menu.model.saveState();
        }
    }

    Component.onDestruction: {
        menu.model.saveState();
    }

    readonly property QuickSettingsModel model: QuickSettingsModel {}

    // ButtonGroup {
    //     id: group
    //     exclusive: false
    //     animate: !menu.editMode
    //     buttons: layout.children.filter(e => e !== repeater).map(function (e) {
    //         if (e instanceof QuickButton) {
    //             return e;
    //         } else {
    //             return e.button;
    //         }
    //     })
    //
    //     property var lastPressedButton
    //     onClicked: function (button) {
    //         lastPressedButton = button;
    //     }
    // }

    ColumnLayout {
        id: column
        anchors.centerIn: parent
        spacing: 6

        Rectangle {
            id: border
            Layout.preferredHeight: layout.height + 24
            Layout.preferredWidth: layout.width + 24
            radius: 24
            color: "transparent"

            border.width: menu.editMode ? 2 : -1
            border.color: MaterialTheme.colorScheme.primary

            Flow {
                id: layout
                anchors.centerIn: parent

                height: (menu.pileHeight * 3) + (spacing * 2)
                width: (menu.maxPileWidth * 2) + spacing + 1
                spacing: 6

                Repeater {
                    id: repeater
                    model: DelegateModel {
                        id: visualModel
                        model: menu.model.quickItemsModel
                        delegate: DelegateChooser {
                            role: "type"
                            choices: [
                                ButtonDelegate {
                                    roleValue: QuickSettingsModel.Wifi
                                    WifiButton {
                                        minimumWidth: menu.minPileWidth
                                        maximumWidth: menu.maxPileWidth
                                        containerHeight: menu.pileHeight
                                        implicitHeight: menu.pileHeight
                                    }
                                },
                                ButtonDelegate {
                                    roleValue: QuickSettingsModel.Bluetooth
                                    BluetoothButton {
                                        minimumWidth: menu.minPileWidth
                                        maximumWidth: menu.maxPileWidth
                                        containerHeight: menu.pileHeight
                                        implicitHeight: menu.pileHeight
                                    }
                                },
                                ButtonDelegate {
                                    roleValue: QuickSettingsModel.Dnd
                                    DoNotDisturbButton {
                                        minimumWidth: menu.minPileWidth
                                        maximumWidth: menu.maxPileWidth
                                        containerHeight: menu.pileHeight
                                        implicitHeight: menu.pileHeight
                                    }
                                },
                                ButtonDelegate {
                                    roleValue: QuickSettingsModel.DarkMode
                                    DarkModeButton {
                                        minimumWidth: menu.minPileWidth
                                        maximumWidth: menu.maxPileWidth
                                        containerHeight: menu.pileHeight
                                        implicitHeight: menu.pileHeight
                                    }
                                },
                                ButtonDelegate {
                                    roleValue: QuickSettingsModel.PowerMode
                                    PowerModeButton {
                                        minimumWidth: menu.minPileWidth
                                        maximumWidth: menu.maxPileWidth
                                        containerHeight: menu.pileHeight
                                        implicitHeight: menu.pileHeight
                                    }
                                }
                            ]
                        }
                    }

                    property bool entered: false

                    onItemAdded: function (_, item) {
                        const button = item.button as QuickButton;

                        button.editMode = Qt.binding(() => menu.editMode);
                        // button.expanded = Qt.binding(() => item.expanded);
                        button.selected = Qt.binding(() => true);
                        // button.dragParent = Qt.binding(() => ghost);
                        button.drag.connect(function (x, y) {
                            const item = repeater.itemAt(0);
                            const centerX = item.x + item.width / 2;
                            const centerY = item.y + item.height / 2;

                            const pos = button.mapToItem(layout, x, y);
                            if (pos.x < centerX && pos.y <= centerY) {
                                if (repeater.entered) {
                                    return;
                                }
                                visualModel.items.move(button.index, item.index);
                                repeater.entered = true;
                            }
                        });
                    }
                }

                Item {
                    id: ghost
                    height: children[0]?.height ?? 0
                    width: children[0]?.width ?? 0
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

    // component ButtonDelegate: DelegateChoice {}

    component ButtonDelegate: DelegateChoice {
        id: choice
        default property Component buttonDelegate
        Item {
            id: dropArea

            property int index: DelegateModel.itemsIndex
            required property var modelData

            height: menu.pileHeight
            width: button.width

            states: State {
                when: button.Drag.active
                PropertyChanges {
                    dropArea.z: 1000
                }
            }

            property QuickButton button: choice.buttonDelegate.createObject(dropArea, {
                index: Qt.binding(() => dropArea.index),
                expanded: Qt.binding(() => dropArea.modelData.expanded),
                editMode: Qt.binding(() => menu.editMode),
                // selected: Qt.binding(() => group.lastPressedButton === dropArea.button),
                selected: Qt.binding(() => true),
                dragParent: Qt.binding(() => dropArea),
                containerHeight: Qt.binding(() => menu.pileHeight),
                maximumWidth: Qt.binding(() => menu.maxPileWidth),
                minimumWidth: Qt.binding(() => menu.minPileWidth)
            }) as QuickButton
        }
    }

    // component ButtonDelegate: DelegateChoice {
    //     id: choice
    //     default property Component buttonDelegate
    //     DropArea {
    //         id: dropArea
    //
    //         property int index: DelegateModel.itemsIndex
    //         required property var modelData
    //
    //         height: menu.pileHeight
    //         width: button.Drag.active ? menu.maxPileWidth : button.width
    //         // width: button.width
    //
    //         // onPositionChanged: function (drag) {
    //         //     if (!(drag.source instanceof QuickButton))
    //         //         return;
    //         //
    //         //     const source = drag.source as QuickButton;
    //         //     if (source === button)
    //         //         return;
    //         //
    //         //     const sourceIndex = source.index;
    //         //     const targetIndex = index;
    //         //
    //         //     // center of dragged item in Flow coordinates
    //         //     const sourcePos = source.mapToItem(layout, source.width / 2, source.height / 2);
    //         //     const dragCenterX = sourcePos.x;
    //         //     const dragCenterY = sourcePos.y;
    //         //
    //         //     // center of target item
    //         //     const targetCenterX = dropArea.x + dropArea.width / 2;
    //         //     const targetCenterY = dropArea.y + dropArea.height / 2;
    //         //
    //         //     // ensure both items are on the same row
    //         //     const sameRow = Math.abs(dragCenterY - targetCenterY) < dropArea.height / 2;
    //         //
    //         //     if (!sameRow)
    //         //         return;
    //         //
    //         //     if (sourceIndex < targetIndex && dragCenterX > targetCenterX + 8) {
    //         //         visualModel.items.move(sourceIndex, targetIndex);
    //         //     }
    //         //
    //         //     if (sourceIndex > targetIndex && dragCenterX < targetCenterX - 8) {
    //         //         visualModel.items.move(sourceIndex, targetIndex);
    //         //     }
    //         // }
    //         // onHeightChanged: {
    //         //     console.log("height: ", height);
    //         // }
    //         // onWidthChanged: {
    //         //     console.log("WIDTH ", width);
    //         // }
    //         //
    //         onEntered: function (drag) {
    //             if (!(drag.source instanceof QuickButton))
    //                 return;
    //
    //             const source = drag.source as QuickButton;
    //             if (source === button)
    //                 return;
    //
    //             visualModel.items.move(source.index, dropArea.index);
    //         }
    //
    //         property QuickButton button: choice.buttonDelegate.createObject(dropArea, {
    //             index: Qt.binding(() => dropArea.index),
    //             expanded: Qt.binding(() => dropArea.modelData.expanded),
    //             editMode: Qt.binding(() => menu.editMode),
    //             // selected: Qt.binding(() => group.lastPressedButton === dropArea.button),
    //             selected: Qt.binding(() => true),
    //             dragParent: Qt.binding(() => layout),
    //             containerHeight: Qt.binding(() => menu.pileHeight),
    //             maximumWidth: Qt.binding(() => menu.maxPileWidth),
    //             minimumWidth: Qt.binding(() => menu.minPileWidth)
    //         }) as QuickButton
    //     }
    // }
}
