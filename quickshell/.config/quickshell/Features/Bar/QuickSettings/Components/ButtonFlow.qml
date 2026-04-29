import QtQuick
import Material3

Flow {
    id: layout

    property alias model: repeater.model
    property alias delegate: repeater.delegate

    property real buttonHeight: ButtonDefaults.mediumHeight
    property real buttonExpandedWidth: 180.0
    property real buttonCompactWidth: (buttonExpandedWidth / 2) - (spacing / 2)
    property real contentHeight: (buttonHeight * 3) + (spacing * 2)
    property real contentWidth: (buttonExpandedWidth * 2) + spacing

    spacing: 6

    signal buttonCreated(Item button)

    Repeater {
        id: repeater
        onItemAdded: (_, button) => layout.buttonCreated(button)
    }
}
