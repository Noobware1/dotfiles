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
    implicitHeight: StackView.view.implicitHeight
    required property Component overlay

    property bool aboutToClose

    QuickSettingsModel {
        id: _model
    }

    DialogHandler {
        id: dialogHandler
        visualParent: view
        overlay: view.overlay
        anchors.fill: parent
    }

    onAboutToCloseChanged: {
        if (aboutToClose) {
            dialogHandler.forceCloseDialog();
        }
    }

    header: TopAppBar {
        focusPolicy: Qt.TabFocus
        topLeftRadius: view.radius
        topRightRadius: view.radius
        headlineText: "Placeholder"
        subtitleText: "supporting text"
        actions: [
            IconButton {
                icon.name: "edit"
                onClicked: {
                    _model.toggleEditMode();
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
        SwipeView {
            id: swipeView
            clip: true
            orientation: Qt.Vertical
            Repeater {
                model: 2
                QuickSettingsItem {}
            }
        }
        VerticalSpacer {
            value: LayoutSemenatics.pageVerticalPadding
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
        VerticalSpacer {
            value: LayoutSemenatics.pageVerticalPadding
        }
    }

    component QuickSettingsItem: Item {
        implicitHeight: layout.height + LayoutSemenatics.pageVerticalPadding * 2
        implicitWidth: layout.width + LayoutSemenatics.pageHorizontalPadding * 2

        QuickSettingsLayout {
            id: layout

            ButtonGroup {
                id: buttonGroup
                layoutParent: layout
                exclusive: false
                animate: true
                buttons: layout.children.filter(e => e instanceof Button).sort((a, b) => a.index - b.index)
            }

            anchors.centerIn: parent
            model: _model.itemsModel
            height: Math.min(implicitHeight, contentHeight)
            width: contentWidth
            onItemCreated: item => {
                if (item instanceof Button) {
                    const button = item as Button;
                    button.expandedChanged.connect(() => _model.setExpanded(button.index, button.expanded));
                    button.toggled.connect(() => _model.setToggled(button.index, button.checked));
                }
            }
            delegate: DelegateChooser {
                role: "type"
                DelegateChoice {
                    roleValue: QuickSettingItem.wifi
                    WifiButton {
                        required property int index
                        dialogHandler: dialogHandler
                        layoutParent: layout
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.bluetooth
                    BluetoothButton {
                        required property int index
                        layoutParent: layout
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.darkMode
                    DarkModeButton {
                        required property int index
                        layoutParent: layout
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.doNotDisturb
                    DoNotDisturbButton {
                        required property int index
                        layoutParent: layout
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.powerMode
                    PowerModeButton {
                        required property int index
                        layoutParent: layout
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.volume
                    VolumeSlider {
                        required property int index
                        layoutParent: layout
                    }
                }
                DelegateChoice {
                    roleValue: QuickSettingItem.brightness
                    BrightnessSlider {
                        required property int index
                        layoutParent: layout
                    }
                }
            }
        }
    }
}
