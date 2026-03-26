pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar.Models
import qs.Shared.Components
import qs.Features.Bar.Components.QuickItems

Rectangle {
    id: menu
    property real horizontalPadding: 8
    property real verticalPadding: 8
    color: MaterialTheme.colorScheme.surface
    implicitHeight: column.implicitHeight + (verticalPadding * 2)
    implicitWidth: column.implicitWidth + (horizontalPadding * 2)

    NumberAnimation {
        id: _animation
        target: menu
        running: true
        property: "y"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
        from: -menu.implicitHeight
        to: 0
        onFinished: {
            if (menu.__closing) {
                menu.__closing = false;
                menu.closed();
            }
        }
    }

    property bool __closing: false

    signal closed

    function close() {
        _animation.to = -menu.implicitHeight;
        _animation.from = 0;
        __closing = true;
        _animation.start();
        menu.model.saveState();
    }

    radius: 20

    property bool editMode: false

    onEditModeChanged: {
        group.lastPressedButton = null;
        if (!editMode) {
            menu.model.saveState();
        }
    }

    readonly property QuickSettingsModel model: QuickSettingsModel {}

    ButtonGroup {
        id: group
        layout: layout
        exclusive: false
        animate: !menu.editMode
        buttons: layout.children.filter(e => e !== repeater).sort((a, b) => a.index - b.index).map(e => e.button)
        property var lastPressedButton
        onClicked: function (button) {
            lastPressedButton = button;
        }
    }

    Timer {
        id: guard
        interval: 500
    }

    ColumnLayout {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 6
        Item {
            implicitHeight: menu.verticalPadding
        }
        Surface {
            id: header
            implicitHeight: 52
            Layout.fillWidth: true
            Layout.rightMargin: menu.horizontalPadding
            Layout.leftMargin: menu.horizontalPadding

            radius: 16
            elevation: 2
            color: MaterialTheme.colorScheme.surfaceContainer

            RowLayout {
                // anchors.verticalCenter: parent.verticalCenter
                anchors.fill: parent
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

        Rectangle {
            id: border
            Layout.topMargin: menu.editMode ? 10 : 0
            Layout.rightMargin: menu.horizontalPadding
            Layout.leftMargin: menu.horizontalPadding

            Layout.preferredHeight: layout.height + (menu.verticalPadding * 2)
            Layout.preferredWidth: layout.width + (menu.horizontalPadding * 2)

            radius: 24
            color: "transparent"

            border.width: menu.editMode ? 2 : -1
            border.color: MaterialTheme.colorScheme.primary

            Flow {
                id: layout
                anchors.centerIn: parent
                readonly property real maxPileWidth: 200
                readonly property real minPileWidth: (maxPileWidth / 2) - (layout.spacing / 2)
                readonly property real pileHeight: ButtonDefaults.mediumHeight
                readonly property real expandedHeight: (layout.pileHeight * 6) + (spacing * 5)

                height: menu.editMode ? expandedHeight : implicitHeight
                width: (layout.maxPileWidth * 2) + spacing + 5
                spacing: 6

                Repeater {
                    id: repeater
                    model: menu.model.itemsModel
                    DelegateChooser {
                        role: "type"
                        choices: [
                            ButtonDelegate {
                                roleValue: QuickButton.Wifi
                                WifiButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickButton.Bluetooth
                                BluetoothButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickButton.Dnd
                                DoNotDisturbButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickButton.DarkMode
                                DarkModeButton {}
                            },
                            ButtonDelegate {
                                roleValue: QuickButton.PowerMode
                                PowerModeButton {}
                            }
                        ]
                    }

                    onItemAdded: function (_idx, item) {
                        const button = item.button as QuickButton;
                        button.drag.connect(function (x, y) {
                            menu.onButtonDrag(button, x, y);
                        });
                        button.remove.connect(menu.model.removeItem);
                        button.expandedChanged.connect(() => menu.model.setExpanded(button.index, button.expanded));
                        button.toggled.connect(() => menu.model.setToggled(button.index, button.checked));
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
        }

        Slider {
            id: volumeSlider
            Layout.rightMargin: menu.horizontalPadding
            Layout.leftMargin: menu.horizontalPadding

            Layout.fillWidth: true
            trackHeight: SliderDefaults.mediumTrackHeight
            stopIndicatorItem: null
            icon.name: "volume_up"
        }

        Slider {
            id: brightnessSlider
            Layout.rightMargin: menu.horizontalPadding
            Layout.leftMargin: menu.horizontalPadding

            Layout.fillWidth: true
            trackHeight: SliderDefaults.mediumTrackHeight
            stopIndicatorItem: null
            icon.name: "brightness_7"
        }
    }

    component ButtonDelegate: DelegateChoice {
        id: choice
        default property Component buttonDelegate
        Rectangle {
            id: dropArea
            color: index == menu.__swapableIndex ? MaterialTheme.colorScheme.primary : "transparent"
            radius: height / 2

            required property int index
            required property bool expanded
            required property bool toggled

            height: button.height
            width: button.width

            property QuickButton button: choice.buttonDelegate.createObject(dropArea, {
                index: Qt.binding(() => dropArea.index),
                expanded: Qt.binding(() => dropArea.expanded),
                editMode: Qt.binding(() => menu.editMode),
                selected: Qt.binding(() => group.lastPressedButton === dropArea.button),
                dragParent: Qt.binding(() => menu),
                containerHeight: Qt.binding(() => layout.pileHeight),
                implicitHeight: Qt.binding(() => layout.pileHeight),
                maximumWidth: Qt.binding(() => layout.maxPileWidth),
                checked: Qt.binding(() => dropArea.toggled),
                minimumWidth: Qt.binding(() => layout.minPileWidth)
            }) as QuickButton
        }
    }

    property int __swapableIndex: -1

    function onButtonDrag(button, x, y) {
        if (guard.running)
            return;

        const pos = button.mapToItem(layout, x, y);

        const rowHeight = layout.pileHeight;
        const row = Math.floor(pos.y / rowHeight);

        const rowTop = row * rowHeight;
        const rowBottom = rowTop + rowHeight;

        const rowItems = [];

        var rowFound = false;

        for (let i = 0; i < repeater.count; i++) {
            const child = repeater.itemAt(i);

            if (!child || child.button === button)
                continue;

            if (child.y >= rowTop && child.y <= rowBottom) {
                rowFound = true;
                rowItems.push(child);
                continue;
            }

            if (rowFound) {
                break;
            }
        }

        if (rowItems.length === 0)
            return;

        const dragCenter = pos.x;

        let targetIndex = -1;

        const endSpace = layout.width - button.width + layout.spacing;
        for (let i = 0; i < rowItems.length; i++) {
            const current = rowItems[i];

            const itemLeft = current.x;
            const itemRight = current.x + current.width;

            let overlap = dragCenter > itemLeft && dragCenter < itemRight;

            if (!overlap) {
                if (i == rowItems.length - 1 && !button.expanded && dragCenter > itemRight && itemRight <= endSpace && rowItems.length >= 2 && (repeater.itemAt(current.index + 1)?.expanded ?? false)) {
                    targetIndex = current.index + 1;
                    break;
                }

                continue;
            }

            if (i == 0 && current.expanded && !button.expanded) {
                const prevItem = repeater.itemAt(current.index - 1);
                if (prevItem && prevItem.button != button) {
                    const prevItemRight = (prevItem.x + prevItem.width);
                    if (prevItemRight > (layout.width / 2) && prevItem <= endSpace) {
                        console.log(current.button);
                        break;
                    }
                    //empty space up top
                }
            }

            targetIndex = current.index;
            break;
        }

        if (targetIndex == -1) {
            return;
        }

        menu.model.moveItem(button.index, targetIndex);
        guard.start();
    }
}
