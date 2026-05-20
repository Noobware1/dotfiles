pragma ComponentBehavior: Bound

import QtQuick
import qs.Shared.Components
import qs.Features.Bar.QuickSettings.Models

ViewModel {
    id: model

    readonly property QuickSettingsItemModel itemsModel: QuickSettingsItemModel {}

    property bool editMode

    function toggleEditMode(): void {
        itemsModel.write();
        editMode = !editMode;
    }
}
