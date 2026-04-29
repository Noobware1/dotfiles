pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as C
import Material3
import qs.Features.Bar.Models
import qs.Features.Bar.QuickSettings.Components
import qs.Core
import qs.Shared.Components

StackView {
    id: root
    property real radius
    property color backgroundColor

    QuickSettingsModel {
        id: model
    }

    focusPolicy: Qt.TabFocus

    initialItem: Page {
        id: mainView
        radius: root.radius
        header: TopAppBar {
            focusPolicy: Qt.TabFocus
            topLeftRadius: root.radius
            topRightRadius: root.radius
            headlineText: "Placeholder"
            subtitleText: "supporting text"
            actions: [
                IconButton {
                    icon.name: "edit"
                    onClicked: {
                        // root.editMode = !root.editMode;
                        // stack.push(networkListView);
                    }
                },
                IconButton {
                    icon.name: "settings"
                    onClicked: {}
                }
            ]
        }
        focusPolicy: Qt.TabFocus
        padding: 0
        contentItem: ColumnLayout {
            C.SwipeView {
                id: swipeView

                Repeater {
                    model: 1
                    delegate: Item {
                        implicitHeight: layout.height + LayoutSemenatics.pageVerticalPadding
                        implicitWidth: layout.width + LayoutSemenatics.pageHorizontalPadding * 2

                        ButtonFlow {
                            id: layout
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            height: contentHeight
                            width: contentWidth
                            model: 6
                            delegate: Button {
                                height: layout.buttonHeight
                                width: layout.buttonExpandedWidth
                                text: "Button"
                            }
                        }
                    }
                }
            }

            C.PageIndicator {
                id: indicator

                count: swipeView.count
                currentIndex: swipeView.currentIndex
                Layout.alignment: Qt.AlignHCenter
                visible: count > 0
            }

            VerticalSpacer {
                space: LayoutSemenatics.pageVerticalPadding
            }
        }

        Component.onCompleted: {
            const view = mainView.StackView.view;
            view.implicitHeight = Qt.binding(() => mainView.implicitHeight);

            view.implicitWidth = Qt.binding(() => mainView.implicitWidth);
        }
    }
}
