pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar.Models

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
            model.saveState();
        }
    }

    Component.onDestruction: {
        model.saveState();
    }

    readonly property QuickSettingsModel model: QuickSettingsModel {}

    ButtonGroup {
        id: group
        exclusive: false
        animate: !menu.editMode
        buttons: layout.children.filter(e => e !== repeater).map(e => e.item)

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
                    // delegate: QuickItemLoader {
                    //     id: loader
                    //     required property var modelData
                    //     editMode: menu.editMode
                    //     selected: group.lastPressedButton == this.item
                    //     source: menu.model.quickItemSource(modelData.id)
                    //     expanded: modelData.expanded
                    //     containerHeight: menu.pileHeight
                    //     maximumWidth: menu.maxPileWidth
                    //     minimumWidth: menu.minPileWidth
                    //     dragParent: layout
                    //
                    //     property bool swapped: false
                    //
                    //     onDrag: function (x, y) {
                    //         const button = loader.item as QuickButton;
                    //
                    //         const pos = button.mapToItem(layout, x, y);
                    //         const spacing = layout.spacing;
                    //         const centerX = pos.x - (button.width / 2);
                    //         const layoutHeight = layout.height;
                    //         const layoutWidth = layout.width;
                    //         const row = Math.min(Math.max(0, Math.floor(pos.y / button.height)), Math.floor(layoutHeight / button.height) - 1);
                    //
                    //         const rowTop = row * (button.height + spacing);
                    //         const rowBottom = rowTop + button.height;
                    //         let closestIndex = 0;
                    //         for (var i = 0; i < repeater.count; i++) {
                    //             let child = repeater.itemAt(i) as QuickItemLoader;
                    //             if (child.item === button) {
                    //                 continue;
                    //             }
                    //             if (child.y >= rowTop && child.y < rowBottom) {
                    //                 const itemCenterX = child.x + (child.width / 2);
                    //                 if (centerX < itemCenterX) {
                    //                     // console.log(centerX, child.x);
                    //                     menu.model.moveItem(loader.index, child.index);
                    //                 }
                    //             }
                    //         }
                    //     }
                    // }
                }

                // children: menu.model.quickItems
                // Connections {
                //     target: menu.model
                //
                //     function onQuickItemsLoaded(): void {
                //         menu.model.createQuickItems(layout, function (index, modelData) {
                //             return {
                //                 index: index,
                //                 editMode: Qt.binding(() => menu.editMode),
                //                 containerHeight: Qt.binding(() => menu.pileHeight),
                //                 implicitHeight: Qt.binding(() => menu.pileHeight),
                //                 maximumWidth: Qt.binding(() => menu.maxPileWidth),
                //                 minimumWidth: Qt.binding(() => menu.minPileWidth),
                //                 expanded: Qt.binding(() => modelData.expanded),
                //                 dragParent: layout
                //             };
                //         }, function (item) {
                //             item.remove.connect(() => menu.model.removeItem(item.index));
                //             item.expandedChanged.connect(() => menu.model.setExpanded(item.index, item.expanded));
                //             item.selected = Qt.binding(() => group.lastPressedButton == item);
                //             item.move.connect(function (from, to) {
                //                 console.log(from, to);
                //                 if (to == item.index) {
                //                     return;
                //                 }
                //
                //                 menu.model.moveItem(from, to);
                //             });
                //         });
                //     }
                // }

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
}
