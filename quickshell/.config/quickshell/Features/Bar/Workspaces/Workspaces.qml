pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import Material3
import qs.Shared.Components
import qs.Core
import Quickshell.Hyprland
import qs.Features.Bar

Loader {
    id: root
    required property font font
    required property real maximumLength
    required property int barSize
    required property real availableLength
    required property real iconSize
    required property int orientation
    readonly property bool horizontal: orientation == Qt.Horizontal
    height: implicitHeight
    width: implicitWidth

    readonly property ScriptModel visibleWorkspaces: ScriptModel {
        values: {
            let workspaces = [...Hyprland.workspaces.values];
            while (true) {
                const hasOverflow = root.maximumLength > 0 && ((workspaces.length + 1) * (root.buttonSize + root.spacing)) > root.maximumLength;
                if (hasOverflow) {
                    workspaces.pop();
                    continue;
                }
                break;
            }
            return workspaces;
        }
    }

    readonly property ScriptModel hiddenWorkspaces: ScriptModel {
        values: [...Hyprland.workspaces.values].slice(root.visibleWorkspaces.values.length).reverse()
    }

    readonly property real spacing: 6

    sourceComponent: horizontal ? rowLayout : columnLayout

    ButtonGroup {
        id: group
        exclusive: true
        buttons: (root.item as Item).children.filter(e => !(e instanceof Repeater))
        layoutParent: root.item as Item
    }

    property real buttonSize: {
        switch (root.barSize) {
        case BarSize.Large:
            return 32;
        case BarSize.Medium:
            return 24;
        case BarSize.Small:
        default:
            return 20;
        }
    }

    Component {
        id: rowLayout
        RowLayout {
            anchors.fill: parent
            spacing: root.spacing
            Repeater {
                id: repeater
                model: root.visibleWorkspaces
                delegate: MButton {
                    Layout.alignment: Qt.AlignVCenter

                    containerHeight: root.buttonSize
                    implicitWidth: root.buttonSize
                    implicitHeight: root.buttonSize
                }
            }
            OverflowIndicator {
                visible: root.hiddenWorkspaces.values.length > 0
            }
        }
    }

    Component {
        id: columnLayout
        ColumnLayout {
            anchors.fill: parent
            spacing: root.spacing

            Repeater {
                id: repeater
                model: root.visibleWorkspaces
                delegate: MButton {
                    Layout.alignment: Qt.AlignHCenter
                    containerHeight: root.buttonSize
                    implicitWidth: root.buttonSize
                    implicitHeight: root.buttonSize
                }
            }
            OverflowIndicator {
                visible: root.hiddenWorkspaces.values.length > 0
            }
        }
    }

    component OverflowIndicator: IconButton {
        horizontalPadding: 0
        verticalPadding: 0
        implicitHeight: root.buttonSize
        implicitWidth: root.buttonSize
        icon.name: root.horizontal ? "more_vert" : "more_horiz"
        iconSize: root.iconSize
        onClicked: {
            root.overflowIndicatorPressed(pressX, pressY);
        }
    }

    component MButton: Button {
        font: root.font
        required property HyprlandWorkspace modelData
        checked: modelData?.active ?? group.checkedButton == this
        checkable: true
        text: modelData?.name ?? ""
        horizontalPadding: 0
        verticalPadding: 0
        colors: {
            const cs = MaterialTheme.colorScheme;
            const colors = ButtonDefaults.filledButtonColors(cs, checked);
            colors.backgroundColor = checked ? cs.primary : cs.surfaceContainerHigh;
            return colors;
        }
        onPressed: root.switchWorkspace(modelData.id)
    }

    function switchWorkspace(id: int) {
        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${id} })`);
    }

    signal overflowIndicatorPressed(x: real, y: real)

    onOverflowIndicatorPressed: function (x, y) {
        popupLoader.pressX = x;
        popupLoader.pressY = y;
        popupLoader.toggle();
    }

    QsPopupLoader {
        id: popupLoader
        property real pressX
        property real pressY
        QsMenuPopup {
            anchor.window: WindowManager.barWindow
            readonly property point offset: root.parent.mapFromItem(root, popupLoader.pressX, popupLoader.pressY)
            x: root.horizontal ? offset.x : WindowManager.barWindow.width + 14
            y: root.horizontal ? WindowManager.barWindow.height + 14 : offset.y + (root.height - menuHeight)
            focus: true
            Repeater {
                model: root.hiddenWorkspaces
                MenuItem {
                    required property int index
                    required property HyprlandWorkspace modelData
                    checked: modelData?.active ?? group.checkedButton == this
                    checkable: true

                    colors: MenuDefaults.colors(MaterialTheme.colorScheme)
                    text: `Workspace ${modelData?.name ?? "undefined"}`
                    onTriggered: {
                        root.switchWorkspace(modelData.id);
                        menu.close();
                    }
                }
            }
        }
    }
}
