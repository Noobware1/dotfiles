pragma Singleton

import QtQuick
import Quickshell
import Material3

Singleton {
    id: root

    enum Size {
        Small,
        Medium,
        Large
    }

    readonly property int size: 0

    readonly property real height: {
        switch (size) {
        case BarConfig.Size.Large:
            return 60;
        case BarConfig.Size.Medium:
            return 40;
        case BarConfig.Size.Small:
        default:
            return 30;
        }
    }

    readonly property font font: {
        switch (size) {
        case BarConfig.Size.Large:
            return MaterialTheme.typography.labelLarge;
        case BarConfig.Size.Medium:
            return MaterialTheme.typography.labelMedium;
        case BarConfig.Size.Small:
        default:
            return MaterialTheme.typography.labelSmall;
        }
    }

    readonly property real iconSize: {
        switch (size) {
        case BarConfig.Size.Large:
            return 34;
        case BarConfig.Size.Medium:
            return 24;
        case BarConfig.Size.Small:
        default:
            return 20;
        }
    }
}
