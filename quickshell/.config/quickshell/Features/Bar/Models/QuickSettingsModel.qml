import QtQuick
import qs.Core
import qs.Features.Bar.Components

QtObject {
    id: model
    enum Button {
        Wifi,
        Bluetooth,
        Dnd,
        DarkMode,
        PowerMode
    }

    property alias quickItemsModel: itemsModel

    readonly property list<QtObject> __internals: [
        ListModel {
            id: itemsModel
            signal loaded
            signal removeItem(index: int)
            signal moveItem(from: int, to: int, count: int)
        }
    ]

    signal quickItemRemove(index: int)

    function saveState(): void {
        let list = [];
        for (var i = 0; i < itemsModel.count; i++) {
            const item = itemsModel.get(i);
            list.push({
                type: item.type,
                expanded: item.expanded
            });
        }

    // Preferences.setObject("quick_items", list);
    }

    function setExpanded(index: int, expanded: bool) {
        itemsModel.setProperty(index, "expanded", expanded);
    }

    function removeItem(index: int) {
        itemsModel.remove(index);
        itemsModel.removeItem(index);
    // __destroyIncubator(__incubators[index]);
    // __incubators.splice(index, 1);
    }

    function moveItem(from: int, to: int) {
        itemsModel.move(from, to, 1);
        itemsModel.moveItem(from, to, 1);

    // __incubators[from].object.index = to;
    // const [item] = __incubators.splice(from, 1);
    // __incubators.splice(to, 0, item);
    }

    // function dropItem(layout: Item, source: Item, x: real, y: real) {
    //     const pos = source.mapToItem(layout, x, y);
    //     const centerX = pos.x;
    //
    //     for (var i = 0; i < itemsModel.count; i++) {
    //         const item = layout.children[i];
    //         if (item === source) {
    //             continue;
    //         }
    //         const itemPos = item.mapToItem(layout, item.x, item.y);
    //         const itemCenterX = itemPos.x + (item.wtypeth / 2);
    //         if (centerX < itemCenterX) {
    //             itemsModel.move(source.index, i, 1);
    //             break;
    //         }
    //     }
    // }
    //

    function __readItemsPrefs() {
        const prefs = Preferences.getObject("quick_items", [
            {
                type: QuickSettingsModel.Wifi,
                expanded: true
            },
            {
                type: QuickSettingsModel.Bluetooth,
                expanded: true
            },
            {
                type: QuickSettingsModel.Dnd,
                expanded: false
            },
            {
                type: QuickSettingsModel.DarkMode,
                expanded: false
            },
            {
                type: QuickSettingsModel.PowerMode,
                expanded: true
            }
        ]);

        itemsModel.clear();

        for (var i = 0; i < prefs.length; i++) {
            itemsModel.append(prefs[i]);
        }

        itemsModel.loaded();
    }

    function quickItemSource(type: int): string {
        let path = "";
        switch (type) {
        case QuickSettingsModel.Button.Wifi:
            path = "WifiButton.qml";
            break;
        case QuickSettingsModel.Button.Bluetooth:
            path = "BluetoothButton.qml";
            break;
        case QuickSettingsModel.Button.Dnd:
            path = "DoNotDisturbButton.qml";
            break;
        case QuickSettingsModel.Button.DarkMode:
            path = "DarkModeButton.qml";
            break;
        case QuickSettingsModel.Button.PowerMode:
            path = "PowerModeButton.qml";
            break;
        default:
            path = "";
            break;
        }

        if (path.length > 0) {
            path = `${Paths.shellDir}/Features/Bar/Components/QuickItems/${path}`;
        }

        return path;
    }

    function createComponent(type: int): Component {
        return Qt.createComponent(quickItemSource(type));
    }

    Component.onCompleted: {
        __readItemsPrefs();
    }
}
