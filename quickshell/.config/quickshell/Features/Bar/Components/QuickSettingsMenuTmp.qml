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
    // implicitHeight: column.implicitHeight + (verticalPadding * 2)
    // implicitWidth: column.implicitWidth + (horizontalPadding * 2)
    implicitHeight: 700
    implicitWidth: 600

    radius: 20

    property bool editMode: false
    onEditModeChanged: {
        group.lastPressedButton = null;
        if (!editMode) {
            menu.model.saveState();
        }
    }

    Component.onDestruction: {
        menu.model.saveState();
    }

    readonly property QuickSettingsModel model: QuickSettingsModel {}

    ButtonGroup {
        id: group
        exclusive: false
        animate: !menu.editMode
        buttons: layout.children.filter(e => e !== repeater).map(function (e) {
            if (e instanceof QuickButton) {
                return e;
            } else {
                return e.button;
            }
        })

        property var lastPressedButton
        onClicked: function (button) {
            lastPressedButton = button;
        }
    }

    ColumnLayout {
        id: column
        anchors.centerIn: parent
        spacing: 6

        Rectangle {
            id: border
            Layout.preferredHeight: layout.height + 24
            // idk why it is like this
            Layout.preferredWidth: layout.width + 24
            radius: 24
            color: "transparent"

            border.width: menu.editMode ? 2 : -1
            border.color: MaterialTheme.colorScheme.primary

            Flow {
                id: layout
                anchors.centerIn: parent
                height: (menu.pileHeight * 3) + (spacing * 2)
                // idk why it is like this
                width: (menu.maxPileWidth * 2) + spacing + 1
                spacing: 6

                Repeater {
                    id: repeater
                    model: menu.model.quickItemsModel
                    delegate: DelegateChooser {
                        role: "type"
                        // choices: menu.choices
                        choices: [
                            ButtonDelegate {
                                roleValue: QuickSettingsModel.Wifi
                                WifiButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickSettingsModel.Bluetooth
                                BluetoothButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickSettingsModel.Dnd
                                DoNotDisturbButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickSettingsModel.DarkMode
                                DarkModeButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickSettingsModel.PowerMode
                                PowerModeButton {}
                            }
                        ]
                    }

                    property bool entered: false

                    onItemAdded: function (_, item) {
                    // const button = item as QuickButton;
                    // button.editMode = Qt.binding(() => menu.editMode);
                    // button.selected = Qt.binding(() => group.lastPressedButton === button);
                    // button.dragParent = Qt.binding(() => layout);
                    // button.drag.connect(function (x, y) {
                    //     const item = repeater.itemAt(0);
                    //     const centerX = item.x + item.width / 2;
                    //     const centerY = item.y + item.height / 2;
                    //
                    //     const pos = button.mapToItem(layout, x, y);
                    //     if (pos.x < centerX && pos.y <= centerY) {
                    //         if (repeater.entered) {
                    //             return;
                    //         }
                    //         menu.model.moveItem(button.index, item.index);
                    //         repeater.entered = true;
                    //     }

                    // const pos = button.mapToItem(layout, x, y);
                    //
                    // const spacing = layout.spacing;
                    // const rowHeight = button.height;
                    //
                    // const centerX = pos.x;
                    // const row = Math.floor(pos.y / rowHeight);
                    //
                    // const rowTop = row * rowHeight;
                    // const rowBottom = rowTop + button.height;
                    //
                    // const rowItems = [];
                    //
                    // for (let i = 0; i < repeater.count; i++) {
                    //     const child = repeater.itemAt(i);
                    //
                    //     if (!child || child === button)
                    //         continue;
                    //     if (child.y >= rowTop && child.y < rowBottom)
                    //         rowItems.push(child);
                    // }
                    //
                    // if (rowItems.length === 0)
                    //     return;
                    //
                    // rowItems.sort((a, b) => a.x - b.x);
                    //
                    // let targetIndex = -1;
                    //
                    // // normal insertion check
                    // for (let i = 0; i < rowItems.length; i++) {
                    //     const current = rowItems[i];
                    //     const center = current.x + current.width / 2;
                    //
                    //     if (current.index > button.index) {
                    //         if (centerX >= center) {
                    //             targetIndex = current.index;
                    //             break;
                    //         }
                    //     } else {
                    //         if (centerX <= center) {
                    //             targetIndex = current.index;
                    //             break;
                    //         }
                    //     }
                    // }
                    // if (targetIndex > -1) {
                    //     menu.model.moveItem(button.index, targetIndex);
                    // }
                    // });
                    }
                }

                move: Transition {
                    id: moveTrans
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

    component ButtonDelegate: DelegateChoice {
        id: choice
        default property Component buttonDelegate
        DropArea {
            id: dropArea
            required property int index
            required property var modelData

            height: button.height
            width: button.width
            property bool __entered
            onExited: {
                __entered = false;
            }
            property bool __switched: false
            onPositionChanged: function (drag) {
                if (index != 0) {
                    return;
                }
                // const item = repeater.itemAt(0);
                const centerX = dropArea.x + dropArea.width / 2;
                const centerY = dropArea.y + dropArea.height / 2;
                const source = (drag.source as QuickButton);
                const pos = source.mapToItem(layout, source.width / 2, source.height / 2);
                if (pos.x < centerX && pos.y <= centerY) {
                    if (dropArea.__switched) {
                        return;
                    }
                    menu.model.moveItem(source.index, dropArea.index);
                    dropArea.__switched = true;
                }
            }
            onEntered: function (drag) {
                // __entered = drag.source instanceof QuickButton && drag.source !== button;
                if (!(drag.source instanceof QuickButton))
                    return;

                const source = drag.source as QuickButton;
                if (source === button)
                    return;

                __entered = true;

            // model.items.move((drag.source as QuickButton).index, button.index);

            // model          model.move (source.index, index);
            // menu.model.moveItem(source.index, index);
            }

            property QuickButton button: choice.buttonDelegate.createObject(dropArea, {
                index: Qt.binding(() => dropArea.index),
                expanded: Qt.binding(() => dropArea.modelData.expanded),
                editMode: Qt.binding(() => menu.editMode),
                selected: Qt.binding(() => group.lastPressedButton === dropArea.button),
                dragParent: Qt.binding(() => layout),
                containerHeight: Qt.binding(() => menu.pileHeight),
                maximumWidth: Qt.binding(() => menu.maxPileWidth),
                minimumWidth: Qt.binding(() => menu.minPileWidth)
            }) as QuickButton
        }
    }

    property int lastSwapIndex: -1

    readonly property list<DelegateChoice> choices: [
        DelegateChoice {
            roleValue: QuickSettingsModel.Wifi
            WifiButton {
                minimumWidth: menu.minPileWidth
                maximumWidth: menu.maxPileWidth
                containerHeight: menu.pileHeight
                implicitHeight: menu.pileHeight
            }
        },
        DelegateChoice {
            roleValue: QuickSettingsModel.Bluetooth
            BluetoothButton {
                minimumWidth: menu.minPileWidth
                maximumWidth: menu.maxPileWidth
                containerHeight: menu.pileHeight
                implicitHeight: menu.pileHeight
            }
        },
        DelegateChoice {
            roleValue: QuickSettingsModel.Dnd
            DoNotDisturbButton {
                minimumWidth: menu.minPileWidth
                maximumWidth: menu.maxPileWidth
                containerHeight: menu.pileHeight
                implicitHeight: menu.pileHeight
            }
        },
        DelegateChoice {
            roleValue: QuickSettingsModel.DarkMode
            DarkModeButton {
                minimumWidth: menu.minPileWidth
                maximumWidth: menu.maxPileWidth
                containerHeight: menu.pileHeight
                implicitHeight: menu.pileHeight
            }
        },
        DelegateChoice {
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

// onPositionChanged: function (drag: DragEvent) {
//     if (__entered) {
//         const source = drag.source as QuickButton;
//
//         const sourceIndex = source.index;
//         const targetIndex = index;
//
//         // center of dragged item in Flow coordinates
//         const sourcePos = source.mapToItem(layout, source.width / 2, source.height / 2);
//         const dragCenterX = sourcePos.x;
//         const dragCenterY = sourcePos.y;
//
//         // center of target item
//         const targetCenterX = dropArea.x + dropArea.width / 2;
//         const targetCenterY = dropArea.y + dropArea.height / 2;
//
//         // ensure both items are on the same row
//         const sameRow = Math.abs(dragCenterY - targetCenterY) < dropArea.height / 2;
//
//         if (!sameRow)
//             return;
//
//         if (sourceIndex < targetIndex && dragCenterX > targetCenterX + 8) {
//             menu.model.moveItem(sourceIndex, targetIndex);
//         }
//
//         if (sourceIndex > targetIndex && dragCenterX < targetCenterX - 8) {
//             menu.model.moveItem(sourceIndex, targetIndex);
//         }
//     }
// }
