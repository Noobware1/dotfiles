pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Material3
import Quickshell.Hyprland

RowLayout {
    id: _layout
    required property font font
    spacing: 6

    ButtonGroup {
        id: group
        exclusive: true
        buttons: layout.children.filter(e => e !== repeater)
        layout: _layout
    }

    Repeater {
        id: repeater
        model: Hyprland.workspaces
        Button {
            font: _layout.font
            required property HyprlandWorkspace modelData
            checked: modelData?.active ?? group.checkedButton == this
            checkable: true
            text: modelData?.name ?? ""
            horizontalPadding: 8
            implicitWidth: implicitContentWidth + (horizontalPadding * 2)
            containerHeight: _layout.height
            implicitHeight: containerHeight
            verticalPadding: 0
            onPressed: Hyprland.dispatch(`workspace ${modelData.id}`)
        }
    }
}
