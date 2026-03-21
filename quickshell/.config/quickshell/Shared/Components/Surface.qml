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
            data: surface.__shadows[0]
        }
        Shadow {
            data: surface.__shadows[1]
        }
        Shadow {
            data: surface.__shadows[2]
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: MaterialTheme.colorScheme.surface
    }

    component Shadow: RectangularShadow {
        required property var data
        visible: surface.elevation > 0 && surface.enabled
        radius: surface.radius
        anchors.fill: parent
        offset.y: data.offset
        blur: data.blur
        spread: data.spread
        color: data.color
    }
}
