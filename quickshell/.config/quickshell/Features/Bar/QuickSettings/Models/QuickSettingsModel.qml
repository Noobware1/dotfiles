pragma ComponentBehavior: Bound

import QtQuick
import qs.Core
import qs.Shared.Components
import qs.Features.Bar.QuickSettings

ViewModel {
    id: model

    property alias itemsModel: _itemsModel

    property bool editMode

    function toggleEditMode(): void {
        saveState();
        editMode = !editMode;
    }

    ListModel {
        id: _itemsModel
        property bool loaded: false

        function isButton(item: var) {
		return isSlider(item);
        }

function isSlider(item:var) {
return item && item.type && (
    item.type === QuickSettingItem.volume ||
    item.type === QuickSettingItem.brightness
) 
}
    }

    function saveState(): void {
        let list = [];
        for (var i = 0; i < _itemsModel.count; i++) {
            const item = _itemsModel.get(i);
            list.push({
                type: item.type,
                expanded: item.expanded,
                isChecked: item.isChecked
            });
        }

        Preferences.setObject("quick_settings_items", list);
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
        _itemsModel.setProperty(index, "isChecked", checked);
    }

    function __readItemsPrefs() {
        const prefs = Preferences.getObject("quick_settings_items", [
            {
                type: QuickSettingItem.wifi,
                expanded: true,
                isChecked: true
            },
            {
                type: QuickSettingItem.bluetooth,
                expanded: true,
                isChecked: false
            },
            {
                type: QuickSettingItem.doNotDisturb,
                expanded: false,
                isChecked: false
            },
            {
                type: QuickSettingItem.darkMode,
                expanded: false,
                isChecked: false
            },
            {
                type: QuickSettingItem.powerMode,
                expanded: true,
                isChecked: false
            },
            {
                type: QuickSettingItem.volume,
                expanded: true
            },
            {
                type: QuickSettingItem.brightness,
                expanded: true
            },
        ]);

        _itemsModel.clear();

        _itemsModel.append(prefs);

        _itemsModel.loaded = true;
    }

    Component.onCompleted: {
        __readItemsPrefs();
    }

    Component.onDestruction: {
        model.saveState();
    }
}
