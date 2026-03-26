import Quickshell
import Quickshell.Wayland
import QtQuick
import Material3
import qs.Features.Bar.Components
import qs.Shared.Components
import qs.Features.Bar

PanelWindow {
    id: bar
    anchors.top: true
    anchors.right: true
    anchors.left: true

    // implicitHeight: BarConfig.height
    readonly property real roundedCornerSize: 0
    WlrLayershell.namespace: "quickshell:bar"
    implicitHeight: BarConfig.height + roundedCornerSize
    color: "transparent"

    readonly property real horizontalMargin: 10
    readonly property real verticalMargin: 5
    readonly property real heightWithMargin: (bar.implicitHeight - roundedCornerSize) - (bar.verticalMargin * 2)

    Rectangle {
        height: bar.implicitHeight

        anchors {
            left: parent.left
            right: parent.right
        }
        color: MaterialTheme.colorScheme.surface

        Workspaces {
            height: bar.heightWithMargin
            anchors.left: parent.left
            anchors.leftMargin: bar.horizontalMargin
            anchors.verticalCenter: parent.verticalCenter
            font: BarConfig.font
        }

        Clock {
            anchors.centerIn: parent
            height: bar.heightWithMargin
        }

        // Marquee {
        //     anchors.centerIn: parent
        //     textString: "hello world"
        //     font.pixelSize: 14
        //     verticalAlignment: Text.AlignVCenter
        //     horizontalAlignment: Text.AlignHCenter
        //     color: MaterialTheme.colorScheme.onSurface
        // }

        QuickSettings {
            anchors.right: parent.right
            anchors.rightMargin: bar.horizontalMargin * 2
            height: bar.heightWithMargin
            anchors.verticalCenter: parent.verticalCenter
            iconSize: BarConfig.iconSize
            window: bar
        }
    }
}
