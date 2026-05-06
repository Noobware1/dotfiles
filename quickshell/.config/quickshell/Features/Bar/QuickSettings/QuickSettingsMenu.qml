pragma ComponentBehavior: Bound

import QtQuick
import Material3
import qs.Features.Bar.Models
import qs.Features.Bar.QuickSettings.Views

StackView {
    id: root
    property real radius
    property color backgroundColor
    required property Component overlay
    required property bool aboutToClose
    implicitHeight: Screen.height - 40
    focusPolicy: Qt.TabFocus

    initialItem: QuickSettingsView {
        id: view
        aboutToClose: root.aboutToClose
        radius: root.radius
        overlay: root.overlay
        Component.onCompleted: {
            root.implicitWidth = Qt.binding(() => view.implicitWidth);
        }
    }
}
