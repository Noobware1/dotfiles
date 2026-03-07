import QtQuick
import Material3

Button {
    id: button

    property bool editMode: false
    border.width: editMode ? 1 : -1
    radius: {
        if (editMode) {
            return height / 2;
        }
        return checked ? ButtonDefaults.radiusFor(button.containerHeight) : height / 2;
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: MotionSpecs.expressiveFastSpatialDuration
            easing.bezierCurve: MotionSpecs.expressiveFastSpatialBezier
            easing.type: Easing.BezierSpline
        }
    }
}
