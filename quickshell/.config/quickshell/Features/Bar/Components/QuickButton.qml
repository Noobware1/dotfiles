pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3

Button {
    id: button
    property real minimumWidth
    property real maximumWidth
    property int index
    property Item dragParent
    property bool editMode: false
    property bool selected: false
    property bool expanded: false
    property alias resizeActive: resizeHandle.dragActive

    checkable: !expanded

    width: Math.min(Math.max(implicitWidth, minimumWidth), maximumWidth)
    implicitWidth: expanded ? maximumWidth : minimumWidth

    border.color: MaterialTheme.colorScheme.outlineVariant

    icon.name: "do_not_disturb"
    text: "do not disturb"
    hoverEnabled: !editMode

    signal remove
    signal drag(x: real, y: real)

    Loader {
        active: button.editMode && !button.selected
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
            onClicked: button.remove()
        }
    }

    border.width: editMode && (selected || parent.Drag.active) ? 2 : -1

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

    Loader {
        id: resizeHandle
        active: button.editMode && button.selected
        anchors.verticalCenter: parent.verticalCenter
        onActiveChanged: {
            if (!active) {
                button.implicitWidth = Qt.binding(() => button.expanded ? button.maximumWidth : button.minimumWidth);
            }
        }
        property bool dragActive: item?.dragActive ?? false

        sourceComponent: Item {
            property bool dragActive: __resizeDrag.drag.active
            Item {
                id: dragHandle

                property real value: (dragHandle.x - __resizeDrag.drag.minimumX) / (__resizeDrag.drag.maximumX - __resizeDrag.drag.minimumX)
                onValueChanged: {
                    button.implicitWidth = button.minimumWidth + value * (button.maximumWidth - button.minimumWidth);
                }

                anchors.verticalCenter: parent.verticalCenter
                height: button.implicitHeight / 2.5
                width: 15
                x: button.width - width

                Drag.active: __resizeDrag.drag.active
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2
            }

            MouseArea {
                id: __resizeDrag
                propagateComposedEvents: true
                parent: dragHandle
                anchors.fill: dragHandle
                drag.target: dragHandle
                drag.axis: Drag.XAxis
                drag.minimumX: button.minimumWidth - dragHandle.width
                drag.maximumX: button.maximumWidth - dragHandle.width
                onReleased: function (event) {
                    event.accepted = true;
                    button.expanded = dragHandle.value > 0.5;
                    dragHandle.x = button.expanded ? drag.maximumX : drag.minimumX;
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height: button.implicitHeight / 2.5
                width: 4
                radius: 2
                color: MaterialTheme.colorScheme.primary
                x: button.width - width
            }
        }
    }

    contentItem: RowLayout {
        spacing: 0
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
            visible: button.expanded
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

    DragHandler {
        id: dragHandler
        target: button
        enabled: button.editMode && !(resizeHandle.dragActive ?? false)
        onActiveChanged: {}
        onCentroidChanged: {
            if (active) {
                const pos = centroid.position;
                button.drag(pos.x, pos.y);
            } else if (centroid.position.x == 0 && centroid.position.y == 0) {
                // button.move();
            }
        }
    }

    Drag.active: dragHandler.active
    Drag.source: button
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    states: State {
        when: dragHandler.active
        PropertyChanges {
            button.z: 1000
        }
        ParentChange {
            target: button
            parent: button.dragParent
        }
    }
}
