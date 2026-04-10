pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property PwNode sink: Pipewire.defaultAudioSink
    property PwNode source: Pipewire.defaultAudioSource

    readonly property PwObjectTracker tracker: PwObjectTracker {
        objects: [root.sink, root.source]
    }

    property real volume: sink?.audio.volume ?? 0

    function setVolume(value: real): void {
        root.sink.audio.volume = value;
    }
}
