import QtQuick
import QtQuick.Layouts
import Material3
import qs.Core

Button {
    id: button

    required property bool editMode
    required property bool selected
    required property real minimumWidth
    required property real maximumWidth
    property bool expanded: false

    implicitWidth: expanded ? maximumWidth : minimumWidth
    border.color: MaterialTheme.colorScheme.outlineVariant
    width: Math.min(Math.max(implicitWidth, minimumWidth), maximumWidth)

    signal dropped(MouseEvent event)

    icon.name: "do_not_disturb"
    text: "do not disturb"
    hoverEnabled: !editMode

    onClicked: {
        console.log(Preferences.getIdk("key"));
        if (editMode) {
            // expanded = !expanded;
        }
    }

    Loader {
        active: button.editMode
        y: 0
        x: button.implicitWidth - implicitWidth
        sourceComponent: Button {
            readonly property real size: 16
            containerHeight: size
            implicitHeight: size
            implicitWidth: size
            icon.name: "remove"
            icon.height: size
            icon.width: size
        }
    }

    border.width: editMode && (selected || Drag.active) ? 2 : -1

    radius: {
        if (editMode) {
            return height / 2;
        }
        return checked ? ButtonDefaults.radiusFor(containerHeight) : height / 2;
    }

    colors: {
        const colorScheme = MaterialTheme.colorScheme;
        const cols = ButtonDefaults.filledButtonColors(colorScheme, checked);
        if (editMode) {
            cols.backgroundColor = colorScheme.surfaceContainer;
            cols.contentColor = colorScheme.onSurfaceVariant;
        }
        return cols;
    }

    MouseArea {
        id: mouseArea
        enabled: button.editMode
        anchors.fill: button
        drag.target: button
        onReleased: event => button.dropped(event)
    }

    Drag.active: mouseArea.drag.active
    Drag.source: button
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    contentItem: RowLayout {
        spacing: 0
        anchors.fill: parent
        Item {
            Layout.fillWidth: true
        }
        Icon {
            name: button.icon.name
            font.family: "Material Symbols Rounded"
            size: button.icon.width
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
        }
        Label {
            Layout.leftMargin: button.spacing
            text: button.text
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
            visible: text.length > 0 && button.implicitWidth - button.icon.width > implicitWidth
        }
        Item {
            Layout.fillWidth: true
        }
    }

    Behavior on implicitWidth {
        NumberAnimation {
            easing.bezierCurve: MotionSpecs.expressiveFastSpatialBezier
            easing.type: Easing.BezierSpline
            duration: MotionSpecs.expressiveFastSpatialDuration
        }
    }
}
