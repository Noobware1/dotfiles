import QtQuick
import Material3

QtObject {
    readonly property real tileHeight: ButtonDefaults.mediumHeight
    readonly property real baseTileWidth: 180.0
    readonly property real buttonExpandedWidth: baseTileWidth
    readonly property real buttonCompactWidth: (buttonExpandedWidth / 2) - (spacing / 2)

    readonly property real sliderTrackCompactHeight: SliderDefaults.smallTrackHeight
    readonly property real sliderTrackExpandedHeight: SliderDefaults.mediumTrackHeight
    readonly property real sliderTrackCompactWidth: baseTileWidth
    readonly property real sliderTrackExpandedWidth: maxLayoutWidth
    readonly property real spacing: 6
    readonly property real maxLayoutWidth: (baseTileWidth * 2) + spacing
    readonly property real maxLayoutHeight: (tileHeight * 5) + (spacing * 4)
}
