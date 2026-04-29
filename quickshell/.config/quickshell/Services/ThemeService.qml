pragma Singleton

import Quickshell
import Material3
import Quickshell.Io
import QtQuick
import qs.Core

Singleton {
    id: service

    enum ThemeMode {
        Dark,
        Light,
        System
    }

    final property colorscheme __dark: M3.colorScheme(true)
    final property colorscheme __light: M3.colorScheme(false)
    final property int mode: ThemeService.ThemeMode.Dark

    function __setColorScheme() {
        switch (service.mode) {
        case ThemeService.ThemeMode.Dark:
            MaterialTheme.colorScheme = Qt.binding(() => service.__dark);
            break;
        case ThemeService.ThemeMode.System:
            MaterialTheme.colorScheme = Qt.binding(() => MaterialTheme.isSystemDarkTheme ? service.__dark : service.__light);
            break;
        case ThemeService.ThemeMode.Light:
        default:
            MaterialTheme.colorScheme = Qt.binding(() => service.__light);
            break;
        }
    }

    Connections {
        target: service
        function onModeChanged(): void {
            service.__setColorScheme();
        }
    }

    FileView {
        id: fileWatcher
        path: Paths.colorSchemeFile
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            const json = JSON.parse(text());
            for (const [type, colorScheme] of Object.entries(json)) {
                if (type !== "dark" && type !== "light") {
                    // todo log
                    console.error(`ThemeService: unable to load colorScheme, Invaild json schema ${type}.`);
                    return;
                }

                // service[`__${type}`] = M3.colorScheme(colorScheme);
            }
        }
    }

    function init(): void {
        __setColorScheme();
    }
}
