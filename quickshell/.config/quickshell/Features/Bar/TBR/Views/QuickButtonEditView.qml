pragma ComponentBehavior: Bound

import QtQuick
import Qt.labs.qmlmodels
import QtQuick.Layouts
import QtQuick.Controls as C
import Material3
import qs.Features.Bar.Models
import qs.Shared.Components
import qs.Features.Bar.Components.QuickItems
import qs.Features.Bar.Components

ColumnLayout {
    id: root
    spacing: 0
    width: parent.width

    property real contentPadding
    property real contentHeight

    required property var model
    required property real buttonHeight
    required property real buttonMaxWidth
    required property real buttonMinWidth
    required property real spaceBetween
    required property Item dragParent

    signal remove(index: int)
    signal setExpanded(index: int, expanded: bool)
    signal move(index: int, target: int)

    Rectangle {
        id: border
        color: "transparent"
        border.width: 2
        border.color: MaterialTheme.colorScheme.primary
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredHeight: root.contentHeight
        Layout.fillWidth: true
        radius: 16

        C.ScrollView {
            id: scrollView
            height: parent.height - root.contentPadding
            anchors.centerIn: parent
            width: parent.width
            clip: true

            C.ScrollBar.vertical: C.ScrollBar {
                parent: scrollView.parent
                anchors.top: parent.top
                anchors.left: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: -root.contentPadding / 2
            }

            Item {
                width: parent.width
                implicitHeight: _layout.implicitHeight + root.contentPadding * 2

                Flow {
                    id: _layout
                    width: root.width - root.contentPadding * 2
                    spacing: root.spaceBetween
                    anchors {
                        top: parent.top
                        topMargin: 5 // button focus border
                        horizontalCenter: parent.horizontalCenter
                    }

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

                    Repeater {
                        id: repeater
                        model: root.model
                        onItemAdded: function (_idx, item) {
                            const button = (item as ButtonDropArea).button as QuickButton;
                            button.drag.connect(function (x, y) {
                                root.onButtonDrag(button, x, y);
                            });
                            button.remove.connect(function () {
                                root.remove(button.index);
                            });
                            button.expandedChanged.connect(function () {
                                root.setExpanded(button.index, button.expanded);
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
            const child = repeater.itemAt(i) as ButtonDropArea;

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
                const prevItem = repeater.itemAt(current.index - 1) as ButtonDropArea;
                if (prevItem && prevItem.button != button) {
                    const prevItemRight = (prevItem.x + prevItem.width);
                    if (prevItemRight > (_layout.width / 2) && prevItem <= endSpace) {
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

    component Chooser: DelegateChooser {
        role: "type"

        choices: [
            DelegateChoice {
                roleValue: QuickButton.Wifi
                ButtonDropArea {
                    id: __wifi
                    WifiButton {
                        index: __wifi.index
                        modelData: __wifi.modelData
                    }
                }
            },
            DelegateChoice {
                roleValue: QuickButton.Bluetooth
                ButtonDropArea {
                    id: __bluetooth
                    BluetoothButton {
                        index: __bluetooth.index
                        modelData: __bluetooth.modelData
                    }
                }
            },
            DelegateChoice {
                roleValue: QuickButton.Dnd
                ButtonDropArea {
                    id: __dnd
                    DoNotDisturbButton {
                        index: __dnd.index
                        modelData: __dnd.modelData
                    }
                }
            },
            DelegateChoice {
                roleValue: QuickButton.DarkMode
                ButtonDropArea {
                    id: __darkMode
                    DarkModeButton {
                        index: __darkMode.index
                        modelData: __darkMode.modelData
                    }
                }
            },
            DelegateChoice {
                roleValue: QuickButton.PowerMode
                ButtonDropArea {
                    id: __powerMode
                    PowerModeButton {
                        index: __powerMode.index
                        modelData: __powerMode.modelData
                    }
                }
            }
        ]
    }

    component ButtonDropArea: Item {
        id: __dropArea
        required property int index
        required property var modelData

        // qmllint disable Quick.layout-positioning
        height: button.height
        width: button.width

        default required property QuickButton button

        Binding {
            target: __dropArea.button
            property: "editMode"
            value: true
        }
        Binding {
            target: __dropArea.button
            property: "selected"
            value: buttonGroup.lastPressedButton === this
        }
        Binding {
            target: __dropArea.button
            property: "dragParent"
            value: root.dragParent
        }

        Binding {
            target: __dropArea.button
            property: "containerHeight"
            value: root.buttonHeight
        }
        Binding {
            target: __dropArea.button
            property: "minimumWidth"
            value: root.buttonMinWidth
        }
        Binding {
            target: __dropArea.button
            property: "maximumWidth"
            value: root.buttonMaxWidth
        }

        children: [button]
    }
}
