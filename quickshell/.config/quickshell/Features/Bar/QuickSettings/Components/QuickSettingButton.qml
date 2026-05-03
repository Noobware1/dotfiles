import QtQuick
import QtQuick.Layouts
import Material3
import qs.Shared.Components
import qs.Features.Bar.QuickSettings.Components

Button {
    id: button
    required property bool expanded
    required property bool isChecked
    required property QuickSettingsLayout layoutParent

    checkable: !expanded
    checked: isChecked
    implicitWidth: expanded ? layoutParent.buttonExpandedWidth : layoutParent.buttonCompactWidth
    containerHeight: layoutParent.buttonHeight
    implicitHeight: containerHeight
    verticalPadding: 0
    horizontalPadding: 0

    radius: {
        return checkable && checked ? ButtonDefaults.radiusFor(containerHeight) : height / 2;
    }

    spacing: 4

    contentItem: RowLayout {
        spacing: button.spacing
        Spacer {
            Layout.fillWidth: true
        }
        Icon {
            font.hintingPreference: Font.PreferNoHinting
            name: button.icon.name
            size: button.icon.width
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }
        Label {
            Layout.leftMargin: button.spacing
            visible: button.expanded
            text: button.text
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
        }
        Spacer {
            Layout.fillWidth: true
        }
    }
}
