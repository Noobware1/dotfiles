import QtQuick
import QtQuick.Effects
import Material3

Item {
    id: root
    property real contentWidth: t1.implicitWidth
    property real contentHeight: t1.implicitHeight
    property alias text: t1.text
    property alias font: t1.font
    property alias color: t1.color
    property color backgroundColor
    property bool addGradient: true
    clip: true

    Text {
        id: t1
        anchors.verticalCenter: parent.verticalCenter

        property bool isMarquee: false

        NumberAnimation on x {
            running: t1.isMarquee
            onRunningChanged: {
                if (!running && !t1.isMarquee) {
                    t1.x = 0;
                }
            }
            loops: Animation.Infinite
            from: 0
            to: -(root.width + 30)
            duration: 3000
        }

        Text {
            id: t2
            anchors.verticalCenter: parent.verticalCenter
            x: root.width + 30
            text: t1.text
            font: t1.font
            color: t1.color
            visible: t1.isMarquee
        }

        Component.onCompleted: {
            Qt.callLater(() => t1.isMarquee = Qt.binding(() => root.contentWidth > root.width));
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 20
        color: "transparent"
        visible: root.addGradient && t1.isMarquee
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop {
                position: 0.0
                color: Qt.alpha(root.backgroundColor, 0.3)
            }
            GradientStop {
                position: 0.4
                color: Qt.alpha(root.backgroundColor, 0.5)
            }
            GradientStop {
                position: 1.0
                color: root.backgroundColor
            }
        }
    }
}
