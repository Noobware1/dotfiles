pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

LazyLoader {
    id: loader

    function toggle() {
        if (active) {
            close();
        } else {
            open();
        }
    }
    // qmllint disable missing-property
    function close() {
        if (!active) {
            return;
        }
        item.close();
    }

    function open() {
        if (active) {
            return;
        }
        loading = true;
    }

    readonly property Connections _: Connections {
        target: loader
        function onActiveChanged(): void {
            if (loader.active) {
                loader.item.open();
                loader.item.closed.connect(function () {
                    loader.active = false;
                });
            }
        }
    }
}
