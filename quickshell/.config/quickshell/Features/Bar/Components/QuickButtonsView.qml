pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as C
import qs.Features.Bar.Components
import qs.Features.Bar.Components.QuickItems

C.SwipeView {
    id: view
    clip: true

    required property var model
    required property real buttonHeight
    required property real buttonMaxWidth
    required property real buttonMinWidth
    required property real spaceBetween
    required property int maxColumns
    orientation: Qt.Horizontal
    property list<var> __data: []

    currentIndex: 0

    function populate() {
        const model = view.model.itemsModel;

        let currentSpace = 0;
        let columnCount = 0;
        let page = 0;
        let lastIndex = -1;
        let data = [];

        for (var i = 0; i < view.model.count; i++) {
            const button = view.model.get(i);
            const buttonWidth = button.expanded ? view.buttonMaxWidth : view.buttonMinWidth + view.spaceBetween / 2;

            if (currentSpace + buttonWidth >= view.implicitWidth) {
                currentSpace = 0;
                columnCount++;
            }

            currentSpace += buttonWidth;

            if (columnCount == view.maxColumns) {
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
        target: view.model

        function onLoaded(): void {
            view.populate();
        }
    }

    Repeater {
        id: repeater
        model: view.__data
        Flow {
            id: layout
            required property var modelData
            width: view.implicitWidth
            spacing: view.spaceBetween

            Repeater {
                model: layout.modelData
                delegate: Chooser {}
            }
        }
    }

    component Chooser: DelegateChooser {
        role: "type"

        choices: [
            DelegateChoice {
                roleValue: QuickButton.Wifi
                WifiButton {
                    required property bool toggled
                    containerHeight: view.buttonHeight
                    maximumWidth: view.buttonMaxWidth
                    minimumWidth: view.buttonMinWidth
                    checked: toggled
                }
            },
            DelegateChoice {
                roleValue: QuickButton.Bluetooth
                BluetoothButton {
                    required property bool toggled
                    containerHeight: view.buttonHeight
                    maximumWidth: view.buttonMaxWidth
                    minimumWidth: view.buttonMinWidth
                    checked: toggled
                }
            },
            DelegateChoice {
                roleValue: QuickButton.Dnd
                DoNotDisturbButton {
                    required property bool toggled
                    containerHeight: view.buttonHeight
                    maximumWidth: view.buttonMaxWidth
                    minimumWidth: view.buttonMinWidth
                    checked: toggled
                }
            },
            DelegateChoice {
                roleValue: QuickButton.DarkMode
                DarkModeButton {
                    required property bool toggled
                    containerHeight: view.buttonHeight
                    maximumWidth: view.buttonMaxWidth
                    minimumWidth: view.buttonMinWidth
                    checked: toggled
                }
            },
            DelegateChoice {
                roleValue: QuickButton.PowerMode
                PowerModeButton {
                    required property bool toggled
                    containerHeight: view.buttonHeight
                    maximumWidth: view.buttonMaxWidth
                    minimumWidth: view.buttonMinWidth
                    checked: toggled
                }
            }
        ]
    }

    Component.onCompleted: {
        view.populate();
    }
}
