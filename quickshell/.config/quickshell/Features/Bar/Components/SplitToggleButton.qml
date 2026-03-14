pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Features.Bar.Components
import Material3

QuickButton {
    id: button
    implicitHeight: containerHeight
    verticalPadding: 0
    horizontalPadding: 0
    property bool innerChecked: false

    readonly property button_colors iconButtonColors: ButtonDefaults.filledButtonColors(MaterialTheme.colorScheme, innerChecked)

    checkable: !expanded
    checked: checkable && innerChecked
    radius: ButtonDefaults.radiusFor(button.containerHeight)

    contentItem: Loader {
        sourceComponent: button.expanded ? splitToggle : iconOnly
    }

    Component {
        id: iconOnly
        Icon {
            name: button.icon.name
            size: button.icon.width
        }
    }

    Component {
        id: splitToggle
        RowLayout {
            spacing: button.spacing
            Button {
                id: iconToggle
                Layout.leftMargin: ButtonDefaults.smallHorizontalPadding / 2
                checkable: true
                checked: button.innerChecked
                Layout.alignment: Qt.AlignVCenter
                radius: iconToggle.checked ? ButtonDefaults.radiusFor(iconToggle.containerHeight) : height / 2
                verticalPadding: ButtonDefaults.smallVerticalPadding
                icon: button.icon
            }
            Label {
                text: button.text
                font: button.font
                color: button.colors.contentColor
                Layout.fillWidth: true
            }
        }
    }
}
