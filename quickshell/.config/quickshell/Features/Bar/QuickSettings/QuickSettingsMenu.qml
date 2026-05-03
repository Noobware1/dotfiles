pragma ComponentBehavior: Bound

import QtQuick
import Material3
import qs.Features.Bar.Models
import qs.Features.Bar.QuickSettings.Views

StackView {
    id: root
    property real radius
    property color backgroundColor
    implicitHeight: Screen.height - 40

    focusPolicy: Qt.TabFocus

    initialItem: QuickSettingsView {
        id: view
        radius: root.radius
        Component.onCompleted: {
            root.implicitWidth = Qt.binding(() => view.implicitWidth);
        }
    }
}
