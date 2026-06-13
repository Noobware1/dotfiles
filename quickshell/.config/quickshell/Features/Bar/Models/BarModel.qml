import QtQuick
import qs.Core
import qs.Features.Bar

QtObject {
    id: model

    property int direction: BarDirection.Top
    property bool roundedCorners: true
    property int size: BarSize.Small

    property bool ready

    function __readPrefs() {
        const prefs = Preferences.getObject("bar_prefs", {
            direction: model.direction,
            roundedCorners: model.roundedCorners,
            size: model.size
        });

        model.direction = prefs.direction;
        model.roundedCorners = prefs.roundedCorners;
        model.size = prefs.size;
        model.ready = true;
    }

    function __writePrefs() {
        const direction = model.direction;
        const roundedCorners = model.roundedCorners;
        const size = model.size;

        // Preferences.setObject("bar_prefs", {
        //     direction: model.direction,
        //     roundedCorners: model.roundedCorners,
        //     size: model.size
        // });
    }

    Component.onCompleted: {
        __readPrefs();
    }

    Component.onDestruction: {
        __writePrefs();
    }
}
