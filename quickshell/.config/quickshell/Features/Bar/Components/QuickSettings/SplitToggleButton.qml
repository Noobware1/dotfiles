import QtQuick
import QtQuick.Layouts
import Material3

Button {
    id: control
    implicitHeight: containerHeight
    verticalPadding: 0
    horizontalPadding: 0
    colors.backgroundColor: MaterialTheme.colorScheme.surfaceContainer
    colors.contentColor: MaterialTheme.colorScheme.onSurfaceVariant
    property real verticalMargin: 0

    readonly property button_colors iconButtonColors: ButtonDefaults.filledButtonColors(MaterialTheme.colorScheme, contentItem.children[1].checked)

    radius: ButtonDefaults.radiusFor(control.containerHeight)

    contentItem: RowLayout {
        spacing: 0
        Item {
            implicitWidth: control.verticalMargin
        }
        IconToggle {
            containerHeight: control.containerHeight - (control.verticalMargin * 2)
            implicitHeight: containerHeight
            colors: control.iconButtonColors
            icon: control.icon
        }
        Item {
            implicitWidth: control.spacing
        }
        Label {
            text: control.text
            font: control.font
            color: control.colors.contentColor
            Layout.fillWidth: true
        }
        Item {
            implicitWidth: ButtonDefaults.horizontalPaddingFor(control.containerHeight)
        }
    }

    component IconToggle: Button {
        id: iconToggle
        checkable: true
        Layout.alignment: Qt.AlignVCenter
        radius: iconToggle.checked ? ButtonDefaults.radiusFor(iconToggle.containerHeight) : height / 2
        verticalPadding: 0
    }
}
