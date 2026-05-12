import QtQuick
import Material3
import qs.Shared.Components

QtObject {
    id: root
    required property Item visualParent
    property Component __dialog
    readonly property alias anchors: root.__loader.anchors
    property alias x: root.__loader.x
    property alias y: root.__loader.y
    property alias height: root.__loader.height
    property alias width: root.__loader.width
    readonly property alias parent: root.__loader.parent

    readonly property Component overlay: QsOverlay {}

    readonly property Loader __loader: Loader {
        parent: root.visualParent
        onLoaded: {
            if (item instanceof Dialog) {
                const dialog = (item as Dialog);
                dialog.overlay = root.overlay;
                dialog.open();
            }
        }
        sourceComponent: root.__dialog
    }

    function openDialog(dialog: Component): void {
        __loader.active = false;
        __dialog = dialog;
        __loader.active = true;
    }

    function forceCloseDialog(): void {
        if (__loader.item) {
            __loader.item.visible = false;
        }
        __loader.active = false;
    }
}
