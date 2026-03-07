import Quickshell
import QtQuick
import qs.Features.Bar

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
