pragma ComponentBehavior: Bound

import QtQuick
import Material3
import qs.Shared.Components

Surface {
    id: root

    required property Item contentItem

    property bool explicit: false
    property alias delay: delayOpen.interval
    property Transition enter: Transition {}
    property Transition exit: Transition {}

    property bool clipMask: false

    implicitContentHeight: contentItem.implicitHeight
    implicitContentWidth: contentItem.implicitWidth

    color: MaterialTheme.colorScheme.surface
    radius: height / 2
    elevation: 0

    signal opened
    signal closed
    signal aboutToShow
    signal aboutToHide

    readonly property string __openStateName: "open"
    readonly property string __closeStateName: "close"

    property alias openState: __openState
    property alias closeState: __closeState

    states: [
        State {
            id: __openState

            name: root.__openStateName
        },
        State {
            id: __closeState
            name: root.__closeStateName
        }
    ]

    transitions: [enter, exit]

    Timer {
        id: delayOpen
        interval: 100

        onTriggered: function (): void {
            root.open();
        }
    }

    // ===== Bindings =====
    Binding {
        root {
            enter.to: root.__openStateName
            exit.to: root.__closeStateName
        }
    }

    Binding {
        target: root.contentItem
        property: "parent"
        value: root
    }

    // ===== Functions =====
    function open(): void {
        root.state = root.__openStateName;
        aboutToShow();
    }

    function close(): void {
        if (root.state == root.__closeStateName && root.exit.running) {
            return;
        }
        root.state = root.__closeStateName;
        root.clip = true;
        aboutToHide();
    }

    // ===== Connections =====
    Connections {
        target: root.enter
        function onRunningChanged() {
            if (root.state == root.__openStateName && !root.enter.running) {
                root.opened();
            }
        }
    }

    Connections {
        target: root.exit
        function onRunningChanged() {
            if (root.state == root.__closeStateName && !root.exit.running) {
                root.closed();
            }
        }
    }

    Connections {
        target: root

        function onContentItemChanged(): void {
            if (root.explicit)
                return;

            if (root.contentItem instanceof Loader)
                return;

            delayOpen.restart();
        }

        Component.onCompleted: onContentItemChanged()
    }

    Connections {
        target: root.contentItem
        enabled: target instanceof Loader
        ignoreUnknownSignals: true

        function onStatusChanged() {
            if (root.explicit)
                return;

            if ((target as Loader).status === Loader.Ready) {
                delayOpen.restart();
            }
        }

        Component.onCompleted: {
            if (enabled) {
                onStatusChanged();
            }
        }
    }
}
