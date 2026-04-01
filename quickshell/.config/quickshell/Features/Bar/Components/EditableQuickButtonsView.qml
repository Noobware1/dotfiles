pragma ComponentBehavior: Bound

import QtQuick
import Qt.labs.qmlmodels
import QtQuick.Layouts
import QtQuick.Controls as C
import Material3
import qs.Features.Bar.Models
import qs.Shared.Components
import qs.Features.Bar.Components.QuickItems

Rectangle {
    id: root
    color: "transparent"
    border.width: 2
    border.color: MaterialTheme.colorScheme.primary
    radius: 16
    property real verticalPadding
    property real horizontalPadding
    required property var model
    required property real buttonHeight
    required property real buttonMaxWidth
    required property real buttonMinWidth
    required property real spaceBetween

    signal remove(index: int)
    signal setExpanded(index: int, expanded: bool)
    signal setToggled(index: int, toggled: bool)
    signal move(from: int, to: int)

    ButtonGroup {
        id: buttonGroup
        layout: _layout
        exclusive: false
        animate: false
        property QuickButton lastPressedButton
        buttons: _layout.children.filter(e => e != repeater).map(e => e.button)
        onClicked: function (button) {
            lastPressedButton = button;
        }
    }

    C.ScrollView {
        id: scrollView
        anchors.centerIn: parent
        height: root.height - root.verticalPadding
        width: contentWidth
        contentHeight: _layout.height
        contentWidth: _layout.width
        clip: true
        C.ScrollBar.vertical: C.ScrollBar {
            parent: scrollView.parent
            anchors.top: parent.top
            anchors.left: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: -root.horizontalPadding / 2
        }

        Flow {
            id: _layout
            width: root.width - root.horizontalPadding
            spacing: root.spaceBetween
            Repeater {
                id: repeater
                model: root.model
                onItemAdded: function (_idx, item) {
                    const button = item.button as QuickButton;
                    button.drag.connect(function (x, y) {
                        root.onButtonDrag(button, x, y);
                    });
                    button.remove.connect(function () {
                        root.remove(button.index);
                    });
                    button.expandedChanged.connect(function () {
                        root.setExpanded(button.index, button.expanded);
                    });
                    button.toggled.connect(function () {
                        root.setToggled(button.index, button.checked);
                    });
                }

                delegate: Chooser {}
            }

            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
                    easing.type: Easing.BezierSpline
                    duration: MotionSpecs.expressiveDefaultSpatialDuration
                }
            }
        }
    }

    component Chooser: DelegateChooser {
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

    component ButtonDelegate: DelegateChoice {
        id: choice
        default property Component buttonDelegate
        Item {
            id: dropArea

            required property int index
            required property bool expanded
            required property bool toggled

            height: button.height
            width: button.width

            property QuickButton button: choice.buttonDelegate.createObject(dropArea, {
                index: Qt.binding(() => dropArea.index),
                expanded: Qt.binding(() => dropArea.expanded),
                editMode: true,
                selected: Qt.binding(() => buttonGroup.lastPressedButton === dropArea.button),
                dragParent: Qt.binding(() => root),
                containerHeight: Qt.binding(() => root.buttonHeight),
                implicitHeight: Qt.binding(() => root.buttonHeight),
                maximumWidth: Qt.binding(() => root.buttonMaxWidth),
                checked: Qt.binding(() => dropArea.toggled),
                minimumWidth: Qt.binding(() => root.buttonMinWidth)
            }) as QuickButton
        }
    }

    Timer {
        id: guard
        interval: 500
    }

    function onButtonDrag(button, x, y) {
        if (guard.running)
            return;

        const pos = button.mapToItem(_layout, x, y);

        const rowHeight = root.buttonHeight;
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

        const endSpace = _layout.width - button.width + _layout.spacing;
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
                    if (prevItemRight > (_layout.width / 2) && prevItem <= endSpace) {
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

        root.move(button.index, targetIndex);
        guard.start();
    }
}
