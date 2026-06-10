pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Material3

Button {
    id: button
    required property int orientation
    readonly property bool horizontal: orientation == Qt.Horizontal
    required property real availableLength

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    variant: ButtonVariant.Text
    text: {
        if (horizontal) {
            return Qt.formatDateTime(clock.date, "hh:mm AP - dd MMM yyyy");
        } else {
            // return Qt.formatDateTime(clock.date, "dd\nMM\n-\nhh\nmm\nAP");
            return Qt.formatDateTime(clock.date, "hh\nmm\nAP\n-\ndd\nMM");
        }
    }
    colors.contentColor: MaterialTheme.colorScheme.onSurfaceVariant
    containerHeight: availableLength
    height: horizontal ? availableLength : implicitContentHeight + topPadding + bottomPadding
    width: horizontal ? implicitContentWidth + leftPadding + rightPadding : availableLength

    icon.name: "calendar_month"

    // spacing: 4

    horizontalPadding: horizontal ? ButtonDefaults.horizontalPaddingFor(containerHeight) : 0
    verticalPadding: horizontal ? 0 : ButtonDefaults.horizontalPaddingFor(containerHeight)
    contentItem: Loader {
        sourceComponent: button.horizontal ? horizontalContent : verticalContent
    }

    Component {
        id: horizontalContent
        RowLayout {
            spacing: button.spacing
            Icon {
                name: button.icon.name
                size: button.iconSize
                color: button.colors.contentColor
                Layout.alignment: Qt.AlignVCenter
            }
            Label {
                font: button.font
                text: button.text
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    Component {
        id: verticalContent
        ColumnLayout {
            spacing: button.spacing
            Icon {
                name: button.icon.name
                size: button.iconSize
                color: button.colors.contentColor
                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                font: button.font
                text: button.text
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
