pragma ComponentBehavior: Bound
import Material3
import QtQuick
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.QuickSettings.Components
import qs.Features.Bar.QuickSettings.Models
import qs.Features.Bar.QuickSettings.Components.QuickSettingsItems
import qs.Core

SwipeView {
    id: swipeView
    clip: true
    orientation: Qt.Vertical
    onContentHeightChanged: console.log("contentHeight:", contentHeight)
    onHeightChanged: console.log("height:", height)
    required property QuickSettingsModel model

    function populate() {
        const model = swipeView.model.itemsModel;
        let currentSpace = 0;
        let columnCount = 0;
        let page = 0;
        let lastIndex = -1;
        let data = [];

        for (var i = 0; i < model.count; i++) {
            const item = model.get(i);
if(item.isSlider()) {
	
}else {
}
        }
    }

    Repeater {
        id: repeater
        model: 2
        QuickSettingsItem {}
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
            model: swipeView.model
            height: Math.min(implicitHeight, contentHeight)
            width: contentWidth
            onItemCreated: item => {
                if (item instanceof Button) {
                    const button = item as Button;
                    button.expandedChanged.connect(() => swipeView.model.setExpanded(button.index, button.expanded));
                    button.toggled.connect(() => swipeView.model.setToggled(button.index, button.checked));
                }
            }
            delegate: DelegateChooser {
                role: "type"
                DelegateChoice {
                    roleValue: QuickSettingItem.wifi
                    WifiButton {
                        required property int index
                        onOpenSettings: {}
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

    // ROUTES
    // Component {
    //     id: internetView
    //     InternetView {}
    // }
}
