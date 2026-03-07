import QtQuick
import QtQuick.Layouts
import Material3

Button {
    id: button

    required property bool editMode
    required property bool selected
    required property real minimumWidth
    required property real maximumWidth

    implicitWidth: minimumWidth
    border.color: MaterialTheme.colorScheme.outlineVariant

    icon.name: "do_not_disturb"
    text: "do not disturb"
    hoverEnabled: !editMode

    onClicked: {
        if (editMode) {
            implicitWidth = implicitWidth == maximumWidth ? minimumWidth : maximumWidth;
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

    states: [
        State {
            name: "None"
            PropertyChanges {
                button {
                    colors.backgroundColor: MaterialTheme.colorScheme.primary
                    colors.contentColor: MaterialTheme.colorScheme.onPrimary
                    radius: checked ? ButtonDefaults.radiusFor(containerHeight) : height / 2
                    border.width: -1
                }
            }
        },
        State {
            name: "Removable"
            extend: "None"
            when: button.editMode && !button.selected
            PropertyChanges {
                button {
                    colors.backgroundColor: MaterialTheme.colorScheme.surfaceContainer
                    colors.contentColor: MaterialTheme.colorScheme.onSurfaceVariant
                    radius: height / 2
                }
            }
        },
        State {
            name: "Resizable"
            extend: "Removable"
            when: button.editMode && button.selected
            PropertyChanges {
                button {
                    border.width: 2
                }
            }
        }
    ]

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
