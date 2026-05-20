import QtQuick
import Material3

QtObject {

    readonly property real itemHeight: ButtonDefaults.mediumHeight
    readonly property real buttonHeight: ButtonDefaults.mediumHeight
    readonly property real buttonExpandedWidth: 180.0
    readonly property real buttonCompactWidth: (buttonExpandedWidth / 2) - (spacing / 2)

    readonly property real sliderHandleHeight: buttonHeight
    readonly property real sliderCompactHeight: SliderDefaults.smallTrackHeight
    readonly property real sliderExpandedHeight: SliderDefaults.mediumTrackHeight
    readonly property real sliderCompactWidth: 180.0
    readonly property real sliderExpandedWidth: sliderCompactWidth * 2 + spacing
    readonly property real spacing: 6
    readonly property real maxLayoutWidth: (buttonExpandedWidth * 2) + spacing
    readonly property real maxLayoutHeight: (buttonHeight * 5) + (spacing * 4)
}
