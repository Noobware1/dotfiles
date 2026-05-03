pragma ComponentBehavior: Bound

import QtQuick
import Material3

Flow {
    id: layout

    property alias model: repeater.model
    property alias delegate: repeater.delegate

    property real contentHeight: (buttonHeight * 4) + (spacing * 3)
    property real contentWidth: (buttonExpandedWidth * 2) + spacing

    property real buttonHeight: ButtonDefaults.mediumHeight
    property real buttonExpandedWidth: 180.0
    property real buttonCompactWidth: (buttonExpandedWidth / 2) - (spacing / 2)
    property real sliderCompactHeight: SliderDefaults.smallTrackHeight
    property real sliderExpandedHeight: SliderDefaults.mediumTrackHeight
    property real sliderCompactWidth: 180.0
    property real sliderExpandedWidth: sliderCompactWidth * 2 + spacing

    spacing: 6

    signal itemCreated(Item item)

    Repeater {
        id: repeater
        onItemAdded: (_, item) => layout.itemCreated(item)
    }
}
