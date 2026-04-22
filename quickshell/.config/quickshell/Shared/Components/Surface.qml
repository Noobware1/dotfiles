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

    readonly property list<shadow_elevation> __shadows: Elevation.shadowsFor(elevation)

    implicitHeight: implicitContentHeight ? implicitContentHeight + (verticalPadding * 2) : 0
    implicitWidth: implicitContentWidth ? implicitContentWidth + horizontalPadding * 2 : 0

    default property alias delegatedChildren: delegate.data

    readonly property size elevationSize: {
        if (!__shadows.length) {
            return Qt.size(0, 0);
        } else {
            let spread = 0;
            let blur = 0;
            let offset = 0;
            for (var i = 0; i < __shadows.length; i++) {
                const e = __shadows[i];
                spread = Math.max(spread, e.spread);
                blur = Math.max(blur, e.blur);
                offset = Math.max(offset, e.offset);
            }
            // width and height
            return Qt.size(spread, spread + blur + offset);
        }
    }

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
        height: surface.height
        width: surface.width
        color: MaterialTheme.colorScheme.surface

        Item {
            id: delegate
            anchors.fill: parent
            anchors.topMargin: surface.verticalPadding
            anchors.bottomMargin: surface.verticalPadding
            anchors.leftMargin: surface.horizontalPadding
            anchors.rightMargin: surface.horizontalPadding
        }
    }

    component Shadow: RectangularShadow {
        required property var _data
        radius: surface.radius
        anchors.fill: parent
        offset.y: _data.offset
        blur: _data.blur
        spread: _data.spread
        color: _data.color
    }
}
