import Quickshell
import QtQuick
import qs.Features.Bar
import qs.Services
import qs.Core

ShellRoot {
    id: root

    FontLoader {
        id: materialIcons
        source: ":/icons/MaterialSymbolsRounded.ttf"
    }

    Bar {}

    Component.onCompleted: {
        ThemeService.init();
        Preferences.load();
    }
}
