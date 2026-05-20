pragma ComponentBehavior: Bound
import Material3
import QtQuick
import qs.Features.Bar.QuickSettings.Components
import qs.Features.Bar.QuickSettings
import qs.Features.Bar.QuickSettings.Models
import qs.Core

SwipeView {
    id: view
    clip: true
    orientation: Qt.Vertical

    required property QuickSettingsModel model
    readonly property QuickSettingsItemModel itemsModel: view.model.itemsModel
    readonly property QuickSettingsLayoutMetrics layoutMetrics: QuickSettingsLayoutMetrics {}
    property int columns: 4

    default property Component delegate

    ListModel {
        id: pageModel
        property bool ready

        function initalize() {
            const model = view.itemsModel;
            const M = view.layoutMetrics;
            let currentSpace = 0;
            let columnCount = 0;
            let page = 0;
            let offset = 0;
            let data = [];
            const maxWidth = M.maxLayoutWidth - M.spacing;

            for (var i = 0; i < model.count; i++) {
                const item = model.get(i);
                let width;
                if (model.isSlider(item)) {
                    width = item.expanded ? M.sliderTrackExpandedWidth : M.sliderTrackCompactWidth;
                } else {
                    width = item.expanded ? M.buttonExpandedWidth : M.buttonCompactWidth + M.spacing / 2;
                }

                if (!data[page]) {
                    data[page] = {
                        offset: offset,
                        model: []
                    };
                }

                data[page].model.push(item);

                currentSpace += width;

                if (currentSpace >= maxWidth) {
                    currentSpace = 0;
                    columnCount++;
                }

                if (columnCount == view.columns) {
                    columnCount = 0;
                    page++;
                    offset = i + 1;
                }
            }

            pageModel.clear();
            pageModel.append(data);
            pageModel.ready = true;
        }
    }

    Connections {
        target: view.itemsModel
        function onLoaded() {
            if (!view.itemsModel.ready) {
                pageModel.initalize();
            }
        }
        Component.onCompleted: {
            if (view.itemsModel.ready) {
                pageModel.initalize();
            }
        }
    }

    Repeater {
        id: repeater
        model: pageModel
        QuickSettingsItem {}
    }

    component QuickSettingsItem: Item {
        id: qsItemPage
        // height: view.currentItem.implicitHeight
        // width: view.currentItem.implicitWidth
        //        implicitHeight: layout.implicitHeight + LayoutSemenatics.pageVerticalPadding * 2
        // implicitWidth: layout.implicitWidth + LayoutSemenatics.pageHorizontalPadding * 2
        // clip: true
        readonly property real verticalPadding: LayoutSemenatics.pageVerticalPadding
        readonly property real horizontalPadding: LayoutSemenatics.pageHorizontalPadding

        implicitHeight: index > 0 ? view.contentChildren[0].implicitHeight : layout.implicitHeight + verticalPadding * 2
        implicitWidth: index > 0 ? view.contentChildren[0].implicitWidth : layout.implicitWidth + horizontalPadding * 2

        // required property var modelData
        required property int offset
        required property ListModel model
        required property int index

        QuickSettingsLayout {
            id: layout
            metrics: view.layoutMetrics
            height: Math.min(implicitHeight, metrics.maxLayoutHeight)
            ButtonGroup {
                id: buttonGroup
                layoutParent: layout
                exclusive: false
                animate: true
                buttons: layout.children.filter(e => e instanceof Button).sort((a, b) => a.index - b.index)
            }
            y: qsItemPage.verticalPadding
            x: qsItemPage.horizontalPadding
            model: qsItemPage.model
            onItemCreated: item => {
                if (view.itemsModel.isButton(item)) {
                    const button = item as QuickSettingButton;
                    button.toggled.connect(() => view.itemsModel.setChecked(button.index + qsItemPage.offset, button.checked));
                } else {
                    // const slider = item as QuickSettingSlider;
                }
            }
            delegate: view.delegate
        }
    }
}
