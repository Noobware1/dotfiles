pragma Singleton

import Quickshell

Singleton {
    id: root

    final readonly property string __home: Quickshell.env("HOME")

    final readonly property string data: `${Quickshell.env("XDG_DATA_HOME") || `${__home}/.local/share`}/materialshell`
    final readonly property string state: `${Quickshell.env("XDG_STATE_HOME") || `${__home}/.local/state`}/materialshell`
    final readonly property string __cache: `${Quickshell.env("XDG_CACHE_HOME") || `${__home}/.cache`}/materialshell`
    final readonly property string __config: `${Quickshell.env("XDG_CONFIG_HOME") || `${__home}/.config`}`

    final readonly property string colorSchemeFile: `${state}/colorscheme.json`

    final readonly property string shellDir: Quickshell.shellDir
}
