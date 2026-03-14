import QtQuick

Loader {
    id: loader

    property bool editMode: false
    property bool selected: false
    property bool expanded: false
    required property real containerHeight
    required property real maximumWidth
    required property real minimumWidth
    required property Item dragParent
    required property int index

    height: containerHeight
    width: expanded ? maximumWidth : minimumWidth

    signal remove
    signal drag(x: real, y: real)

    onLoaded: {
        const item = this.item as QuickButton;
        item.editMode = Qt.binding(() => loader.editMode);
        item.selected = Qt.binding(() => loader.selected);
        item.containerHeight = Qt.binding(() => loader.containerHeight);
        item.implicitHeight = Qt.binding(() => loader.containerHeight);
        item.maximumWidth = Qt.binding(() => loader.maximumWidth);
        item.minimumWidth = Qt.binding(() => loader.minimumWidth);
        item.expanded = Qt.binding(() => loader.expanded);
        item.index = Qt.binding(() => loader.index);
        item.dragParent = Qt.binding(() => loader.dragParent);
        loader.height = Qt.binding(() => loader.item?.height ?? 0);
        loader.width = Qt.binding(() => loader.item?.width ?? 0);
    }

    // Binding {
    //     when: loader.status == Loader.Ready
    //     loader {
    //         item.editMode: loader.editMode
    //         item.selected: loader.selected
    //         item.containerHeight: loader.containerHeight
    //         item.implicitHeight: loader.containerHeight
    //         item.maximumWidth: loader.maximumWidth
    //         item.minimumWidth: loader.minimumWidth
    //         item.expanded: loader.expanded
    //     }
    // }

    Connections {
        target: loader.item
        function onRemove(): void {
            loader.remove();
        }
        function onExpandedChanged(): void {
            loader.expanded = loader.item?.expanded ?? false;
        }
        function onDrag(x: real, y: real): void {
            loader.drag(x, y);
        }
    }
}
