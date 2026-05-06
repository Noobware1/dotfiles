pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls as C
import QtQuick.Layouts
import Material3
import qs.Features.Bar.QuickSettings
import qs.Shared.Components
import qs.Core

Page {
    id: view
    property QuickSettingsMenu menu: StackView.view as QuickSettingsMenu
    implicitHeight: menu?.implicitHeight ?? 0
    implicitWidth: menu?.implicitWidth ?? 0
    radius: menu?.radius ?? 0
    backgroundColor: menu?.backgroundColor ?? "transparent"
    // property alias QuickSettingsModel qsModel

    header: TopAppBar {
        focusPolicy: Qt.TabFocus
        topLeftRadius: view.radius
        topRightRadius: view.radius
        headlineText: "Internet"
        leadingItem: BackButton {
            onClicked: {
                view.StackView.view.pop();
            }
        }
    }
    focusPolicy: Qt.TabFocus
    contentItem: C.ScrollView {
        clip: true

        verticalPadding: LayoutSemenatics.pageVerticalPadding
        horizontalPadding: LayoutSemenatics.pageHorizontalPadding

        ColumnLayout {
            width: view.availableWidth - LayoutSemenatics.pageHorizontalPadding * 2
            spacing: 18

            LabelAndItem {
                label: "Saved Networks"
                model: 4
            }
            LabelAndItem {
                label: "Networks"
                model: 20
            }
        }
    }

    component LabelAndItem: ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        property alias label: _label.text
        property alias model: repeater.model
        Label {
            id: _label
            text: "Saved Networks"
            font: MaterialTheme.typography.titleMedium
            color: MaterialTheme.colorScheme.onSurface
        }
        VerticalSpacer {
            value: 16
        }
        Repeater {
            id: repeater
            model: 4
            delegate: MListItem {
                Layout.fillWidth: true
                lastIndex: repeater.count - 1
            }
        }
    }

    component MListItem: ListItem {
        id: item
        required property int index
        required property int lastIndex
        property var modelData: {
            return {
                name: "SITI FIBER 5G",
                connected: false
            };
        }
        subtitleText: (modelData?.connected ?? false) ? "connected" : ""
        elevation: 0
        colors: {
            const cs = MaterialTheme.colorScheme;
            const colors = ListDefaults.colors(cs);
            colors.backgroundColor = cs.surfaceContainerHigh;
            return colors;
        }
        topLeftRadius: index == 0 ? height / 2 : radius
        topRightRadius: index == 0 ? height / 2 : radius
        bottomLeftRadius: index == lastIndex ? height / 2 : radius
        bottomRightRadius: index == lastIndex ? height / 2 : radius
        leading: Icon {
            anchors.centerIn: parent
            name: "wifi"
            size: ListDefaults.iconSize
            color: item.colors.secondaryContentColor
        }
        text: modelData?.name ?? "[No Name]"
        trailing: IconButton {
            id: button
            anchors.centerIn: parent
            icon.name: "more_vert"
        }
    }
    // contentItem: PaddedListView {
    //     model: 30
    //     horizontalPadding: LayoutSemenatics.pageHorizontalPadding
    //     verticalPadding: LayoutSemenatics.pageVerticalPadding
    //
    //     delegate: PaddedListItem {
    //         id: item
    //         property var modelData: {
    //             return {
    //                 name: "SITI FIBER 5G",
    //                 connected: false
    //             };
    //         }
    //         // required property WifiNetwork modelData
    //         // anchors.horizontalCenter: parent?.horizontalCenter
    //         elevation: 4
    //         subtitleText: (modelData?.connected ?? false) ? "connected" : ""
    //         onClicked: {
    //             // popup.open();
    //         }

    //     }
    // }
}
