pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls as C
import QtQuick.Layouts
import Material3
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.QuickSettings.Views
import qs.Features.Bar.QuickSettings.Models
import qs.Shared.Components
import qs.Core
import Quickshell.Networking

Page {
    id: view
    property QuickSettingsMenu menu: StackView.view as QuickSettingsMenu
    implicitHeight: menu?.implicitHeight ?? 0
    implicitWidth: menu?.implicitWidth ?? 0
    radius: menu?.radius ?? 0
    backgroundColor: menu?.backgroundColor ?? "transparent"
    readonly property InternetViewModel model: InternetViewModel {}

onOpenMenu: function(network, offset) {
menu.x = offset.x
menu.y = offset.y
menu.open()
}

	Menu {

		id:menu		
MenuItem {
text: "Forget"
}
MenuItem {
text: "More"
}
	}

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
                model: view.model.savedNetworks
                visible: model.values.length > 0
            }
            LabelAndItem {
                label: "Networks"
                model: view.model.availableNetworks
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
        ExplicitSpacer {
            vertical: 16
        }
        Repeater {
            id: repeater
            model: 4
            delegate: MListItem {
                Layout.fillWidth: true
                lastIndex: repeater.count - 1
onClickedOptions: {
	view.openMenu(modelData, Qt.point(pressX,pressY))
}
                onClicked: {
                    view.menu.push(networkAuthPage, {
                        network: modelData
                    });
                }
            }
        }
    }

signal openMenu(Network network, point offset)

    component MListItem: ListItem {
        id: item
        required property int index
        required property int lastIndex
        required property WifiNetwork modelData
        readonly property bool connected: (modelData?.connected ?? false)
        subtitleText: connected ? "connected" : ""
        elevation: 0
        colors: {
            const cs = MaterialTheme.colorScheme;
            const colors = ListDefaults.colors(cs);
            colors.backgroundColor = connected ? cs.secondaryContainer : cs.surfaceContainerHigh;
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
signal clickedOptions

        trailing: Loader {
            anchors.centerIn: parent
            sourceComponent: (item.modelData?.known ?? false) ? moreButton : lockedIcon
            Component {
                id: lockedIcon
                Item {
                    implicitHeight: IconButtonDefaults.smallHeight
                    implicitWidth: IconButtonDefaults.smallUniformPadding * 2 + icon.implicitWidth
                    Icon {
                        id: icon
                        anchors.centerIn: parent
                        name: "lock"
                        size: ListDefaults.iconSize
                    }
                }
            }
            Component {
                id: moreButton
                IconButton {
                    icon.name: "more_vert"
			onClicked: item.clickedOptions()
                }
            }
        }
    }

    Component {
        id: networkAuthPage
        NetworkAuthView {
            network: view.selectedNetwork
        }
    }
}
