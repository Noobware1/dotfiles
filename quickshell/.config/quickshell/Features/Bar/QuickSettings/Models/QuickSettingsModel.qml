pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.Shared.Components
import qs.Features.Bar.QuickSettings.Models

ViewModel {
    id: model

    readonly property QuickSettingsItemModel itemsModel: QuickSettingsItemModel {}

    property bool editMode

    function toggleEditMode(): void {
        itemsModel.write();
        editMode = !editMode;
    }

    property string userName: "Unknown"

    readonly property alias uptime: uptimeUpdater.value

    Process {
        id: proc
        running: true
        command: ["sh", "-c", "whoami"]
        stdout: StdioCollector {
            onStreamFinished: {
                let str = text;
                str = str.replace(/[\r\n]+$/, "");
                model.userName = str.charAt(0).toUpperCase() + str.slice(1);
                proc.destroy();
            }
        }
    }

    Timer {
        id: uptimeUpdater
        property string value: "0h, 0m"
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            fileUptime.reload();
            const textUptime = fileUptime.text();
            const uptimeSeconds = Number(textUptime.split(" ")[0] ?? 0);

            // Convert seconds to days, hours, and minutes
            const days = Math.floor(uptimeSeconds / 86400);
            const hours = Math.floor((uptimeSeconds % 86400) / 3600);
            const minutes = Math.floor((uptimeSeconds % 3600) / 60);

            // Build the formatted uptime string
            let formatted = "";
            if (days > 0)
                formatted += `${days}d`;
            if (hours > 0)
                formatted += `${formatted ? ", " : ""}${hours}h`;
            if (minutes > 0 || !formatted)
                formatted += `${formatted ? ", " : ""}${minutes}m`;
            value = formatted;
            interval = 3000;
        }
    }

    FileView {
        id: fileUptime
        path: "/proc/uptime"
    }
}
