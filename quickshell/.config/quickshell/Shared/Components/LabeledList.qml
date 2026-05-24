import Material3
import QtQuick

Item {
    id: root

    property alias label: _label.text
    property alias model: repeater.model
    property alias delegate: repeater.delegate

    property real labelPadding: 16
    property bool fillWidth: true

    readonly property int lastIndex: repeater.count - 1

    implicitHeight: _label.implicitHeight + labelPadding + layout.implicitHeight

    implicitWidth: Math.max(_label.implicitWidth, layout.implicitWidth)


    Label {
        id: _label

        font: MaterialTheme.typography.titleMedium
        color: MaterialTheme.colorScheme.onSurface
        visible: _label.text.length > 0
    }

    Column {
        id: layout

        y: _label.implicitHeight + root.labelPadding
        width: root.width
        spacing: 2

        Repeater {
            id: repeater
            onItemAdded: function(_, item) {
                if (root.fillWidth) {
                    item.width = Qt.binding(() => root.width)
                }
            }
        }
    }
}
