pragma ComponentBehavior: Bound

import QtQuick.Layouts
import QtQuick
import QtQuick.Controls as C
import qs.Features.Bar.Components
import qs.Features.Bar.Models
import qs.Features.Bar.Components.QuickItems
import Material3

ColumnLayout {
    id: root
    spacing: 0
    required property real buttonHeight
    required property real buttonMaxWidth
    required property real buttonMinWidth
    required property real spaceBetween
    required property int maxColumns
    required property real contentPadding
    required property QuickSettingsModel model
    signal setChecked(int index, bool checked)

    C.SwipeView {
        id: view
        clip: true
        orientation: Qt.Horizontal
        property list<var> __data: []

        Layout.fillWidth: true

        currentIndex: 0
        implicitHeight: {
            let height;
            if (count <= 1) {
                height = contentHeight;
            } else {
                height = root.buttonHeight * root.maxColumns + (root.spaceBetween * 2);
            }
            return height + root.contentPadding * 2;
        }
        onWidthChanged: {
            view.populate();
        }

        function populate() {
            const model = root.model.itemsModel;

            let currentSpace = 0;
            let columnCount = 0;
            let page = 0;
            let lastIndex = -1;
            let data = [];

            for (var i = 0; i < model.count; i++) {
                const button = model.get(i);
                const buttonWidth = button.expanded ? root.buttonMaxWidth : root.buttonMinWidth + root.spaceBetween / 2;

                if (currentSpace + buttonWidth >= view.width) {
                    currentSpace = 0;
                    columnCount++;
                }

                currentSpace += buttonWidth;

                if (columnCount == root.maxColumns) {
                    columnCount = 0;
                    page++;
                }

                if (!data[page]) {
                    data[page] = [];
                }

                data[page].push(button);
            }

            view.__data.length = 0;
            view.__data = data;
        }

        Connections {
            target: root.model.itemsModel

            function onLoaded(): void {
                view.populate();
            }
        }

        Repeater {
            id: repeater
            model: view.__data
            Item {
                id: _layoutParent
                implicitHeight: _layout.implicitHeight
                width: root.width

                required property var modelData

                Flow {
                    id: _layout
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: root.contentPadding
                    ButtonGroup {
                        id: buttonGroup
                        layout: _layout
                        exclusive: false
                        animate: true
                        buttons: _layout.children.filter(e => e !== _repeater).sort((a, b) => a.index - b.index)
                    }
                    spacing: root.spaceBetween
                    width: parent.width - (root.contentPadding * 2)

                    Repeater {
                        id: _repeater
                        model: _layoutParent.modelData
                        delegate: Chooser {}
                        onItemAdded: function (_, button) {
                            button.toggled.connect(() => root.setChecked(button.index, button.checked));
                        }
                    }
                }
            }
        }
    }

    C.PageIndicator {
        Layout.alignment: Qt.AlignHCenter
        currentIndex: view.currentIndex
        count: view.count
        visible: count > 1
    }

    component Chooser: DelegateChooser {
        role: "type"

        choices: [
            DelegateChoice {
                roleValue: QuickButton.Wifi
                WifiButton {
                    containerHeight: root.buttonHeight
                    maximumWidth: root.buttonMaxWidth
                    minimumWidth: root.buttonMinWidth
                    menuHeight: root.buttonHeight * 6 + root.spacing * 5
                    model: root.model
                }
            },
            DelegateChoice {
                roleValue: QuickButton.Bluetooth
                BluetoothButton {
                    containerHeight: root.buttonHeight
                    maximumWidth: root.buttonMaxWidth
                    minimumWidth: root.buttonMinWidth
                }
            },
            DelegateChoice {
                roleValue: QuickButton.Dnd
                DoNotDisturbButton {
                    containerHeight: root.buttonHeight
                    maximumWidth: root.buttonMaxWidth
                    minimumWidth: root.buttonMinWidth
                }
            },
            DelegateChoice {
                roleValue: QuickButton.DarkMode
                DarkModeButton {
                    containerHeight: root.buttonHeight
                    maximumWidth: root.buttonMaxWidth
                    minimumWidth: root.buttonMinWidth
                }
            },
            DelegateChoice {
                roleValue: QuickButton.PowerMode
                PowerModeButton {
                    containerHeight: root.buttonHeight
                    maximumWidth: root.buttonMaxWidth
                    minimumWidth: root.buttonMinWidth
                }
            }
        ]
    }
}
