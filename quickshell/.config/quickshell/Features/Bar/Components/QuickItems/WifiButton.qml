import qs.Features.Bar.Components

SplitToggleButton {
    icon.name: "wifi"
    text: "PlaceHolder"
    onToggled: {
        console.log(checked);
    }
}
