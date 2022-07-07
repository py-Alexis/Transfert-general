import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import "../controls"
import "../controls/button"
import "../pages"
import "../"

Rectangle {
//    property color colorBackground: "#242629"
//    property color colorBackgroundDark: "#16161a"
//
//    property color colorHeadline: "#fffffe"
//    property color colorParagraph: "#94a1b2"
//
//    property color colorHighlight: "#7f5af0"
//    property color colorSecondary: "#72757e"
//    property color colorTertiary: "#2cb67d"
//
//    property color colorStroke: "#010101"

    color: colorBackground
    id: item1
    Rectangle {
        id: rectangle
        height: 3
        color: colorParagraph
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 80
        anchors.rightMargin: 30
        anchors.leftMargin: anchors.rightMargin
    }

    Label{
        id: copy_size
        color: colorHighlight
        text: " 2 GB "
        anchors.left: parent.left
        anchors.bottom: rectangle.top
        anchors.leftMargin: 40
        anchors.bottomMargin: 5
        font.bold: true
        font.pointSize: 22

    }

    Label {
        id: to_backup
        color: colorHeadline
        text: "to backup"
        anchors.left: copy_size.right
        anchors.bottom: rectangle.top
        anchors.bottomMargin: 5
        anchors.leftMargin: 0
        font.pointSize: 22
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}D{i:2}D{i:3}
}
##^##*/
