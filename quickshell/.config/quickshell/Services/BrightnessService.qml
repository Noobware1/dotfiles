pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness
    property bool ready

    Process {
        id: getCurrAndMaxValue
        running: true
        command: ["sh", "-c", "echo \"$(brightnessctl g) $(brightnessctl m)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const [curr, max] = text.split(" ");
                const brightness = parseInt(curr) / parseInt(max);
                root.brightness = brightness;
                root.ready = true;
            }
        }
    }

    Process {
        id: _setBrightness
        // qmllint disable signal-handler-parameters
        onExited: {
            getCurrAndMaxValue.running = true;
        }
        // qmllint enable signal-handler-parameters
    }

    IpcHandler {
        target: "brightness"

        function increase(value: string): void {
            _setBrightness.exec(["brightnessctl", "-e4", "-n2", "set", `${value}+`]);
        }

        function decrease(value: string): void {
            _setBrightness.exec(["brightnessctl", "-e4", "-n2", "set", `${value}-`]);
        }

        function set(value: string): void {
            _setBrightness.exec(["brightnessctl", "-e4", "-n2", "set", value]);
        }
    }

    function setBrightness(value: real): void {
        _setBrightness.exec(["brightnessctl", "-n2", "set", `${Math.round(value * 100)}%`]);
    }
}
