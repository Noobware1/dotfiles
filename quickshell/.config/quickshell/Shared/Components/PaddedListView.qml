pragma ComponentBehavior: Bound

import QtQuick

ListView {
    id: view
    property real verticalPadding
    property real horizontalPadding
    property real topPadding: verticalPadding
    property real bottomPadding: verticalPadding
    property real rightPadding: horizontalPadding
    property real leftPadding: horizontalPadding

    property real availableWidth: width - rightPadding - leftPadding

    clip: true
    header: Item {
        implicitHeight: view.topPadding
        z: 3
    }
    footer: Item {
        implicitHeight: view.bottomPadding
        z: 3
    }
    footerPositioning: ListView.OverlayFooter
    headerPositioning: ListView.OverlayHeader
}
