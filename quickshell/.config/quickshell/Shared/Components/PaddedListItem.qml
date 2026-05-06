import QtQuick
import Material3
import qs.Shared.Components

ListItem {
    id: item

    anchors.left: parent?.left
    anchors.right: parent?.right
    anchors.leftMargin: (ListView.view as PaddedListView)?.leftPadding
    anchors.rightMargin: (ListView.view as PaddedListView)?.rightPadding

    states: State {
        when: item.visualFocus
        PropertyChanges {
            item {
                z: 2
            }
        }
    }
}
