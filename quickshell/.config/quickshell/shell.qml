import Quickshell
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar
import qs.Services
import qs.Core
import qs.Features.OSD
import qs.Features.Bar.Components
import qs.Features.Bar.Models

ShellRoot {
    id: root

    FontLoader {
        id: materialIcons
        source: ":/icons/MaterialSymbolsRounded.ttf"
    }

    Bar {}

    VolumeOverlay {}
    // QuickTest {}

    // PanelWindow {
    //     implicitHeight: rect.implicitHeight
    //     implicitWidth: rect.implicitWidth
    //     color: "transparent"
    //     anchors.top: true
    //     anchors.right: true
    //     focusable: true

    // ColumnLayout {
    //     id: rect
    //     // implicitHeight: view.implicitHeight
    //     // implicitWidth: view.implicitWidth
    //     QuickButtonsView {
    //         id: view
    //
    //         Layout.alignment: Qt.AlignHCenter
    //         property var m: QuickSettingsModel {}
    //         model: m.itemsModel
    //         buttonHeight: ButtonDefaults.mediumHeight
    //         spaceBetween: 6
    //         buttonMaxWidth: 200
    //         buttonMinWidth: 100 - (spaceBetween / 2)
    //         maxColumns: 3
    //         implicitHeight: buttonHeight * maxColumns + (spaceBetween * 2)
    //         implicitWidth: (buttonMaxWidth * 2) + spaceBetween
    //     }
    // }
    // }

    Component.onCompleted: {
        ThemeService.init();
        Preferences.load();
    }
}
