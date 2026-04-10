import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Material3
import qs.Shared.Components
import qs.Core
import qs.Services

SimpleOverlay {
    id: overlay

    Connections {
        target: AudioService
        enabled: !GlobalState.quickSettingsMenuOpen
        function onVolumeChanged(): void {
            overlay.show();
        }
    }

    contentItem: RowLayout {
        anchors.centerIn: parent
        spacing: 6
        Icon {
            size: LayoutSemenatics.iconSizeMedium
            name: "volume_up"
            color: MaterialTheme.colorScheme.onSurfaceVariant
        }
        Slider {
            implicitWidth: 150
            value: AudioService.volume
            toolTip: ""
            stopIndicatorItem: null
            onMoved: {
                AudioService.setVolume(value);
            }
        }
        Text {
            Layout.preferredWidth: 32
            text: `${Math.floor(AudioService.volume * 100)}%`
            font: MaterialTheme.typography.labelLarge
            color: MaterialTheme.colorScheme.onSurfaceVariant
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
