pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar
import qs.Services
import qs.Core
import qs.Features.OSD
import qs.Features.Bar.Components
import qs.Features.Bar.Models
import qs.Features.Search

ShellRoot {
    id: root

    FontLoader {
        id: materialIcons
        source: ":/icons/MaterialSymbolsRounded.ttf"
    }

    Bar {
        id: bar
    }

    SearchBar {
        id: searchBar
    }

    Binding {
        target: WindowManager
        property: "searchBarWindow"
        value: searchBar
    }

    VolumeOverlay {}
    BrightnessOverlay {}

    Component.onCompleted: {
        Preferences.load();
        ThemeService.init();
        NetworkService.init();
    }

    // PanelWindow {
    //     anchors.top: true
    //     // anchors.bottom: true
    //     anchors.right: true
    //     implicitWidth: 600
    //     implicitHeight: 500
    //     focusable: true
    //
    //     SearchField {
    //         id: control
    //         anchors.top: parent.top
    //         anchors.topMargin: 6
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         // anchors.centerIn: parent
    //         focus: true
    //         implicitWidth: 600
    //         font: TextFieldDefaults.font(MaterialTheme.typography)
    //         // suggestionModel: viewModel.filterModel
    //         suggestionModel: DesktopEntries.applications
    //
    //
    //         textRole: "name"
    //         delegate: Rectangle {
    //             id: item
    //
    //             required property var modelData
    //             // required property DesktopEntry modelData
    //             implicitHeight: 56
    //             width: ListView.view.width ?? implicitWidth
    //             color: control.colors.backgroundColor
    //             Label {
    //                 anchors.left: parent.left
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 text: {
    //                     const name = item.modelData.name;
    //                     if (name && name.length > 0) {
    //                         return name;
    //                     } else {
    //                         return "RIzzz";
    //                     }
    //                 }
    //                 color: MaterialTheme.colorScheme.onSurface
    //                 font: MenuDefaults.font(MaterialTheme.typography)
    //             }
    //         }
    //         // delegate: MenuItem {
    //         //     id: item
    //         //     width: ListView.view.width ?? implicitWidth
    //         //     required property DesktopEntry modelData
    //         //     text: modelData.name ?? ""
    //         //     visible: text.length > 0
    //         //     icon.name: modelData?.icon ?? ""
    //         //     contentItem: Label {
    //         //         verticalAlignment: Text.AlignVCenter
    //         //         text: item.text
    //         //     }
    //         // }
    //
    //         popup: Popup {
    //             radius: control.radius
    //             elevation: control.elevation
    //             backgroundColor: "red"
    //             x: control.mirrored ? control.rightInset : control.leftInset
    //
    //             y:  control.height + control.spacing
    //             width: control.width - control.leftInset - control.rightInset
    //             // height: control.Window.height - control.y - control.height - topPadding - bottomPadding
    //             height: implicitContentHeight > 0 ? Math.min(implicitContentHeight + verticalPadding * 2, control.Window.height - control.y - control.height - topPadding - bottomPadding) : 0
    //             // topMargin: 10
    //             // bottomMargin: 10
    //             verticalPadding: 10
    //
    //             contentItem: ListView {
    //                 clip: true
    //                 implicitHeight: contentHeight
    //                 model: control.delegateModel
    //                 currentIndex: control.highlightedIndex
    //                 highlightMoveDuration: 0
    //
    //                 ScrollIndicator.vertical: ScrollIndicator {}
    //             }
    //         }
    //     }
    //
    //
    // }
    // Example {}
}
