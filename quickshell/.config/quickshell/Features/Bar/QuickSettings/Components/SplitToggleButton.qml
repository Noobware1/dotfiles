import QtQuick
import QtQuick.Layouts
import Material3
import qs.Shared.Components
import qs.Features.Bar.QuickSettings.Components

QuickSettingButton {
    id: button

    radius: ButtonDefaults.radiusFor(containerHeight)

    colors: {
        const cs = MaterialTheme.colorScheme;

        return M3.buttonColors({
            backgroundColor: cs.surfaceContainer,
            contentColor: cs.onSurfaceVariant,
            disabledBackgroundColor: Qt.alpha(cs.surface, 0.1),
            disabledContentColor: Qt.alpha(cs.onSurface, 0.38)
        });
    }
    verticalPadding: 6
    horizontalPadding: 6
    spacing: 4

    contentItem: RowLayout {
        spacing: button.spacing
        IconButton {
            id: iconToggle
            variant: ButtonVariant.Filled
            containerHeight: button.availableHeight
            colors: {
                const cs = MaterialTheme.colorScheme;
                const colors = IconButtonDefaults.colorsFor(cs, variant, checked);
                colors.backgroundColor = checked ? cs.primary : cs.surfaceContainerHigh;
                return colors;
            }
            checkable: true
            checked: button.isChecked
            onToggled: {
                button.checked = checked;
                button.toggled();
            }
            Layout.fillHeight: true
            icon: button.icon
            radius: iconToggle.checked ? ButtonDefaults.radiusFor(iconToggle.containerHeight) : height / 2
            horizontalPadding: IconButtonDefaults.widePaddingFor(containerHeight)
        }
        Label {
            text: button.text
            font: button.font
            color: button.colors.contentColor
            visible: button.expanded
        }
    }
}
