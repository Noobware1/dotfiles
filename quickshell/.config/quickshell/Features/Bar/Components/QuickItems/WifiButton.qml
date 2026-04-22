pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as C
import qs.Features.Bar.Components
import qs.Features.Bar.Views

SplitToggleButton {
    id: button
    icon.name: "wifi"
    text: "PlaceHolder"

    property real menuHeight
    property C.StackView navigatingStack

    // onClicked: {
    //     navigatingStack.push(networkListView);
    // }
    // Component {
    //     id: networkListView
    //     NetworkListView {
    //         height: button.menuHeight
    //         anchors.left: parent?.left
    //         anchors.right: parent?.right
    //         onBackButtonPressed: button.navigatingStack.pop()
    //     }
    // }
}
