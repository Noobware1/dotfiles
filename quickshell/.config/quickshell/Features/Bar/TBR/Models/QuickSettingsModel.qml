pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as C
import qs.Core
import qs.Features.Bar.Components
import qs.Shared.Components
import qs.Features.Bar.Views
import qs.Services
import Material3

ViewModel {
    id: model

    property Item parent
    property alias itemsModel: _itemsModel
    property real menuHeight
    property real menuWidth
    property real menuRadius

    ListModel {
        id: _itemsModel
        signal loaded
    }

    readonly property alias navigationStack: __navigationStack
    property alias initialView: __navigationStack.initialItem

    StackView {
        id: __navigationStack
        clip: true
        implicitHeight: Math.min(currentItem.implicitHeight, model.menuHeight)
        implicitWidth: Math.max(currentItem.implicitWidth, model.menuWidth)
        // popExit: Transition {
        //     XAnimator {
        //         from: 0
        //         to: __navigationStack.currentItem.width - model.menuRadius
        //         duration: 300
        //         easing.type: Easing.BezierSpline
        //         easing.bezierCurve: [0.4, 0.0, 0.2, 1.0, 1.0, 1.0]
        //     }
        //     PropertyAnimation {
        //         property: "opacity"
        //         duration: 300
        //         easing.type: Easing.BezierSpline
        //         easing.bezierCurve: [0.4, 0.0, 0.2, 1.0, 1.0, 1.0]
        //         from: 1
        //         to: 0
        //     }
        // }
    }

    function goto(path: string): void {
        switch (path) {
        case "/networks":
            __navigationStack.push(networkListView);
            break;
        default:
            break;
        }
    }

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
        ]);

        _itemsModel.clear();

        _itemsModel.append(prefs);

        _itemsModel.loaded();
    }

    Component.onCompleted: {
        __readItemsPrefs();
    }

    Component {
        id: networkListView
        NetworkListView {
            onBackButtonPressed: {
                __navigationStack.pop();
            }
            qsettingsModel: model
        }
    }
}
