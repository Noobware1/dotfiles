pragma ComponentBehavior: Bound

import QtQuick
import Material3
import qs.Shared.Components
import qs.Core

Surface {
    id: surface

    required property Item contentItem
    property bool explicit: false
    property alias delay: delayOpen.interval

    Timer {
        id: delayOpen
        interval: 100
        onTriggered: function (): void {
            surface.open();
        }
    }

    Binding {
        target: surface.contentItem
        property: "parent"
        value: surface
    }

    Connections {
        target: surface
        function onContentItemChanged(): void {
            if (surface.explicit) {
                return;
            }

            delayOpen.restart();
        }

        Component.onCompleted: {
            onContentItemChanged();
        }
    }

    Connections {
        target: surface.contentItem
        ignoreUnknownSignals: true
        function onStatusChanged() {
            if (surface.explicit) {
                return;
            }

            if (!(target instanceof Loader)) {
                return;
            }

            if ((target as Loader).status === Loader.Ready) {
                delayOpen.restart();
            }
        }

        Component.onCompleted: {
            onStatusChanged();
        }
    }

    implicitContentHeight: contentItem.implicitHeight
    implicitContentWidth: contentItem.implicitWidth

    color: MaterialTheme.colorScheme.surfaceContainer
    radius: height / 2
    elevation: 2

    signal entered

    signal exited

    function open(): void {
        surface.state = "opened";
        entered();
    }

    function close(): void {
        surface.state = "closed";
    }

    property Transition enter: Transition {}
    property Transition exit: Transition {}
    state: ""

    Binding {
        target: surface.enter
        property: "to"
        value: "opened"
    }
    Binding {
        target: surface.exit
        property: "to"
        value: "closed"
    }

    Connections {
        target: surface.exit
        function onRunningChanged() {
            if (surface.state == "closed" && !surface.exit.running) {
                surface.exited();
            }
        }
    }

    transitions: [enter, exit]
}

// readonly property var __incubator: {
//     const incubator = contentItem.incubateObject(surface);
//     incubator.onStatusChanged = function (status) {
//         if (status == Component.Ready) {
//             const item = incubator.object;
//             surface.implicitContentHeight = Qt.binding(() => item.implicitHeight);
//             surface.implicitContentWidth = Qt.binding(() => item.implicitWidth);
//             surface.entered();
//             surface.state = "opened";
//         }
//     };
//     return incubator;
// }
// implicitContentHeight: 0
// implicitContentWidth: 0

