import qs.Shared.Components
import Quickshell as QS
import Quickshell.Io
// import qs.Core
import QtQuick

ViewModel {
    id: model

    property string searchQuery: ""
    onSearchQueryChanged: {
        console.log(searchQuery);
    }

    // readonly property SortFilterProxyModel filterModel: SortFilterProxyModel {
    //     id: fruitFilter
    //     model: QS.DesktopEntries.applications
    //     sorters: [
    //         RoleSorter {
    //             roleName: "name"
    //         }
    //     ]
    //     filters: [
    //         FunctionFilter {
    //             property var regExp: new RegExp(model.searchQuery, "i")
    //             onRegExpChanged: invalidate()
    //             function filter(data: Entry): bool {
    //                 return regExp.test(data.name);
    //             }
    //         }
    //     ]
    // }

    component Entry: QtObject {
        property string name
    }

    IpcHandler {
        target: "search"

        function toggle() {
            model.searchToggled();
        }
    }

    signal searchToggled
}
