pragma ComponentBehavior: Bound

import QtQuick
import qs.Features.Bar.QuickSettings

Flow {
    id: layout

    property alias model: repeater.model
    property alias delegate: repeater.delegate

    required property QuickSettingsLayoutMetrics metrics
    // also required
    // required property real spacing

    width: metrics.maxLayoutWidth
    spacing: metrics.spacing

    signal itemCreated(Item item)

    Repeater {
        id: repeater
        onItemAdded: (index, item) => {
            layout.itemCreated(item);
        }
    }
}
