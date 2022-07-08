import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.2
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

    Rectangle {
        id: listview
        color: "#00000000"
        anchors.top: rectangle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: validate_btn.top
        anchors.bottomMargin: 30
        anchors.leftMargin: 30
        anchors.rightMargin: 30


       
    }

    UI_textButton {
        id: validate_btn
        textBtn: "Validate"
        textColor: colorHeadline
        backgroundColor: colorHighlight
        emphasis: true

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 30
        anchors.bottomMargin: 20

    }

    DropShadow{
        id: dropShadow
        horizontalOffset: 2
        verticalOffset: 2
        radius: 10
        anchors.fill: validate_btn
        samples: 16
        color: "#80000000"
        source: validate_btn
        visible: true
    }

    UI_textButton {
        id: select_all_btn
        textBtn: "Select all"
        textColor: colorHeadline
        backgroundColor: colorBackground
        emphasis: false

        anchors.right: validate_btn.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 20
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}D{i:2}D{i:3}
}
##^##*/
