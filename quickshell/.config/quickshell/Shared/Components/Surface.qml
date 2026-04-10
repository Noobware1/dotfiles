pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Material3

Item {
    id: surface
    final property real elevation: 0
    final property alias radius: rect.radius
    final property alias color: rect.color
    final property real implicitContentHeight
    final property real implicitContentWidth

    final property real horizontalPadding
    final property real verticalPadding

    readonly property var __shadows: Elevation.shadowsFor(elevation)

    implicitHeight: implicitContentHeight ? implicitContentHeight + (verticalPadding * 2) + maxElevationOffset : 0
    implicitWidth: implicitContentWidth ? implicitContentWidth + horizontalPadding * 2 : 0

    property real maxElevationSpread: (__shadows.length ? __shadows.reduce((max, o) => o.spread > max ? o.spread : max, -Infinity) : 0)

    property real maxElevationOffset: (__shadows.length ? __shadows.reduce((max, o) => o.offset > max ? o.offset : max, -Infinity) : 0)

    Item {
        id: shadows
        enabled: surface.enabled
        visible: surface.elevation > 0 && enabled
        anchors.fill: surface

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
        height: surface.height - surface.maxElevationOffset
        width: surface.width
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
