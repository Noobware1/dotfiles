pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Features.Bar
import qs.Services
import qs.Core
import qs.Features.OSD
import qs.Features.Bar.Components
import qs.Features.Bar.Models
import qs.Features.Search

ShellRoot {
    id: root

    FontLoader {
        id: materialIcons
        source: ":/icons/MaterialSymbolsRounded.ttf"
    }

    Bar {
        id: bar
    }

    SearchBar {
        id: searchBar
    }

    Binding {
        target: WindowManager
        property: "searchBarWindow"
        value: searchBar
    }

    VolumeOverlay {}
    BrightnessOverlay {}

    // ExampleGrid {}

    Component.onCompleted: {
        Preferences.load();
        ThemeService.init();
        NetworkService.init();
    }

    // Example {}
}
