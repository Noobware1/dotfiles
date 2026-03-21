import QtQuick

Text {
    id: marquee

    property real maxiumWidth: implicitWidth
    property string textString
    property string animatedText: textString

    text: animatedText

    // PropertyAnimation {
    //
    // }
}
