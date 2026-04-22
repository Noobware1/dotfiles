import QtQuick
import qs.Core
import qs.Services

SliderOverlay {
    id: overlay

    Connections {
        target: BrightnessService
        enabled: !GlobalState.quickSettingsMenuOpen && BrightnessService.ready
        function onBrightnessChanged(): void {
            overlay.show();
        }
    }

    icon: {
        const EPSILON = 0.01;

        if (value > 0.5) {
            return "brightness_7";
        } else if (value > EPSILON) {
            return "brightness_6";
        } else {
            return "brightness_empty";
        }
    }

    onMoved: value => {
        BrightnessService.setBrightness(value);
    }

    value: BrightnessService.brightness
}
