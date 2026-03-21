import QtQuick
import qs.Core
import qs.Features.Bar.Components

QtObject {
    id: model

    property alias itemsModel: _itemsModel

    readonly property list<QtObject> __internals: [
        ListModel {
            id: _itemsModel
        }
    ]

    function saveState(): void {
        let list = [];
        for (var i = 0; i < _itemsModel.count; i++) {
            const item = _itemsModel.get(i);
            list.push({
                type: item.type,
                expanded: item.expanded
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

    function __readItemsPrefs() {
        const prefs = Preferences.getObject("quick_items", [
            {
                type: QuickButton.Wifi,
                expanded: true
            },
            {
                type: QuickButton.Bluetooth,
                expanded: true
            },
            {
                type: QuickButton.Dnd,
                expanded: false
            },
            {
                type: QuickButton.DarkMode,
                expanded: false
            },
            {
                type: QuickButton.PowerMode,
                expanded: true
            }
        ]);

        _itemsModel.clear();

        for (var i = 0; i < prefs.length; i++) {
            _itemsModel.append(prefs[i]);
        }
    }

    Component.onCompleted: {
        __readItemsPrefs();
    }
}

// QtObject {
//     id: model
//     enum Button {
//         Wifi,
//         Bluetooth,
//         Dnd,
//         DarkMode,
//         PowerMode
//     }
//
//     property alias quickItemsModel: model
//
//     readonly property list<QtObject> __internals: [
//         ListModel {
//             id: model
//             signal loaded
//             signal removeItem(index: int)
//             signal moveItem(from: int, to: int, count: int)
//         }
//     ]
//
//     signal quickItemRemove(index: int)
//
//
//
//   //
//     function removeItem(index: int) {
//         model.remove(index);
//         model.removeItem(index);
//     // __destroyIncubator(__incubators[index]);
//     // __incubators.splice(index, 1);
//     }
//
//     function moveItem(from: int, to: int) {
//         model.move(from, to, 1);
//         model.moveItem(from, to, 1);
//
//     // __incubators[from].object.index = to;
//     // const [item] = __incubators.splice(from, 1);
//     // __incubators.splice(to, 0, item);
//     }
//

//
//     function quickItemSource(type: int): string {
//         let path = "";
//         switch (type) {
//         case QuickButton.Button.Wifi:
//             path = "WifiButton.qml";
//             break;
//         case QuickButton.Button.Bluetooth:
//             path = "BluetoothButton.qml";
//             break;
//         case QuickButton.Button.Dnd:
//             path = "DoNotDisturbButton.qml";
//             break;
//         case QuickButton.Button.DarkMode:
//             path = "DarkModeButton.qml";
//             break;
//         case QuickButton.Button.PowerMode:
//             path = "PowerModeButton.qml";
//             break;
//         default:
//             path = "";
//             break;
//         }
//
//         if (path.length > 0) {
//             path = `${Paths.shellDir}/Features/Bar/Components/QuickItems/${path}`;
//         }
//
//         return path;
//     }
//
//     function createComponent(type: int): Component {
//         return Qt.createComponent(quickItemSource(type));
//     }
/// }
