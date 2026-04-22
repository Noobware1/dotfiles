import QtQuick
import QtQuick.Shapes

Shape {
    id: shape

    layer.enabled: true
    layer.smooth: true
    preferredRendererType: Shape.CurveRenderer
    property alias color: shapePath.fillColor
    property int corner: Qt.TopLeftCorner
    property real size
    implicitHeight: size
    implicitWidth: size

    ShapePath {
        id: shapePath
        strokeWidth: 0
        pathHints: ShapePath.PathSolid & ShapePath.PathNonIntersecting

        startX: switch (shape.corner) {
        case Qt.TopLeftCorner:
        case Qt.BottomLeftCorner:
            return 0;
        case Qt.TopRightCorner:
        case Qt.BottomRightCorner:
            return shape.size;
        }
        startY: switch (shape.corner) {
        case Qt.TopLeftCorner:
        case Qt.TopRightCorner:
            return 0;
        case Qt.BottomLeftCorner:
        case Qt.BottomRightCorner:
            return shape.size;
        }
        PathAngleArc {
            moveToStart: false
            centerX: shape.size - shapePath.startX
            centerY: shape.size - shapePath.startY
            radiusX: shape.size
            radiusY: shape.size
            startAngle: switch (shape.corner) {
            case Qt.TopLeftCorner:
                return 180;
            case Qt.TopRightCorner:
                return -90;
            case Qt.BottomLeftCorner:
                return 90;
            case Qt.BottomRightCorner:
                return 0;
            }
            sweepAngle: 90
        }
        PathLine {
            x: shapePath.startX
            y: shapePath.startY
        }
    }
}
