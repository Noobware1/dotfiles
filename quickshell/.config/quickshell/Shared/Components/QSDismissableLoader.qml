pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import Material3
import qs.Shared.Components
import qs.Core

LazyLoader {
    id: loader

    default property list<QtObject> data

    required property Component contentItem

    property bool autoHide: true
    property int duration: timer.interval

    readonly property list<QtObject> __internals: [
        Timer {
            id: timer
            interval: MotionSpecs.durationExtraLong4
            function maybeRestart(): void {
                if (loader.autoHide) {
                    timer.restart();
                }
            }
            onTriggered: function () {
                if (loader.autoHide) {
                    loader.hide();
                }
            }
        }
    ]

    function show() {
        if (loader.active) {
            (loader.item as Dismissable).open();
            timer.maybeRestart();
        }
        loader.loading = true;
    }

    function hide() {
        (loader.item as Dismissable).close();
    }
}
