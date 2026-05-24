pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

Button {
    id: control
    contentItem: MyLabel {}

    component MyLabel: Label {
        id: label
        text: control.text
    }
}
