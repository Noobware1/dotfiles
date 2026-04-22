import Quickshell
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar
import qs.Services
import qs.Core
import qs.Features.OSD
import qs.Features.Bar.Components
import qs.Features.Bar.Models

ShellRoot {
    id: root

    FontLoader {
        id: materialIcons
        source: ":/icons/MaterialSymbolsRounded.ttf"
    }

    Bar {}

    VolumeOverlay {}
    BrightnessOverlay {}

    Component.onCompleted: {
        Preferences.load();
        ThemeService.init();
    }

    // Example {}
}
