import Material3

Page {
    property var __stackView: StackView.view
    implicitHeight: __stackView?.implicitHeight ?? 0
    implicitWidth: __stackView?.implicitWidth ?? 0
    radius: __stackView?.radius ?? 0
    backgroundColor: __stackView?.backgroundColor ?? "transparent"
}
