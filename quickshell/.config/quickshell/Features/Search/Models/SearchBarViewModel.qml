import qs.Shared.Components
import Quickshell as QS
import Quickshell.Io
import QtQuick

ViewModel {
    id: model

    property string searchQuery: ""

    readonly property QS.ScriptModel suggestionModel: QS.ScriptModel {
        values: {
            const sorted = [...QS.DesktopEntries.applications.values].sort((a, b) => a.name.localeCompare(b.name));

            const regExp = new RegExp(model.searchQuery, "i");
            return sorted.filter(e => regExp.test(e.name));
        }
    }

    IpcHandler {
        target: "search"

        function toggle() {
            model.searchToggled();
        }
    }

    signal searchToggled
}
