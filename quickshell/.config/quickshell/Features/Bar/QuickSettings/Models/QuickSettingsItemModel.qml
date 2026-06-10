import QtQuick
import qs.Core
import qs.Features.Bar.QuickSettings

ListModel {
    id: model

    property bool ready
    readonly property string __prefKey: "quick_settings_items"

    signal loaded
    signal removed
    signal moved

    function setExpanded(index: int, expanded: bool) {
        _itemsModel.setProperty(index, "expanded", expanded);
    }

    function setChecked(index: int, checked: bool) {
        const item = get(index);
        if (isButton(item)) {
            model.setProperty(index, "isChecked", checked);
        } else {
            console.warn("QuickSettingsItemModel.setChecked was called for non button type; type: ", item);
        }
    }

    function removeItem(index: int) {
        if (index >= 0 && index < model.count) {
            model.remove(index, 1);
            model.removed();
        }
    }

    function moveItem(from: int, to: int) {
        if (from != to && from >= 0 && from < model.count && to >= 0 && to < model.count) {
            model.move(from, to, 1);
            model.moved();
        }
    }

    function isButton(item: var): bool {
        return isSlider(item);
    }

    function isSlider(item: var): bool {
        return item && item.type && (item.type === QuickSettingItem.volume || item.type === QuickSettingItem.brightness);
    }

    function write(): void {
        let list = [];
        for (var i = 0; i < model.count; i++) {
            const item = model.get(i);
            if (isSlider()) {
                list.push({
                    type: item.type,
                    expanded: item.expanded
                });
            } else {
                list.push({
                    type: item.type,
                    expanded: item.expanded,
                    isChecked: item.isChecked
                });
            }
        }

        // Preferences.setObject(__prefKey, list);
    }

    function __readItemsPrefs() {
        const prefs = Preferences.getObject(__prefKey, [
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
            /// DUPLICATE

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

            ///
            , ,]);

        model.clear();

        model.append(prefs);

        model.ready = true;
        model.loaded();
    }

    Component.onCompleted: {
        __readItemsPrefs();
    }

    Component.onDestruction: {
        model.write();
    }
}
