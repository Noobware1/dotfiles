pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    property bool isBluetoothSource: (sink?.name ?? "").includes("bluez")

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {}
    }

    readonly property bool ready: sink?.ready ?? false

    readonly property PwObjectTracker tracker: PwObjectTracker {
        objects: [root.sink, root.source]
    }

    property real volume: sink?.audio.volume ?? 0

    function setVolume(value: real): void {
        root.sink.audio.volume = value;
    }

    readonly property bool muted: sink?.audio.muted ?? false

    function muteToggle(): void {
        if (!sink) {
            return;
        }
        sink.audio.muted = !sink.audio.muted;
    }
}
