pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Material3

FloatingWindow {
    GridLayout {
        id: layout
        anchors.centerIn: parent
        columns: 4
        width: 180 * 2 + columnSpacing
        columnSpacing: 6
        rowSpacing: 6

        Tile1x1 {}
        Tile1x1 {}
        Tile2x2 {}
        Tile4x1 {}
    }

    component Tile1x1: Rectangle {
        color: "red"
        implicitHeight: 50
        implicitWidth: (180 / 2) - layout.columnSpacing
        Layout.columnSpan: 1
    }

    component Tile2x1: Rectangle {
        color: "red"
        implicitHeight: 50
        implicitWidth: 180
        Layout.columnSpan: 2
    }

    component Tile2x2: Rectangle {
        color: "red"
        implicitHeight: 100
        implicitWidth: 180
        Layout.columnSpan: 2
        Layout.rowSpan: 2
    }
    component Tile4x1: Rectangle {
        color: "red"
        implicitHeight: 50
        implicitWidth: (180 * 2) + layout.columnSpacing
        Layout.columnSpan: 4
    }
}
