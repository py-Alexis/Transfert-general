import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import "controls"
import "controls/button"
import "pages"

Window {
    // COLOR PROPERTY
    property color colorBackground: "#242629"
    ColorAnimation on colorBackground {id: colorBackgroundAnimation; to: colorBackground; duration: 1000 ; running: false}
    property color colorBackgroundDark: "#16161a"
    ColorAnimation on colorBackgroundDark {id: colorBackgroundDarkAnimation; to: colorBackgroundDark; duration: 1000 ; running: false}

    property color colorHeadline: "#fffffe"
    ColorAnimation on colorHeadline {id: colorHeadlineAnimation; to: colorHeadline; duration: 1000 ; running: false}
    property color colorParagraph: "#94a1b2"
    ColorAnimation on colorParagraph {id: colorParagraphAnimation; to: colorParagraph; duration: 1000 ; running: false}

    property color colorHighlight: "#7f5af0"
    ColorAnimation on colorHighlight {id: colorHighlightAnimation; to: colorHighlight; duration: 1000 ; running: false}
    property color colorSecondary: "#72757e"
    ColorAnimation on colorSecondary {id: colorSecondaryAnimation; to: colorSecondary; duration: 1000 ; running: false}
    property color colorTertiary: "#2cb67d"
    ColorAnimation on colorTertiary {id: colorTertiaryAnimation; to: colorTertiary; duration: 1000 ; running: false}

    property color colorStroke: "#010101"
    ColorAnimation on colorStroke {id: colorStrokeAnimation; to: colorStroke; duration: 1000 ; running: false; onFinished: tab_button_clickable = true}
    // --------------------------------------------

    id: mainWindow
    width: 1000
    height: 580
    visible: false
    color: colorBackground
    title: qsTr("Transfert général")


    Rectangle {
        id: appContainer
        color: colorBackground
        anchors.left: parent.left
        anchors.right: settingsLeftPanel.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 30
    }

    UI_iconButton{
        id: settings_button
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 11
        anchors.rightMargin: 5

        iconColor: colorParagraph
        iconPath: "../../../images/svg_images/settings.svg"
        buttonSize: 35
        backgroundVisible: false
        z:2

        onClicked: {
            animationSettingsPannel.running = true;
            animationSettingsButton.running = true
            if(settings_button.iconColor == colorParagraph){
                settings_button.iconColor = colorHighlight
            }else{
                settings_button.iconColor = colorParagraph
            }
        }

        PropertyAnimation{
            id: animationSettingsButton
            target: settings_button
            property: "anchors.rightMargin"
            to: if(settings_button.anchors.rightMargin === 5) return 200; else return 5
            duration: 1000
            easing.type: Easing.InOutQuint
        }
    }

    Rectangle {
        id: settingsLeftPanel
        width: 0
        color: colorBackgroundDark
        radius: 20
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bottomBar.top
        anchors.bottomMargin: 30
        anchors.rightMargin: -20
        anchors.topMargin: 5
        z:1

        PropertyAnimation{
            id: animationSettingsPannel
            target: settingsLeftPanel
            property: "width"
            to: if(settingsLeftPanel.width === 0) return 260; else return 0
            duration: 1000
            easing.type: Easing.InOutQuint
        }

    }
    DropShadow{
        id: dropShadow
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        anchors.fill: settingsLeftPanel
        samples: 16
        color: "#80000000"
        source: settingsLeftPanel
        visible: true
    }

    Rectangle {
        id: bottomBar
        width: 200
        height: 30
        color: colorBackgroundDark
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: appContainer.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        Button{
            id: githubBtn
            anchors.left: parent.left
            anchors.top: parent.top
            antialiasing: true
            anchors.topMargin: (25 - height)/2
            anchors.leftMargin: 10
            height: 11
            width: (512 * height) / 139
            opacity: if(hovered){0.7}else{1}

            onClicked: backend.open_github()

            background: Rectangle{
                color: "transparent"
                anchors.fill: parent

                Image{
                    id: gitHubLogo

                    anchors.fill: parent
                    source: "../images/svg_images/github.svg"
                    visible: true
                }

                ColorOverlay{
                    anchors.fill: parent
                    source: gitHubLogo
                    color: colorParagraph
                }
            }
        }
        Label {
            id: bottomRightInfo1
            color: colorParagraph
            text: qsTr("| v0.0.1 | 03/07")
            anchors.left: parent.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            antialiasing: true
            anchors.rightMargin: 5
            anchors.leftMargin: 100
            anchors.bottomMargin: 0
            anchors.topMargin: 0
        }
    }


    Connections{
        target: main

        function onSend_show_window_signal(){
            mainWindow.visible = true
        }
    }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}D{i:1}
}
##^##*/
