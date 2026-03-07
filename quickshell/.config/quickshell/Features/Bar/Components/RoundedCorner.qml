import QtQuick
import QtQuick.Shapes

Shape {
    id: shape
    enum Side {
        TopLeft,
        TopRight,
        BottomLeft,
        BottomRight
    }

    final property int side: RoundedCorner.Side.TopLeft
    final property int implicitSize: 0
    final property color color: "transparent"

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    final readonly property bool isTopLeft: side === RoundedCorner.Side.TopLeft
    final readonly property bool isBottomLeft: side === RoundedCorner.Side.BottomLeft
    final readonly property bool isTopRight: side === RoundedCorner.Side.TopRight
    final readonly property bool isBottomRight: side === RoundedCorner.Side.BottomRight
    final readonly property bool isTop: isTopLeft || isTopRight
    final readonly property bool isBottom: isBottomLeft || isBottomRight
    final readonly property bool isLeft: isTopLeft || isBottomLeft
    final readonly property bool isRight: isTopRight || isBottomRight

    // anchors {
    //     top: shape.isTop ? parent.top : undefined
    //     bottom: shape.isBottom ? parent.bottom : undefined
    //     left: shape.isLeft ? parent.left : undefined
    //     right: shape.isRight ? parent.right : undefined
    // }
    layer.enabled: true
    layer.smooth: true
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        id: shapePath
        strokeWidth: 0
        fillColor: shape.color
        pathHints: ShapePath.PathSolid & ShapePath.PathNonIntersecting

        startX: switch (shape.side) {
        case RoundedCorner.Side.TopLeft:
        case RoundedCorner.Side.BottomLeft:
            return 0;
        case RoundedCorner.Side.TopRight:
        case RoundedCorner.Side.BottomRight:
            return shape.implicitSize;
        }
        startY: switch (shape.side) {
        case RoundedCorner.Side.TopLeft:
        case RoundedCorner.Side.TopRight:
            return 0;
        case RoundedCorner.Side.BottomLeft:
        case RoundedCorner.Side.BottomRight:
            return shape.implicitSize;
        }

        PathAngleArc {
            moveToStart: false
            centerX: shape.implicitSize - shapePath.startX
            centerY: shape.implicitSize - shapePath.startY
            radiusX: shape.implicitSize
            radiusY: shape.implicitSize
            startAngle: switch (shape.side) {
            case RoundedCorner.Side.TopLeft:
                return 180;
            case RoundedCorner.Side.TopRight:
                return -90;
            case RoundedCorner.Side.BottomLeft:
                return 90;
            case RoundedCorner.Side.BottomRight:
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
