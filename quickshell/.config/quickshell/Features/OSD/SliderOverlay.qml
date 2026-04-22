pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Material3
import qs.Core
import qs.Services

SimpleOverlay {
    id: overlay

    property string icon
    property real value
    property string text

    signal moved(real value)

    contentItem: RowLayout {
        spacing: 6
        Icon {
            size: LayoutSemenatics.iconSizeMedium
            name: overlay.icon
            color: MaterialTheme.colorScheme.onSurfaceVariant
        }
        Slider {
            id: slider
            implicitWidth: 150
            value: overlay.value
            toolTip: ""
            stopIndicatorItem: null
            onMoved: overlay.moved(value)
        }
        Text {
            Layout.preferredWidth: 32
            text: overlay.text ? overlay.text : `${Math.floor(slider.value * 100)}%`
            font: MaterialTheme.typography.labelLarge
            color: MaterialTheme.colorScheme.onSurfaceVariant
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
