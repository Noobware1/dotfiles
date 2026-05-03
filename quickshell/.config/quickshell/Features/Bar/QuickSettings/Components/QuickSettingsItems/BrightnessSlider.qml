import qs.Features.Bar.QuickSettings.Components
import qs.Services

QuickSettingSlider {
    icon.name: {
        const EPSILON = 0.01;

        if (value > 0.5) {
            return "brightness_7";
        } else if (value > EPSILON) {
            return "brightness_6";
        } else {
            return "brightness_empty";
        }
    }
    value: BrightnessService.brightness
    onMoved: {
        BrightnessService.setBrightness(value);
    }
}
