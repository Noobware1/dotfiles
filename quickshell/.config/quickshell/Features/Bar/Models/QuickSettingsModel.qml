import QtQuick
import qs.Core
import qs.Features.Bar.Components

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
                toggled: item.toggled
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

    function setToggled(index: int, toggled: bool) {
        _itemsModel.setProperty(index, "toggled", toggled);
    }

    function __readItemsPrefs() {
        const prefs = Preferences.getObject("quick_items", [
            {
                type: QuickButton.Wifi,
                expanded: true,
                toggled: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                toggled: false
            },

            ///
            {
                type: QuickButton.Wifi,
                expanded: true,
                toggled: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Wifi,
                expanded: true,
                toggled: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Wifi,
                expanded: true,
                toggled: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Wifi,
                expanded: true,
                toggled: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true,
                toggled: false
            },
            {
                type: QuickButton.Dnd,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false,
                toggled: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true,
                toggled: false
            },
        ]);

        _itemsModel.clear();

        _itemsModel.append(prefs);

        _itemsModel.loaded();
    }

    Component.onCompleted: {
        __readItemsPrefs();
    }
}
