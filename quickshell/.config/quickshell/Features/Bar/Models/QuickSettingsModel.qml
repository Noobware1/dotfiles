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
        }
    ]

    signal quickItemsLoaded
    signal quickItemRemove(index: int)

    function saveState(): void {
        let list = [];
        for (var i = 0; i < itemsModel.count; i++) {
            const item = itemsModel.get(i);
            list.push({
                id: item.id,
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
    // __destroyIncubator(__incubators[index]);
    // __incubators.splice(index, 1);
    }

    function moveItem(from: int, to: int) {
        itemsModel.move(from, to, 1);
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
    //         const itemCenterX = itemPos.x + (item.width / 2);
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
                id: QuickSettingsModel.Wifi,
                expanded: true
            },
            {
                id: QuickSettingsModel.Bluetooth,
                expanded: true
            },
            {
                id: QuickSettingsModel.Dnd,
                expanded: false
            },
            {
                id: QuickSettingsModel.DarkMode,
                expanded: false
            },
            {
                id: QuickSettingsModel.PowerMode,
                expanded: true
            }
        ]);

        itemsModel.clear();

        for (var i = 0; i < prefs.length; i++) {
            itemsModel.append(prefs[i]);
        }

        quickItemsLoaded();
    }

    function quickItemSource(id: int): string {
        let path = "";
        switch (id) {
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

    function createComponent(id: int): Component {
        let path = "";
        switch (id) {
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
        return Qt.createComponent(path);
    }

    // property list<var> __incubators: []
    // readonly property list<Item> quickItems: {
    //     if (__loadingCount == 0) {
    //         return __incubators.slice().map(e => e.object).sort((a, b) => a.index - b.index);
    //     }
    //     return [];
    // }
    // property Item __quickItemsParent
    // property int __loadingCount: 0
    // property bool __dirty: false

    // on__LoadingCountChanged: {
    //     if (__loadingCount == 0) {
    //         for (var i = 0; i < __incubators.length; i++) {
    //             const incubator = __incubators[i];
    //             incubator.object.parent = __quickItemsParent;
    //         }
    //     }
    // }

    // function __incubatorsClear(): void {
    //     for (var i = 0; i < __incubators.length; i++) {
    //         __destroyIncubator(__incubators[i]);
    //     }
    //
    //     __incubators.length = 0;
    // }

    // function createQuickItems(parent: Item, properties: var, init: var): void {
    //     if (__dirty) {
    //         while (__dirty) {
    //             // wait for prev function call to finish
    //         }
    //     }
    //
    //     __dirty = true;
    //     __incubatorsClear();
    //
    //     __loadingCount = itemsModel.count;
    //     __quickItemsParent = parent;
    //
    //     for (let i = 0; i < itemsModel.count; i++) {
    //         const data = itemsModel.get(i);
    //         if (!data) {
    //             continue;
    //         }
    //         const component = createComponent(data.id);
    //
    //         const incubator = component.incubateObject(null, properties(i, data));
    //
    //         __incubators.push(incubator);
    //         const index = i;
    //
    //         incubator.onStatusChanged = function (status) {
    //             if (status == Component.Error) {
    //                 console.error(incubator.errorString());
    //             } else if (status == Component.Ready) {
    //                 __loadingCount--;
    //                 init(incubator.object);
    //             }
    //         };
    //     }
    //     __dirty = false;
    // }
    //
    // function __destroyIncubator(incubator: var): void {
    //     if (incubator.status !== Component.Ready) {
    //         incubator.forceCompletion();
    //     }
    //     if (incubator.status == Component.Ready) {
    //         incubator.object.destroy();
    //     }
    // }

    Component.onCompleted: {
        __readItemsPrefs();
    }

    // Component.onDestruction: {
    //     __loadingCount = 0;
    //     __incubatorsClear();
    // }
}
