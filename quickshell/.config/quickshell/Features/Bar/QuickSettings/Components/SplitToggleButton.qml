import QtQuick
import qs.Shared.Components
import QtQuick.Layouts
import Material3
import qs.Features.Bar.QuickSettings.Components

QuickSettingButton {
    id: button
    enabled: !editable

    radius: ButtonDefaults.radiusFor(containerHeight)

    colors: {
        const cs = MaterialTheme.colorScheme;
        let colors = checkable ? ButtonDefaults.filledButtonColors(cs, checked) : ButtonDefaults.filledButtonColors(cs);
        if (expanded) {
            colors.backgroundColor = cs.surfaceContainer;
            colors.contentColor = cs.onSurfaceVariant;
        }
        return colors;
        // return M3.buttonColors({
        //     backgroundColor: cs.surfaceContainer,
        //     contentColor: cs.onSurfaceVariant,
        //     disabledBackgroundColor: editable ? cs.surfaceContainer : Qt.alpha(cs.surface, 0.1),
        //     disabledContentColor: editable ? cs.onSurfaceVariant : Qt.alpha(cs.onSurface, 0.38)
        // }

        // return M3.buttonColors({
        //     backgroundColor: cs.surfaceContainer,
        //     contentColor: cs.onSurfaceVariant,
        //     disabledBackgroundColor: editable ? cs.surfaceContainer : Qt.alpha(cs.surface, 0.1),
        //     disabledContentColor: editable ? cs.onSurfaceVariant : Qt.alpha(cs.onSurface, 0.38)
        // });
    }

    verticalPadding: 6
    horizontalPadding: 6
    spacing: 4

    contentItem: RowLayout {
        property real availableWidth: button.implicitWidth - children[0].implicitWidth + spacing
        spacing: button.spacing
        IconButton {
            variant: ButtonVariant.Filled
            containerHeight: button.availableHeight
            colors: {
                const cs = MaterialTheme.colorScheme;
                let colors = IconButtonDefaults.colorsFor(cs, variant, checked);
                colors.backgroundColor = checked ? cs.primary : cs.surfaceContainerHigh;

                return colors;
            }
            checkable: true
            checked: button.checked
            onToggled: {
                button.checked = checked;
                button.toggled();
            }
            Layout.fillHeight: true
            icon: button.icon
            radius: checked ? ButtonDefaults.radiusFor(containerHeight) : height / 2
            horizontalPadding: IconButtonDefaults.widePaddingFor(containerHeight)
        }
        Marquee {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: button.text
            font: button.font
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
            visible: button.expanded
            backgroundColor: enabled ? button.colors.backgroundColor : button.colors.disabledBackgroundColor
            addGradient: !button.hovered
        }
    }
}
