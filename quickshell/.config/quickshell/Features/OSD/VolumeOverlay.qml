import QtQuick
import qs.Core
import qs.Services

SliderOverlay {
    id: overlay

    Connections {
        target: AudioService
        enabled: !GlobalState.quickSettingsMenuOpen && AudioService.ready
        function onVolumeChanged(): void {
            overlay.show();
        }
    }

    icon: {
        if (AudioService.isBluetoothSource) {
            if (AudioService.muted) {
                return "media_bluetooth_off";
            }
            return "media_bluetooth_on";
        }

        if (value == 0.0) {
            return "volume_off";
        } else if (value < 0.2) {
            return "volume_down";
        } else {
            return "volume_up";
        }
    }

    onMoved: value => {
        AudioService.setVolume(value);
    }

    value: AudioService.volume
}
