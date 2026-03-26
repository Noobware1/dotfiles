pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Material3

Button {
    id: button

    enum Type {
        Wifi,
        Bluetooth,
        Dnd,
        DarkMode,
        PowerMode
    }

    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
    }

    required property real minimumWidth
    required property real maximumWidth
    required property int index
    required property bool expanded
    required property Item dragParent

    property bool editMode: false
    property bool selected: false

    checkable: !expanded && !editMode
    checked: checkable && false

    width: Math.min(Math.max(implicitWidth, minimumWidth), maximumWidth)
    implicitWidth: expanded ? maximumWidth : minimumWidth

    border.color: MaterialTheme.colorScheme.outlineVariant

    hoverEnabled: !editMode

    signal remove
    signal drag(x: real, y: real)

    border.width: editMode && (selected || dragHandler.active) ? 2 : -1

    radius: {
        if (editMode) {
            return height / 2;
        }
        return checked ? ButtonDefaults.radiusFor(containerHeight) : height / 2;
    }

    colors: {
        const colorScheme = MaterialTheme.colorScheme;

        if (checkable && !editMode) {
            return ButtonDefaults.filledButtonColors(MaterialTheme.colorScheme, checked);
        }

        return M3.buttonColors({
            backgroundColor: colorScheme.surfaceContainer,
            contentColor: colorScheme.onSurfaceVariant,
            disbaledBackgroundColor: Qt.alpha(colorScheme.surface, 0.1),
            disbaledBackgroundColor: Qt.alpha(colorScheme.onSurfaceVariant, 0.38)
        });
    }

    // Remove button
    Loader {
        active: button.editMode && !button.selected && !dragHandler.active
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

    // Resize handle
    Loader {
        id: resizeHandle
        active: button.editMode && button.selected && !dragHandler.active
        anchors.verticalCenter: parent.verticalCenter
        onActiveChanged: {
            if (!active) {
                button.implicitWidth = Qt.binding(() => button.expanded ? button.maximumWidth : button.minimumWidth);
            }
        }
        property bool dragActive: false
        property real value: 0

        sourceComponent: Item {
            Item {
                id: dragHandle

                property real value: (dragHandle.x - __resizeDrag.drag.minimumX) / (__resizeDrag.drag.maximumX - __resizeDrag.drag.minimumX)
                onValueChanged: {
                    button.implicitWidth = button.minimumWidth + value * (button.maximumWidth - button.minimumWidth);
                    resizeHandle.value = value;
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
                drag.onActiveChanged: {
                    resizeHandle.dragActive = drag.active;
                }
                onReleased: function (event) {
                    event.accepted = true;
                    button.expanded = dragHandle.value > 0.5;
                    dragHandle.x = button.expanded ? drag.maximumX : drag.minimumX;
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height: 16
                width: 6
                radius: width / 2
                color: MaterialTheme.colorScheme.primary
                x: button.width - width
            }
        }
    }
    clip: true

    contentItem: RowLayout {
        Item {
            Layout.fillWidth: true
        }
        Icon {
            name: button.icon.name
            size: button.icon.width

            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
            Layout.alignment: Qt.AlignVCenter
        }
        Label {
            Layout.leftMargin: button.spacing
            visible: (button.editMode && button.width > button.minimumWidth + 10) || (!button.editMode && button.expanded)
            text: button.text
            color: enabled ? button.colors.contentColor : button.colors.disabledContentColor
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
        enabled: button.editMode
        onCentroidChanged: {
            if (active) {
                const pos = centroid.position;
                button.drag(pos.x, pos.y);
            }
            // else if (centroid.position.x == 0 && centroid.position.y == 0) {
            // }
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
        AnchorChanges {
            target: button
            anchors {
                horizontalCenter: undefined
                verticalCenter: undefined
            }
        }
    }
}
