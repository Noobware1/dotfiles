import Quickshell
import QtQuick
import Material3

Button {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    variant: ButtonVariant.Text
    text: Qt.formatDateTime(clock.date, "hh:mm AP - ddd MMM yyyy")
}
