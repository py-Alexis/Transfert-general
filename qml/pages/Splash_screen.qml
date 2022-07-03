import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import "../"


Window {
    // COLOR PROPERTY
    property color colorBackground: "#242629"
    property color colorBackgroundDark: "#16161a"

    property color colorHeadline: "#fffffe"
    property color colorParagraph: "#94a1b2"

    property color colorHighlight: "#7f5af0"
    property color colorSecondary: "#72757e"
    property color colorTertiary: "#2cb67d"

    property color colorStroke: "#010101"


    id: window
    width: 750
    height: 400
    visible: true
    color: colorBackground
//     remove the default window frame
    flags: Qt.FramelessWindowHint


    QtObject{
        id: internal

    }

    Image{
        id: image
        source: "../../images/splash_illustration.png"

        anchors.top: parent.top
        anchors.left: parent.left

        width: parent.width + 70
        height: width * 400/750

        ColorOverlay{
            id: colorOverlay
            source: image
            color: colorBackgroundDark
            anchors.fill: parent
        }
        ColorOverlay{
            id: colorOverlay2
            source: image
            color: colorBackgroundDark
            anchors.fill: parent
        }
        ColorOverlay{
            id: colorOverlay3
            source: image
            color: colorBackgroundDark
            anchors.fill: parent
        }
        ColorOverlay{
            id: colorOverlay4
            source: image
            color: colorBackgroundDark
            anchors.fill: parent
        }

    }

    Label{
        id: title

        text: "Transfert General"
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenterOffset: -33
        anchors.horizontalCenter: parent.horizontalCenter
        color: colorHeadline

        font.pointSize: 25
        font.bold: true

    }
    Label{
        id: subtitle
        color: colorParagraph

        text: "Sauvegarde de vos données"
        anchors.top: title.bottom
        font.pointSize: 13
        anchors.topMargin: 3
        anchors.horizontalCenter: parent.horizontalCenter
    }


    ProgressBar {
        id: progressBar

        value: 0
        to: 100

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 60
        anchors.leftMargin: 30
        anchors.rightMargin: 30

        background: Rectangle {
            color: colorBackgroundDark
            radius: 4
         }

        contentItem: Item {

            implicitWidth: 200
            implicitHeight: 6

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                radius: 2
                color: colorHighlight
            }
        }

        PropertyAnimation{
            id: animation_progressBar
            duration: 500
            from: 60
            to: 400
            target: progressBar
            property: "value"
            easing.type: Easing.InOutQuint
        }

        PropertyAnimation{
            id: animation_finsish
            duration: 2000
            from: 60
            to: window.height
            target: progressBar
            property: "anchors.bottomMargin"
            easing.type: Easing.InOutQuint
            onFinished: {
                window.close()
                main.show_main_window()
            }

        }
        PropertyAnimation{
            id: animation_finsish_left
            duration: 500
            to: 0
            target: progressBar
            property: "anchors.leftMargin"
            easing.type: Easing.InOutQuint
        }
        PropertyAnimation{
            id: animation_finsish_right
            duration: 500
            to: 0
            target: progressBar
            property: "anchors.rightMargin"
            easing.type: Easing.InOutQuint
        }
    }


    Rectangle{
        id: rectangleUnderProgressBar
        anchors.left: progressBar.left
        anchors.bottom: parent.bottom
        anchors.right: progressBar.right
        anchors.top: progressBar.bottom

        color: colorBackground
    }

    Item {
        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: {
                var numberOfDots = (progressLabel.text.match(/\./g) || []).length
                // count the number of dots in the text
                if (numberOfDots < 3) {
                    // if there is only one or two dots add one
                    progressLabel.text = progressLabel.text + "."
                }
                else {
                    // else remove two dots at the end
                    progressLabel.text = progressLabel.text.substring(0, progressLabel.text.length - 3)

                }

            }
        }
    }
    Label{
        id: progressLabel

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 30
        anchors.bottomMargin: 53 - height

        text: "Loading."
        color: colorParagraph
    }

    Label {
        id: copyright

        text: "Copyright © 2022 Alexis MORICE\nAll rights reserved"
        horizontalAlignment: Text.AlignRight
        color: colorParagraph

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 30
        anchors.bottomMargin: 53 - height
        opacity: 0.3

        PropertyAnimation{
            id: animation_copyright
            duration: 1000
            from: 0.3
            to: 0
            target: copyright
            property: "opacity"
            easing.type: Easing.InOutQuint

        }
    }

    Connections{
        target: backend



        function onSend_text_signal(text){
            progressLabel.text = text
        }

        function onSend_percent_signal(percent){
            animation_progressBar.from = progressBar.value
            animation_progressBar.to = percent
            animation_progressBar.duration = 1000
            animation_progressBar.running = true
        }

        function onSend_finished_signal(){
            animation_progressBar.running = false
            progressBar.value = 100
            animation_finsish.running = true
            animation_copyright.running = true
            progressLabel.visible = false
            animation_finsish_left.running = true
            animation_finsish_right.running = true
        }

        function onSend_theme_info_signal(info_theme){

            colorBackground = info_theme["Background"]
            colorBackgroundDark = info_theme["BackgroundDark"]
            colorHeadline = info_theme["Headline"]
            colorParagraph = info_theme["Paragraph"]
            colorHighlight = info_theme["Highlight"]
            colorSecondary = info_theme["Secondary"]
            colorTertiary = info_theme["Tertiary"]
            colorStroke = info_theme["Stroke"]
        }

    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
