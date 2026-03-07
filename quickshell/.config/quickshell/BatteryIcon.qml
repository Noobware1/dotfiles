import QtQuick
import QtQuick.Shapes

Item {
    id: root

    /* =====================
     * Public API
     * ===================== */
    property real value: 1.0        // normalized 0..1
    property color shellColor: "#666"
    property color fillColor: value < 0.15 ? "#D32F2F" : "#4CAF50"

    implicitWidth: 24
    implicitHeight: 24

    /* =====================
     * Battery shell
     * ===================== */
    Shape {
        anchors.fill: parent
        transform: [
            Translate {
                x: 0
                y: 500
            },
            Scale {
                xScale: root.width / 960
                yScale: root.height / 960
            }
        ]
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            strokeWidth: 0
            fillColor: root.shellColor

            PathSvg {
                path: "M 160 -240 C 126.667 -240 98.3333 -251.667 75 -275 " + "C 51.6667 -298.333 40 -326.667 40 -360 L 40 -600 " + "C 40 -633.333 51.6667 -661.667 75 -685 " + "C 98.3333 -708.333 126.667 -720 160 -720 L 700 -720 " + "C 733.333 -720 761.667 -708.333 785 -685 " + "C 808.333 -661.667 820 -633.333 820 -600 L 820 -360 " + "C 820 -326.667 808.333 -298.333 785 -275 " + "C 761.667 -251.667 733.333 -240 700 -240 L 160 -240 " + "M 860 -380 L 860 -580 L 880 -580 " + "C 891.333 -580 900.833 -576.167 908.5 -568.5 " + "C 916.167 -560.833 920 -551.333 920 -540 L 920 -420 " + "C 920 -408.667 916.167 -399.167 908.5 -391.5 " + "C 900.833 -383.833 891.333 -380 880 -380 L 860 -380"
            }
        }

        /* =====================
	 * Charge fill
     	 * ===================== */
        //   ShapePath {
        //       strokeWidth: 0
        //       fillColor: root.fillColor
        //
        //       PathSvg {
        //           readonly property real clampedValue: Math.max(0, Math.min(1, root.value))
        //
        //           /* =====================
        // * Geometry (SVG space)
        // * ===================== */
        //           readonly property real innerLeft: 320
        //           readonly property real innerRight: 700
        //           readonly property real innerTop: -640
        //           readonly property real innerBottom: -320
        //           readonly property real innerWidth: innerRight - innerLeft
        //           readonly property real innerHeight: innerBottom - innerTop
        //
        //           readonly property real fillRight: innerLeft + innerWidth * clampedValue
        //           readonly property real r1: fillRight
        //           readonly property real r2: fillRight
        //           readonly property real r3: fillRight
        //           readonly property real r4: fillRight
        //           readonly property real r5: fillRight
        //           path: "M 360 -360 " + "L " + fillRight + " -320 " + "C " + r1 + " -320 " + r2 + " -323.833 " + r3 + " -331.5 " + "C " + r4 + " -339.167 " + r5 + " -348.667 " + r5 + " -360 " + "L " + r5 + " -600 " + "C " + r5 + " -611.333 " + r4 + " -620.833 " + r3 + " -628.5 " + "C " + r2 + " -636.167 " + r1 + " -640 " + fillRight + " -640 " + "L 320 -640 " + "L 320 -320"
        //       }
        //   }
    }
}
