pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as C
import Material3
import qs.Features.Bar.Models
import qs.Shared.Components
import qs.Features.Bar.Components

Dismissable {
    id: root

    verticalPadding: 16
    explicit: true

    readonly property real compactMargins: 16 * 2
    property real contentPadding: 8

    property bool editMode: false

    onEditModeChanged: {
        if (!editMode) {
            root.model.saveState();
        }
    }

    readonly property QuickSettingsModel model: QuickSettingsModel {}

    readonly property real buttonMaxWidth: 180
    readonly property real spacing: 6
    readonly property real buttonMinWidth: (buttonMaxWidth / 2) - (spacing / 2)
    readonly property real buttonHeight: ButtonDefaults.mediumHeight
    readonly property real expandedHeight: (buttonHeight * 6) + (spacing * 5)

    radius: 20
    color: MaterialTheme.colorScheme.surface

    implicitHeight: implicitContentHeight + verticalPadding * 2
    implicitWidth: (root.buttonMaxWidth * 2) + root.compactMargins + root.spacing + (root.contentPadding * 2)

    contentItem: C.StackView {
        id: stack
        initialItem: mainView
        implicitHeight: currentItem.implicitHeight
        implicitWidth: root.implicitWidth

        anchors {
            left: parent.left
            right: parent.right
            leftMargin: root.compactMargins / 2
            rightMargin: root.compactMargins / 2
        }
    }

    Component {
        id: mainView
        ColumnLayout {
            id: column
            spacing: 0
            width: parent.width
            VerticalSpacer {
                space: root.spacing
            }
            Header {}
            VerticalSpacer {
                space: root.spacing
                visible: root.editMode
            }
            Loader {
                sourceComponent: root.editMode ? buttonEditView : buttonSwipeView
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true

                Component {
                    id: buttonSwipeView
                    QuickButtonSwipeView {
                        id: view
                        anchors.fill: parent
                        maxColumns: 3
                        model: root.model.itemsModel
                        buttonHeight: root.buttonHeight
                        buttonMaxWidth: root.buttonMaxWidth
                        buttonMinWidth: root.buttonMinWidth
                        spaceBetween: root.spacing
                        contentPadding: root.contentPadding
                        onSetChecked: function (index: int, toggled: bool) {
                            root.model.setToggled(index, toggled);
                        }
                    }
                }
            }
            VerticalSpacer {
                space: root.spacing
            }
            VolumeSlider {}
            VerticalSpacer {
                space: root.spacing
            }
            BrightnessSlider {}
        }
    }

    component MSlider: Slider {
        Layout.rightMargin: root.contentPadding
        Layout.leftMargin: root.contentPadding
        Layout.fillWidth: true
        trackHeight: SliderDefaults.mediumTrackHeight
        stopIndicatorItem: null
    }

    component VolumeSlider: MSlider {
        icon.name: "volume_up"
        toolTip: `${Math.floor(value * 100)}%`
        value: root.model.volume
        onMoved: {
            root.model.setVolume(value);
        }
    }

    component BrightnessSlider: MSlider {
        icon.name: "brightness_7"
    }

    component Header: RowLayout {
        id: header
        height: 52
        Layout.fillWidth: true
        spacing: root.spacing
        // radius: 16
        // elevation: 2
        // color: MaterialTheme.colorScheme.surfaceContainer

        Item {
            Layout.fillWidth: true
        }
        IconButton {
            icon.name: "edit"
            onClicked: {
                root.editMode = !root.editMode;
            }
        }
        IconButton {
            icon.name: "settings"
            onClicked: {}
        }
    }

    Component {
        id: buttonEditView
        QuickButtonEditView {
            contentPadding: root.contentPadding
            contentHeight: buttonHeight * 6 + spacing * 5 + contentPadding * 2

            model: root.model.itemsModel
            buttonHeight: root.buttonHeight
            buttonMaxWidth: root.buttonMaxWidth
            buttonMinWidth: root.buttonMinWidth
            spaceBetween: root.spacing
            dragParent: root

            onRemove: function (index: int) {
                root.model.removeItem(index);
            }
            onMove: function (from: int, to: int) {
                root.model.moveItem(from, to);
            }
            onSetExpanded: function (index: int, expanded: bool) {
                root.model.setExpanded(index, expanded);
            }
        }
    }

    y: -root.implicitHeight
    states: [
        State {
            name: "opened"
            PropertyChanges {
                root {
                    y: 0
                }
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                root {
                    y: -root.implicitHeight
                }
            }
        }
    ]
    enter: Transition {
        DefaultAnimation {
            target: root
        }
    }
    exit: Transition {
        DefaultAnimation {
            target: root
        }
    }

    component DefaultAnimation: NumberAnimation {
        property: "y"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}

// Rectangle {
//     id: root
//     // property real verticalPadding: 16
//     property real verticalPadding: 16
//     property real contentPadding: 8
//     color: MaterialTheme.colorScheme.surface
//     implicitHeight: stack.implicitHeight + (verticalPadding * 2)
//     readonly property real compactMargins: 16 * 2
//     implicitWidth: (buttonMaxWidth * 2) + compactMargins + spacing + (contentPadding * 2)
//
//     radius: 20
//
//     property bool editMode: false
//
//     onEditModeChanged: {
//         if (!editMode) {
//             root.model.saveState();
//         }
//     }
//
//     readonly property QuickSettingsModel model: QuickSettingsModel {}
//
//     readonly property real buttonMaxWidth: 180
//     readonly property real spacing: 6
//     readonly property real buttonMinWidth: (buttonMaxWidth / 2) - (spacing / 2)
//     readonly property real buttonHeight: ButtonDefaults.mediumHeight
//     readonly property real expandedHeight: (buttonHeight * 6) + (spacing * 5)
//
//     C.StackView {
//         id: stack
//         initialItem: mainView
//         implicitHeight: currentItem.implicitHeight
//         implicitWidth: root.implicitWidth
//
//         anchors {
//             left: parent.left
//             right: parent.right
//             leftMargin: root.compactMargins / 2
//             rightMargin: root.compactMargins / 2
//         }
//     }
//

//
//     Component {
//         id: mainView
//         ColumnLayout {
//             id: column
//             // spacing: root.spacing
//             spacing: 0
//             width: parent.width
//
//             VerticalSpacer {
//                 space: root.spacing
//             }
//             Header {}
//             VerticalSpacer {
//                 space: root.spacing
//                 visible: root.editMode
//             }
//             Loader {
//                 sourceComponent: root.editMode ? buttonEditView : buttonSwipeView
//
//                 Layout.alignment: Qt.AlignHCenter
//                 Layout.fillWidth: true
//
//                 Component {
//                     id: buttonSwipeView
//                     QuickButtonSwipeView {
//                         id: view
//                         anchors.fill: parent
//                         maxColumns: 3
//                         model: root.model.itemsModel
//                         buttonHeight: root.buttonHeight
//                         buttonMaxWidth: root.buttonMaxWidth
//                         buttonMinWidth: root.buttonMinWidth
//                         spaceBetween: root.spacing
//                         contentPadding: root.contentPadding
//                         onSetChecked: function (index: int, toggled: bool) {
//                             root.model.setToggled(index, toggled);
//                         }
//                     }
//                 }
//             }
//             VerticalSpacer {
//                 space: root.spacing
//             }
//             VolumeSlider {}
//             VerticalSpacer {
//                 space: root.spacing
//             }
//             BrightnessSlider {}
//         }
//     }
//
//     component MSlider: Slider {
//         Layout.rightMargin: root.contentPadding
//         Layout.leftMargin: root.contentPadding
//         Layout.fillWidth: true
//         trackHeight: SliderDefaults.mediumTrackHeight
//         stopIndicatorItem: null
//     }
//
//     component VolumeSlider: MSlider {
//         icon.name: "volume_up"
//         toolTip: `${Math.floor(value * 100)}%`
//         value: root.model.volume
//         onMoved: {
//             root.model.setVolume(value);
//         }
//     }
//
//     component BrightnessSlider: MSlider {
//         icon.name: "brightness_7"
//     }
//
//     component Header: RowLayout {
//         id: header
//         height: 52
//         Layout.fillWidth: true
//         spacing: root.spacing
//         // radius: 16
//         // elevation: 2
//         // color: MaterialTheme.colorScheme.surfaceContainer
//
//         Item {
//             Layout.fillWidth: true
//         }
//         IconButton {
//             icon.name: "edit"
//             onClicked: {
//                 root.editMode = !root.editMode;
//             }
//         }
//         IconButton {
//             icon.name: "settings"
//             onClicked: {}
//         }
//     }
//
//     property bool __closing: false
//
//     signal exited
//
//     function close() {
//         _animation.to = -root.implicitHeight;
//         _animation.from = 0;
//         __closing = true;
//         _animation.start();
//         root.model.saveState();
//     }
//
//     NumberAnimation {
//         id: _animation
//         target: root
//         running: true
//         property: "y"
//         easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
//         easing.type: Easing.BezierSpline
//         duration: MotionSpecs.expressiveDefaultSpatialDuration
//         from: -root.implicitHeight
//         to: 0
//         onFinished: {
//             if (root.__closing) {
//                 root.__closing = false;
//                 root.exited();
//             }
//         }
//     }
// }
