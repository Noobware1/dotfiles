import QtQuick
import qs.Core
import qs.Features.Bar

QtObject {
    id: model

    property int direction: BarDirection.Top
    property bool roundedCorners: true
    property int size: BarSize.Small

    property bool ready

    function __readItemsPrefs() {
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

    Component.onCompleted: {
        __readItemsPrefs();
    }
}
