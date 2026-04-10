import QtQuick
import qs.Core
import qs.Features.Bar.Components
import qs.Services

QtObject {
    id: model

    property alias itemsModel: _itemsModel

    readonly property list<QtObject> __internals: [
        ListModel {
            id: _itemsModel
            signal loaded
        }
    ]

    function saveState(): void {
        let list = [];
        for (var i = 0; i < _itemsModel.count; i++) {
            const item = _itemsModel.get(i);
            list.push({
                type: item.type,
                expanded: item.expanded,
                checked: item.checked
            });
        }

        Preferences.setObject("quick_items", list);
    }

    function removeItem(index: int) {
        _itemsModel.remove(index, 1);
    }

    function moveItem(from: int, to: int) {
        _itemsModel.move(from, to, 1);
    }

    function setExpanded(index: int, expanded: bool) {
        _itemsModel.setProperty(index, "expanded", expanded);
    }

    function setToggled(index: int, checked: bool) {
        _itemsModel.setProperty(index, "checked", checked);
    }

    function __readItemsPrefs() {
        const prefs = Preferences.getObject("quick_items", [
            {
                type: QuickButton.Wifi,
                expanded: true,
                checked: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                checked: false
            },

            /////
            {
                type: QuickButton.Wifi,
                expanded: true,
                checked: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Wifi,
                expanded: true,
                checked: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Wifi,
                expanded: true,
                checked: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Wifi,
                expanded: true,
                checked: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Wifi,
                expanded: true,
                checked: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                checked: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                checked: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                checked: false
            },
        ]);

        _itemsModel.clear();

        _itemsModel.append(prefs);

        _itemsModel.loaded();
    }

    Component.onCompleted: {
        __readItemsPrefs();
    }

    readonly property real volume: AudioService.volume

    // property var __a: Timer {
    //     interval: 500
    //     running: true
    //     repeat: true
    //     onTriggered: {
    //         console.log(model.volume);
    //     }
    // }

    function setVolume(value: real) {
        AudioService.setVolume(value);
    }
}
