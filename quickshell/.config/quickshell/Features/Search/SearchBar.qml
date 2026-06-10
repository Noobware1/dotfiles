pragma ComponentBehavior: Bound
import QtQuick
import qs.Core
import QtQuick.Controls as C
import Material3
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland

LazyLoader {
    id: root

    readonly property list<QtObject> data: [
        IpcHandler {
            target: "search"

            function toggle() {
                if (root.active) {
                    root.active = false;
                } else {
                    root.loading = true;
                }
            }
        }
    ]

    PanelWindow {
        id: window
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.namespace: "quickshell:overlay"
        WlrLayershell.layer: WlrLayer.Overlay
        focusable: true

        anchors.top: true
        margins.top: Math.round(Screen.height / 3)
        implicitHeight: search.implicitHeight + 12
        implicitWidth: search.implicitWidth
        color: "transparent"

        Binding {
            target: WindowManager
            property: "searchBarWindow"
            value: window
        }

        SearchField {
            id: search
            anchors.centerIn: parent
            focus: true
            implicitWidth: 600
            font: TextFieldDefaults.font(MaterialTheme.typography)
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
