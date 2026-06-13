pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Templates as T
import QtQuick.Layouts
import qs.Core
import Material3
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.Features.Search.Models

LazyLoader {
    id: root

    readonly property SearchBarViewModel model: SearchBarViewModel {
        id: viewModel

        onSearchToggled: {
            if (root.active) {
                root.active = false;
            } else {
                root.loading = true;
            }
        }
    }

    PanelWindow {
        id: window
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:overlay"
        WlrLayershell.layer: WlrLayer.Overlay
        focusable: true

        anchors.top: true
        margins.top: Math.round(Screen.height / 3)
        implicitHeight: 400
        implicitWidth: control.implicitWidth
        color: "transparent"

        Binding {
            target: WindowManager
            property: "searchBarWindow"
            value: window
        }

        SearchField {
            id: control
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            // anchors.centerIn: parent
            focus: true
            implicitWidth: 600
            font: TextFieldDefaults.font(MaterialTheme.typography)
            suggestionModel: DesktopEntries.applications
            textRole: "name"
            delegate: MenuItem {
                id: item
                width: ListView.view.width ?? implicitWidth
                required property DesktopEntry modelData
                text: modelData.name ?? ""
                visible: text.length > 0
                icon.name: modelData?.icon ?? ""
                // contentItem: RowLayout {
                contentItem: Label {
                    verticalAlignment: Text.AlignVCenter
                    text: item.text
                }
                // }

            }

            Binding {
                target: viewModel
                property: "searchQuery"
                value: control.text
            }
        }

        HyprlandFocusGrab {
            id: grab
            active: true
            windows: [window, WindowManager.barWindow]
            onActiveChanged: {
                if (!active) {
                    root.active = false;
                }
            }
        }
    }
}
