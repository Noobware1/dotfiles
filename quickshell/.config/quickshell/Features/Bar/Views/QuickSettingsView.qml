pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as C
import Material3
import qs.Features.Bar.Models
import qs.Shared.Components
import qs.Features.Bar.Components
import qs.Services

Dismissable {
    id: root

    verticalPadding: 16
    elevation: 6

    clipMask: true

    readonly property real compactMargins: 16 * 2
    property real contentPadding: 8

    property bool editMode: false

    onEditModeChanged: {
        if (!editMode) {
            root.model.saveState();
        }
    }

    readonly property QuickSettingsModel model: QuickSettingsModel {
        parent: root
        menuRadius: root.radius
        menuWidth: root.implicitWidth
        menuHeight: 400
        initialView: mainView
    }

    readonly property real buttonMaxWidth: 180
    readonly property real spacing: 6
    readonly property real buttonMinWidth: (buttonMaxWidth / 2) - (spacing / 2)
    readonly property real buttonHeight: ButtonDefaults.mediumHeight
    readonly property real expandedHeight: (buttonHeight * 6) + (spacing * 5)

    radius: 20
    color: MaterialTheme.colorScheme.surface

    implicitHeight: implicitContentHeight + verticalPadding * 2
    implicitWidth: (root.buttonMaxWidth * 2) + root.compactMargins + root.spacing + (root.contentPadding * 2)

    contentItem: model.navigationStack

    Component {
        id: networkListView
        NetworkListView {
            Layout.preferredHeight: root.buttonHeight * 6 + root.spacing * 5
            Layout.fillWidth: true
        }
    }

    Component {
        id: mainView
        ColumnLayout {
            id: column
            spacing: 0
            width: parent.width
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: root.compactMargins / 2
                rightMargin: root.compactMargins / 2
            }

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
                        model: root.model
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
        icon.name: {
            if (value == 0.0) {
                return "volume_off";
            } else if (value < 0.2) {
                return "volume_down";
            } else {
                return "volume_up";
            }
        }
        value: AudioService.volume
        onMoved: {
            AudioService.setVolume(value);
        }
    }

    component BrightnessSlider: MSlider {
        icon.name: {
            const EPSILON = 0.01;

            if (value > 0.5) {
                return "brightness_7";
            } else if (value > EPSILON) {
                return "brightness_6";
            } else {
                return "brightness_empty";
            }
        }
        value: BrightnessService.brightness
        onMoved: {
            !BrightnessService.setBrightness(value);
        }
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
                // root.editMode = !root.editMode;
                stack.push(networkListView);
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

    visible: false
    enter: Transition {
        PropertyAction {
            target: root
            property: "y"
            value: -root.implicitHeight
        }
        PropertyAction {
            target: root
            property: "visible"
            value: true
        }
        DefaultAnimation {
            target: root
            from: -root.implicitHeight
            to: 0
        }
    }
    exit: Transition {
        DefaultAnimation {
            target: root
            from: 0
            to: -root.implicitHeight
        }
    }

    component DefaultAnimation: NumberAnimation {
        property: "y"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
    }
}
