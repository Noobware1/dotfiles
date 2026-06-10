pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Material3
import qs.Shared.Components
import qs.Core

Button {
    id: settings

    variant: ButtonVariant.Text
    containerHeight: horizontal ? (parent.height - verticalMargin * 2) : (parent.width - verticalMargin * 2)

    height: horizontal ? buttonHeight : implicitHeight + topPadding + bottomPadding
    width: horizontal ? implicitWidth + leftPadding + rightPadding : buttonHeight

    colors.contentColor: MaterialTheme.colorScheme.onSurfaceVariant
    required property int barDirection
    required property int orientation
    required property real buttonHeight
    required property real verticalMargin
    required property real horizontalMargin
    readonly property bool horizontal: orientation == Qt.Horizontal

    spacing: IconButtonDefaults.narrowPaddingFor(containerHeight)
    verticalPadding: horizontal ? 0 : IconButtonDefaults.narrowPaddingFor(containerHeight)
    horizontalPadding: horizontal ? IconButtonDefaults.narrowPaddingFor(containerHeight) : 0

    contentItem: Loader {
        sourceComponent: settings.horizontal ? rowLayout : columnLayout
    }

    Component {
        id: columnLayout
        ColumnLayout {
            anchors.fill: parent
            spacing: settings.spacing
            VerticalSpacer {}
            MIcon {
                Layout.alignment: Qt.AlignHCenter
                name: "volume_up"
            }
            MIcon {
                Layout.alignment: Qt.AlignHCenter
                name: "signal_wifi_4_bar"
            }
            MIcon {
                Layout.alignment: Qt.AlignHCenter
                readonly property real percentage: UPower.displayDevice.percentage
                readonly property list<string> icons: ["battery_android_0", "battery_android_1", "battery_android_2", "battery_android_3", "battery_android_4", "battery_android_5", "battery_android_6", "battery_android_full"]
                name: icons[Math.round(Math.min(1, Math.max(0, percentage)) * 6)]
            }
            VerticalSpacer {}
        }
    }

    Component {
        id: rowLayout
        RowLayout {
            anchors.fill: parent
            spacing: settings.spacing
            Spacer {}
            MIcon {
                Layout.alignment: Qt.AlignVCenter
                name: "volume_up"
            }
            MIcon {
                Layout.alignment: Qt.AlignVCenter
                name: "signal_wifi_4_bar"
            }
            MIcon {

                Layout.alignment: Qt.AlignVCenter
                readonly property real percentage: UPower.displayDevice.percentage
                readonly property list<string> icons: ["battery_android_0", "battery_android_1", "battery_android_2", "battery_android_3", "battery_android_4", "battery_android_5", "battery_android_6", "battery_android_full"]
                name: icons[Math.round(Math.min(1, Math.max(0, percentage)) * 6)]
            }
            Spacer {}
        }
    }

    onPressed: {
        menu.toggle();
    }

    QuickSettingsMenu {
        id: menu
        barDirection: settings.barDirection
    }

    component MIcon: Icon {
        color: settings.colors.contentColor
        size: settings.iconSize
    }
}
