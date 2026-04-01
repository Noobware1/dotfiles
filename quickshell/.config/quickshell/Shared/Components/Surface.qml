pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Material3

Item {
    id: surface
    property real elevation: 0
    // color: "red"
    property var __shadows: Elevation.shadowsFor(elevation)
    property alias radius: rect.radius
    property alias color: rect.color

    Item {
        id: shadows
        enabled: surface.enabled
        visible: surface.elevation > 0 && enabled
        anchors.fill: rect

        Shadow {
            _data: surface.__shadows[0]
        }
        Shadow {
            _data: surface.__shadows[1]
        }
        Shadow {
            _data: surface.__shadows[2]
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: MaterialTheme.colorScheme.surface
    }

    component Shadow: RectangularShadow {
        required property var _data
        visible: surface.elevation > 0 && surface.enabled
        radius: surface.radius
        anchors.fill: parent
        offset.y: _data.offset
        blur: _data.blur
        spread: _data.spread
        color: _data.color
    }
}
