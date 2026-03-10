import Quickshell
import QtQuick
import qs.Features.Bar
import qs.Services

ShellRoot {
    id: root

    FontLoader {
        id: materialIcons
        source: ":/icons/MaterialSymbolsRounded.ttf"
    }

    Bar {}

    Component.onCompleted: {
        ThemeService.init();
    }
}
