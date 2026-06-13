import QtQuick
import QtQuick.Layouts
import Material3
import qs.Shared.Components
import qs.Features.Bar.QuickSettings.Components

Button {
    id: button
    required property int index
    required property bool expanded
    required property bool isChecked
    readonly property QuickSettingsLayout layoutParent: parent instanceof QuickSettingsLayout ? parent as QuickSettingsLayout : null

    property bool editable: false

    iconSize: expanded ? ButtonDefaults.iconSizeFor(layoutParent.metrics.tileHeight) : IconButtonDefaults.iconSizeFor(layoutParent.metrics.tileHeight)
    // colors: {
    //     const cs = MaterialTheme.colorScheme;
    //     let backgroundColor = cs.surfaceContainer;
    //     let contentColor = cs.onSurfaceVariant;
    //     let disabledBackgroundColor = Qt.alpha(cs.surface, 0.1);
    //     let disabledContentColor = Qt.alpha(cs.onSurface, 0.38);
    //
    //     if (!editable && checkable) {
    //         return M3.buttonColors({
    //             backgroundColor: checked ? cs.primary : cs.surfaceContainer,
    //             contentColor: checked ? cs.onPrimary : cs.onSurfaceVariant,
    //             disabledBackgroundColor: Qt.alpha(cs.surface, 0.1),
    //             disabledContentColor: Qt.alpha(cs.onSurface, 0.38)
    //         });
    //     } else {
    //         return M3.buttonColors({
    //             backgroundColor: cs.surfaceContainer,
    //             contentColor: cs.onSurfaceVariant,
    //             disabledBackgroundColor: editable ? cs.surfaceContainer : Qt.alpha(cs.surface, 0.1),
    //             disabledContentColor: editable ? cs.onSurfaceVariant : Qt.alpha(cs.onSurface, 0.38)
    //         });
    //     }
    // }

    enabled: !editable
    checkable: !expanded
    checked: isChecked
    implicitWidth: expanded ? layoutParent.metrics.buttonExpandedWidth : layoutParent.metrics.buttonCompactWidth
    containerHeight: layoutParent.metrics.tileHeight
    implicitHeight: containerHeight
    verticalPadding: 0
    horizontalPadding: 0

    radius: {
        return !editable && checkable && checked ? ButtonDefaults.radiusFor(containerHeight) : height / 2;
    }

    spacing: 4

    contentItem: RowLayout {
        spacing: button.spacing
        Spacer {}
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
        Spacer {}
    }
}
