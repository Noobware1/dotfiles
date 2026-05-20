import QtQuick
import Material3
import qs.Features.Bar.QuickSettings.Components

Slider {
    id: slider
    required property int index
    required property bool expanded
    property QuickSettingsLayout layoutParent: parent instanceof QuickSettingsLayout ? parent as QuickSettingsLayout : null
    property bool editable: false

    implicitWidth: expanded ? layoutParent.metrics.sliderTrackExpandedWidth : layoutParent.metrics.sliderTrackCompactWidth
    trackHeight: expanded ? layoutParent.metrics.sliderTrackExpandedHeight : layoutParent.metrics.sliderTrackCompactHeight
    implicitHeight: layoutParent.metrics.tileHeight
    stopIndicator: null
    enabled: !editable

    Binding {
        when: slider.editable
        slider {
            value: 0
        }
    }
}
