pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.Features.Bar.Components
import Material3

QuickButton {
    id: button
    verticalPadding: 0
    horizontalPadding: 0
    property real margin: 6
    property bool maybeExpanded: (button.editMode && button.width > button.minimumWidth + 10) || (!button.editMode && button.expanded)

    radius: {
        if (button.editMode) {
            return height / 2;
        }
        if (expanded) {
            return ButtonDefaults.radiusFor(containerHeight);
        }
        return checkable && checked ? ButtonDefaults.radiusFor(containerHeight) : height / 2;
    }

    contentItem: RowLayout {
        clip: button.editMode
        spacing: 0
        anchors.centerIn: parent
        Item {
            Layout.fillWidth: true
            visible: !button.maybeExpanded
        }
        Loader {
            Layout.leftMargin: button.maybeExpanded ? button.margin : 0
            sourceComponent: button.maybeExpanded ? toggleButton : iconOnly
            onLoaded: {
                if (item instanceof Button) {
                    item.checked = button.checked;
                }
            }
        }
        Label {
            Layout.leftMargin: button.spacing
            visible: button.maybeExpanded
            text: button.text
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
        }
        Item {
            Layout.fillWidth: true
        }
    }

    Component {
        id: iconOnly
        Icon {
            name: button.icon.name
            size: button.icon.width
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
        }
    }

    Component {
        id: toggleButton
        Button {
            icon: button.icon
            implicitHeight: containerHeight - (button.margin * 2)
            containerHeight: button.containerHeight
            implicitWidth: implicitHeight
            checkable: true
            radius: {
                if (button.editMode) {
                    return height / 2;
                }
                return checkable && checked ? ButtonDefaults.extraSmallRadius : height / 2;
            }

            onToggled: {
                button.checked = checked;
                button.toggled();
            }
            colors: {
                const colorScheme = MaterialTheme.colorScheme;

                return M3.buttonColors({
                    backgroundColor: !button.editMode && checkable && checked ? colorScheme.primary : colorScheme.surfaceVariant,
                    contentColor: !button.editMode && checkable && checked ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    disbaledBackgroundColor: Qt.alpha(colorScheme.surface, 0.1),
                    disbaledContentColor: Qt.alpha(colorScheme.onSurfaceVariant, 0.38)
                });
            }
        }
    }
}
