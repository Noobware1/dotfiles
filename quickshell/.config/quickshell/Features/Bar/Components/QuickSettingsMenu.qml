pragma ComponentBehavior: Bound

import QtQuick
import Qt.labs.qmlmodels
import QtQuick.Layouts
import QtQuick.Controls as C
import Material3
import qs.Features.Bar.Models
import qs.Shared.Components
import qs.Features.Bar.Components.QuickItems

Rectangle {
    id: menu
    property real horizontalPadding: 16
    property real verticalPadding: 16
    color: MaterialTheme.colorScheme.surface
    implicitHeight: column.implicitHeight + (verticalPadding * 2)
    implicitWidth: (maxPileWidth * 2) + spacing + (horizontalPadding * 2)

    radius: 20

    property bool editMode: false

    onEditModeChanged: {
        if (!editMode) {
            menu.model.saveState();
        }
    }

    readonly property QuickSettingsModel model: QuickSettingsModel {}

    readonly property real maxPileWidth: 200
    readonly property real spacing: 6
    readonly property real minPileWidth: (maxPileWidth / 2) - (spacing / 2)
    readonly property real pileHeight: ButtonDefaults.mediumHeight
    readonly property real expandedHeight: (pileHeight * 6) + (spacing * 5)

    ColumnLayout {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: menu.verticalPadding / 2
        width: menu.width
        VerticalSpacer {
            space: column.spacing
        }
        Header {}

        Loader {
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: menu.editMode ? editableQuickButtonsView : quickButtonsView
        }
        Slider {
            id: volumeSlider
            Layout.rightMargin: menu.horizontalPadding
            Layout.leftMargin: menu.horizontalPadding

            Layout.fillWidth: true
            trackHeight: SliderDefaults.mediumTrackHeight
            stopIndicatorItem: null
            icon.name: "volume_up"
        }

        Slider {
            id: brightnessSlider
            Layout.rightMargin: menu.horizontalPadding
            Layout.leftMargin: menu.horizontalPadding

            Layout.fillWidth: true
            trackHeight: SliderDefaults.mediumTrackHeight
            stopIndicatorItem: null
            icon.name: "brightness_7"
        }
    }

    component Header: Surface {
        id: header
        implicitHeight: 52
        Layout.fillWidth: true
        Layout.rightMargin: menu.horizontalPadding
        Layout.leftMargin: menu.horizontalPadding

        radius: 16
        elevation: 2
        color: MaterialTheme.colorScheme.surfaceContainer

        RowLayout {
            anchors.fill: parent
            Item {
                Layout.fillWidth: true
            }
            Button {
                variant: ButtonVariant.Outlined
                icon.name: "edit"
                onClicked: {
                    menu.editMode = !menu.editMode;
                }
            }
        }
    }

    property bool __closing: false

    signal closed

    function close() {
        _animation.to = menu.implicitWidth;
        _animation.from = 0;
        __closing = true;
        _animation.start();
        menu.model.saveState();
    }

    NumberAnimation {
        id: _animation
        target: menu
        running: true
        property: "x"
        easing.bezierCurve: MotionSpecs.expressiveDefaultSpatialBezier
        easing.type: Easing.BezierSpline
        duration: MotionSpecs.expressiveDefaultSpatialDuration
        from: menu.implicitWidth
        to: 0
        onFinished: {
            if (menu.__closing) {
                menu.__closing = false;
                menu.closed();
            }
        }
    }

    Component {
        id: editableQuickButtonsView
        EditableQuickButtonsView {
            Layout.alignment: Qt.AlignHCenter
            verticalPadding: menu.verticalPadding
            horizontalPadding: menu.horizontalPadding
            model: menu.model.itemsModel
            buttonHeight: menu.pileHeight
            buttonMaxWidth: menu.maxPileWidth
            buttonMinWidth: menu.minPileWidth
            spaceBetween: menu.spacing
            implicitHeight: buttonHeight * 6 + (spaceBetween * 5) + verticalPadding
            implicitWidth: menu.width - horizontalPadding

            onRemove: function (index: int) {
                menu.model.removeItem(index);
            }
            onMove: function (from: int, to: int) {
                menu.model.moveItem(from, to);
            }

            onSetExpanded: function (index: int, expanded: bool) {
                menu.model.setExpanded(index, expanded);
            }
            onSetToggled: function (index: int, toggled: bool) {
                menu.model.setToggled(index, toggled);
            }
        }
    }

    Component {
        id: quickButtonsView
        Column {
            spacing: menu.spacing

            QuickButtonsView {
                id: view
                anchors.horizontalCenter: parent.horizontalCenter
                maxColumns: 3
                model: menu.model.itemsModel
                buttonHeight: menu.pileHeight
                buttonMaxWidth: menu.maxPileWidth
                buttonMinWidth: menu.minPileWidth
                spaceBetween: menu.spacing

                implicitHeight: {
                    const maxHeight = buttonHeight * maxColumns + (spaceBetween * 2);
                    if (count <= 1) {
                        return contentHeight;
                    } else {
                        return maxHeight;
                    }
                }
                implicitWidth: menu.width - (menu.horizontalPadding * 2)
            }
            C.PageIndicator {
                anchors.horizontalCenter: parent.horizontalCenter
                currentIndex: view.currentIndex
                count: view.count
            }
        }
    }
}
