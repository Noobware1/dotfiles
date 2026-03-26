import qs.Features.Bar.Components

QuickButton {
    icon.name: "wifi"
    text: "PlaceHolder"
    onToggled: {
        console.log(checked);
    }
}
