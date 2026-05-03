import qs.Features.Bar.QuickSettings.Components
import qs.Services

QuickSettingSlider {
    icon.name: {
        {
            if (value == 0.0) {
                return "volume_off";
            } else if (value < 0.2) {
                return "volume_down";
            } else {
                return "volume_up";
            }
        }
    }
    value: AudioService.volume
    onMoved: {
        AudioService.setVolume(value);
    }
}
