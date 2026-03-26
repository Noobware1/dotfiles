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

    colors: {
        const colorScheme = MaterialTheme.colorScheme;
        const cols = ButtonDefaults.filledButtonColors(colorScheme, checkable && checked);
        if (editMode) {
            cols.backgroundColor = colorScheme.surfaceContainer;
            cols.contentColor = colorScheme.onSurfaceVariant;
        }
        return cols;
    }

    readonly property button_colors iconButtonColors: {
        const colorScheme = MaterialTheme.colorScheme;
        let backgroundColor;
        let contentColor;
        if (button.checked && !button.editMode) {
            backgroundColor = colorScheme.primary;
            contentColor = colorScheme.onPrimary;
        } else {
            backgroundColor = colorScheme.surfaceVariant;
            contentColor = colorScheme.onSurfaceVariant;
        }

        return M3.buttonColors({
            backgroundColor: backgroundColor,
            disabledBackgroundColor: Qt.alpha(colorScheme.onSurfaceVariant, 0.1),
            contentColor: contentColor,
            disabledContentColor: Qt.alpha(colorScheme.onSurfaceVariant, 0.38)
        });
    }

    radius: ButtonDefaults.radiusFor(button.containerHeight)
    readonly property button_colors _colors: button.expanded ? button.iconButtonColors : button.colors

    contentItem: RowLayout {
        spacing: button.spacing
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            // Layout.preferredWidth:
            radius: button.checked ? ButtonDefaults.radiusFor(height) : height / 2
            Layout.fillHeight: true
            Layout.topMargin: button.expanded ? 5 : 0
            Layout.bottomMargin: Layout.topMargin
            Layout.leftMargin: Layout.topMargin
            Layout.fillWidth: !button.expanded

            Behavior on radius {
                NumberAnimation {
                    easing.bezierCurve: MotionSpecs.expressiveFastSpatialBezier
                    duration: MotionSpecs.expressiveFastSpatialDuration
                    easing.type: Easing.BezierSpline
                }
            }

            implicitWidth: ButtonDefaults.minimumWidth

            color: {
                if (!button.expanded) {
                    return "transparent";
                }
                return enabled ? button._colors.backgroundColor : button._colors.disabledBackgroundColor;
            }

            Icon {
                anchors.centerIn: parent
                name: button.icon.name
                color: {
                    return enabled ? button._colors.contentColor : button._colors.disabledContentColor;
                }
                size: button.icon.width
            }

            TapHandler {
                enabled: button.expanded
                target: parent
                onTapped: {
                    button.checked = !button.checked;
                    button.toggled();
                }
            }
        }

        Label {
            visible: button.width > button.maximumWidth / 1.5
            text: button.text
            font: button.font
            color: button.colors.contentColor
            Layout.fillWidth: true
        }
    }
}
