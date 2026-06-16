pragma ComponentBehavior: Bound

import QtQuick
import qs.Shared.Components
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
            // root.toggle();
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
        implicitWidth: searchField.implicitWidth
        color: "transparent"

        signal closed

        function open() {
            searchField.open();
        }

        function close() {
            searchField.close();
        }

        // Menu {}

        mask: Region {
            intersection: Intersection.Xor
            item: Item {
                anchors.bottom: parent?.bottom ?? undefined
                width: window.width
                height: window.height - searchField.height - 6 - searchField.popup.height
            }
        }

        Binding {
            target: WindowManager
            property: "searchBarWindow"
            value: window
        }

        SearchField {
            id: searchField
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            focus: true
            implicitWidth: 600
            font: TextFieldDefaults.font(MaterialTheme.typography)
            suggestionModel: viewModel.suggestionModel
            textRole: "name"

            function open() {
                state = "open";
            }

            function close() {
                state = "close";
            }

            // scale: 0.4
            // opacity: 0
            // states: [
            //     State {
            //         name: "open"
            //         PropertyChanges {
            //             searchField {
            //                 scale: 1.0
            //                 opacity: 1.0
            //             }
            //         }
            //     },
            //     State {
            //         name: "close"
            //         PropertyChanges {
            //             searchField {
            //                 scale: 0.4
            //                 opacity: 0
            //             }
            //         }
            //     }
            // ]
            //
            // transitions: Transition {
            //     onRunningChanged: {
            //         if (!running && searchField.state == "close") {
            //             window.closed();
            //         }
            //     }
            //     NumberAnimation {
            //         property: "scale"
            //         easing.type: Easing.OutQuint
            //         duration: 220
            //     }
            //     NumberAnimation {
            //         property: "opacity"
            //         easing.type: Easing.OutCubic
            //         duration: 150
            //     }
            // }

            delegate: MenuItem {
                id: item
                width: ListView.view.width ?? implicitWidth
                required property DesktopEntry modelData
                text: modelData.name ?? ""
                visible: text.length > 0
                icon.source: Quickshell.iconPath(modelData.icon)
                contentItem: RowLayout {
                    spacing: item.spacing
                    Image {
                        source: item.icon.source
                        Layout.preferredHeight: item.icon.height
                        Layout.preferredWidth: item.icon.width
                        sourceSize.height: item.icon.height
                        sourceSize.width: item.icon.width
                        visible: item.icon.source
                    }
                    Label {
                        verticalAlignment: Text.AlignVCenter
                        text: item.text
                    }
                    Spacer {}
                }
            }

            Binding {
                target: viewModel
                property: "searchQuery"
                value: searchField.text
            }
        }

        HyprlandFocusGrab {
            id: grab
            active: true
            windows: [window, WindowManager.barWindow]
            onActiveChanged: {
                if (!active) {
                    // searchField.close();
                    root.active = false;
                }
            }
        }
    }
}
