pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.QuickSettings.Components
import qs.Features.Bar.QuickSettings.Components.QuickSettingsItems
import qs.Features.Bar.QuickSettings.Models
import qs.Shared.Components
import qs.Core

Page {
    id: view
    implicitHeight: StackView.view?.implicitHeight ?? 0

    QuickSettingsModel {
        id: viewModel
    }

    function push(page: Component): void {
        StackView.view.push(page);
    }
    header: TopAppBar {
        focusPolicy: Qt.TabFocus
        topLeftRadius: view.radius
        topRightRadius: view.radius
        headlineText: viewModel.userName
        horizontalPadding: LayoutSemenatics.pageHorizontalPadding
        subtitleText: `Up ${viewModel.uptime}`
        spacing: 12
        topPadding: 6
        leading: Rectangle {
            implicitHeight: 50
            implicitWidth: 50
            radius: 50 / 2
            anchors.verticalCenter: parent.verticalCenter
            color: MaterialTheme.colorScheme.primary
            Icon {
                anchors.centerIn: parent
                name: "person"
                color: MaterialTheme.colorScheme.onPrimary
                size: 32
            }
        }
        actions: [
            IconButton {
                icon.name: "edit"
                onClicked: {
                    view.push(editPage);
                    // viewModel.toggleEditMode();
                }
            },
            IconButton {
                icon.name: "settings"
                onClicked: {}
            },
            IconButton {
                icon.name: "power_settings_new"
                onClicked: {}
            }
        ]
    }
    focusPolicy: Qt.TabFocus
    padding: 0

    contentItem: ColumnLayout {
        spacing: 0
        PageIndicator {
            count: swipeView.count
            size: 6
            currentIndex: swipeView.currentIndex
            Layout.alignment: Qt.AlignHCenter
            visible: count > 1
        }
        QuickSettingsSwipeView {
            id: swipeView
            model: viewModel
            DelegateChooser {
                role: "type"
                DelegateChoice {
                    roleValue: QuickSettingItem.wifi
                    WifiButton {
                        onOpenSettings: {
                            view.push(internetSettingsPage);
                        }
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.bluetooth
                    BluetoothButton {
                        onOpenSettings: {
                            view.push(bluetoothSettingsPage);
                        }
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.darkMode
                    DarkModeButton {}
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.doNotDisturb
                    DoNotDisturbButton {}
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.powerMode
                    PowerModeButton {}
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.volume
                    VolumeSlider {}
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.brightness
                    BrightnessSlider {}
                }
            }
        }
        ExplicitSpacer {
            vertical: LayoutSemenatics.pageVerticalPadding
        }
        Surface {
            elevation: 4
            radius: 18
            color: MaterialTheme.colorScheme.surfaceContainerHigh
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rightMargin: LayoutSemenatics.pageHorizontalPadding
            Layout.leftMargin: LayoutSemenatics.pageHorizontalPadding
        }
        ExplicitSpacer {
            vertical: LayoutSemenatics.pageVerticalPadding
        }
    }

    Component {
        id: internetSettingsPage
        InternetView {}
    }

    Component {
        id: bluetoothSettingsPage
        BluetoothView {}
    }

    Component {
        id: editPage
        QuickSettingsEditView {
            itemsModel: viewModel.itemsModel
        }
    }
}
