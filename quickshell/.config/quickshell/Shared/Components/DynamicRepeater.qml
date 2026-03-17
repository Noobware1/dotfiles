import QtQuick

QtObject {
    id: repeater

    property QtObject parent
    property Component delegate
    property var model

    property list<var> __dirtyIncubators: []
    property list<var> __incubators: []

    property bool loaded: false

    readonly property int __modelCount: repeater.model?.count ?? repeater.model

    readonly property int count: __loadedCount

    property int __loadedCount: -1

    on__LoadedCountChanged: {
        if (__loadedCount == __modelCount && __loadedCount == __incubators.length) {
            for (var i = 0; i < __incubators.length; i++) {
                const incubator = __incubators[i];
                if (incubator.parent) {
                    incubator.parent.object.parent = repeater.parent;
                } else {
                    incubator.object.parent = repeater.parent;
                }
            }
            loaded = true;
        }
    }

    property alias autoConnections: __cnts.enabled

    property Connections __connections: Connections {
        id: __cnts
        target: repeater.model
        ignoreUnknownSignals: true

        function onLoaded() {
            repeater.load();
        }

        function onRemoveItem(index: int) {
            repeater.__destroyIncubator(repeater.__incubators[index]);

            repeater.__incubators.splice(index, 1);

            __setIndicies(index, repeater.__incubators.length);
        }

        function __setIndicies(start: int, end: int, callback: var) {
            for (let i = start; i < end; i++) {
                if (i > end) {
                    break;
                }
                const incubator = __incubators[i];
                incubator.index = i;

                if (incubator.status == Component.Ready && incubator.object.hasOwnProperty("index")) {
                    incubator.object.index = i;
                    if (callback) {
                        callback(incubator);
                    }
                }
            }
        }

        function onMoveItem(from: int, to: int, count: int) {
            const moved = __incubators.splice(from, count);

            let newIndex = to;

            if (newIndex > from) {
                newIndex -= count;
            }

            __incubators.splice(newIndex, 0, ...moved);

            const start = Math.min(from, newIndex);
            const end = Math.max(from, newIndex) + count;

            __setIndicies(start, end, function (incubator) {
                const obj = incubator.parent ? incubator.parent.object : incubator.object;

                // detach and reattach to move in child list
                obj.parent = null;
                obj.parent = repeater.parent;
            });
        }
    }

    // function (int index, var modelData): Component | string
    property var createComponent: function (_, __) {}

    // function (int index, var modelData): Object
    property var createItem: function (_, __) {}

    // function (int index, QtObject object): void
    property var initItem

    // you have to manually call this function, since qml doesn't expose any signal on the models themselves
    function load() {
        if (__incubators.length > 0) {
            __incubatorsClear();
        }

        __loadedCount = 0;

        for (let i = 0; i < model.count; i++) {
            const data = model.get(i);
            if (!createItem || typeof createItem != "function") {
                console.error("createItem must be a function  callback; got %s", typeof createItem);
                __incubatorsClear();
                return;
            }

            let component = createComponent(i, data);

            if (component && typeof component == "string") {
                component = Qt.createComponent(component);
            } else if (!component || !(component instanceof Component)) {
                console.error("Expected Component or string but got: %s", typeof component);
                __incubatorsClear();
                return;
            }

            let properties = {};
            if (createItem && typeof createItem == "function") {
                properties = createItem(i, data) ?? {};
                if (typeof properties != "object") {
                    console.error("createItem must return type object or null; got %s instead", typeof properties);
                    properties = {};
                }
            }

            const incubator = component.incubateObject(null, properties);

            incubator.dirty = false;
            incubator.index = i;

            __incubators.push(incubator);

            incubator.onStatusChanged = function (status) {
                if (status == Component.Error) {
                    console.error(incubator.errorString());
                } else if (status == Component.Ready) {
                    if (incubator.dirty) {
                        incubator.object.destroy();
                        return;
                    }

                    if (initItem && typeof initItem == "function") {
                        initItem(incubator.index, incubator.object);
                        if (incubator.object.hasOwnProperty("index") && incubator.object.index != incubator.index) {
                            incubator.object.index = incubator.index;
                        }
                    }

                    if (!repeater.delegate) {
                        repeater.__loadedCount++;
                    } else {
                        const parentDelegate = repeater.delegate.incubateObject(null, {
                            child: incubator.object
                        });

                        incubator.parent = parentDelegate;
                        parentDelegate.dirty = false;

                        if (parentDelegate == Component.Ready) {
                            if (parentDelegate.dirty) {
                                parentDelegate.destroy();
                                return;
                            }
                            parentDelegate.object.child.parent = parentDelegate.object;
                            repeater.__loadedCount++;
                            return;
                        }

                        parentDelegate.onStatusChanged = function (status) {
                            if (status == Component.Error) {
                                console.error(parentDelegate.errorString());
                            } else if (status == Component.Ready) {
                                if (parentDelegate.dirty) {
                                    parentDelegate.object.child.destroy();
                                    parentDelegate.object.destroy();
                                    return;
                                }

                                parentDelegate.object.child.parent = parentDelegate.object;

                                repeater.__loadedCount++;
                            }
                        };
                    }
                }
            };
        }
    }

    function __destroyIncubator(incubator: var): void {
        if (incubator.status == Component.Ready) {
            const parentDelegate = incubator.parent;

            if (parentDelegate) {
                parentDelegate.dirty = true;
                if (parentDelegate.status == Component.Ready) {
                    parentDelegate.object.parent = null;
                    parentDelegate.object.destroy();
                }
                return;
            }

            incubator.object.parent = null;
            incubator.object.destroy();
        } else {
            incubator.dirty = true;
        }
    }

    function __incubatorsClear() {
        __dirtyIncubators = __incubators.splice(0);

        for (var i = 0; i < __dirtyIncubators.length; i++) {
            __destryIncubator(__dirtyIncubators[i]);
        }
        __dirtyIncubators.length = 0;
    }

    function itemAt(index: int): QtObject {
        const incubator = __incubators[index];
        if (incubator && incubator.parent) {
            return incubator.parent.object;
        }
        return incubator.object;
    }
}
