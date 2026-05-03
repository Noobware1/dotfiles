import QtQuick
import Material3
import qs.Features.Bar.QuickSettings.Components

Slider {
    required property bool expanded
    required property QuickSettingsLayout layoutParent

    implicitWidth: expanded ? layoutParent.sliderExpandedWidth : layoutParent.sliderCompactWidth
    trackHeight: expanded ? layoutParent.sliderExpandedHeight : layoutParent.sliderCompactHeight
    stopIndicator: null
}
