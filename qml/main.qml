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
    // When company mode is enabled, you can access the settings via the settings button and you can't change
    // any of the backup paths.
    property bool company_mode: false

    property bool tab_button_clickable: true

    property string themeName: "DefaultDark"


    id: mainWindow
    width: 1000
    height: 580
    visible: false
    color: colorBackground
    title: qsTr("Transfert général")

    QtObject{
        id: internal

        function createSettingsTarButton(ButtonName, activeTheme){
            // Creation of the TabButton String
            var style = "contentItem: Text {color: parent.checked ? colorHeadline :colorParagraph;text: parent.text;font: parent.font;horizontalAlignment: Text.AlignHCenter;verticalAlignment: Text.AlignVCenter;}background: Rectangle{radius: 6; color:colorBackground;opacity: parent.down ? 0.75: 1;gradient: Gradient {orientation : Gradient.Horizontal;GradientStop{position: 0;color: if(checked){colorHighlight}else{colorBackground}}GradientStop{position: 4;color: if(checked){colorTertiary}else{colorBackground}}}}"
            var isActive = ButtonName === activeTheme ? true: false
            var objectString = `import QtQuick 2.13; import QtQuick.Controls 2.13; TabButton {text: qsTr('${ButtonName}');z:2; checkable: tab_button_clickable;width:100; checked: ${isActive}; onClicked: main.change_theme(text); ${style}}`

            var newObject = Qt.createQmlObject(objectString,themeSelector,"tab_button"); // Creation of the tabButton
        }
    }

//        gradient: Gradient {orientation : Gradient.Horizontal;GradientStop{position: 0;color: parent.checked ? colorHighlight: colorBackground;}GradientStop{position: 4;color: parent.checked ? colorTertiary: colorBackground;}}
    Rectangle {
        id: appContainer
        color: colorBackground
        anchors.left: parent.left
        anchors.right: settingsLeftPanel.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 30

        StackView {
            id: stackView
            anchors.fill: parent
            initialItem: Qt.resolvedUrl("pages/Home_page.qml")
            clip: true

//            replaceEnter: Transition {
//                XAnimator {
//                    from: if(stackViewDirection){stackView.width}else{-stackView.width}
//                    to: 0
//                    duration: if(stackViewAnimation){850}else{0}
//                    easing.type: Easing.InOutQuint
//                }
//            }
//
//            replaceExit: Transition {
//                XAnimator {
//                    from: 0
//                    to: if(stackViewDirection){-stackView.width}else{stackView.width}
//                    duration: if(stackViewAnimation){850}else{0}
//                    easing.type: Easing.InOutQuint
//                }
//            }
        }
    }

    UI_iconButton{
        property color color_button: colorBackgroundDark

        id: settings_button
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 11
        anchors.rightMargin: 5

        visible: !company_mode  // If company mode is enabled, the settings button is not visible.

//        iconColor: settingsLeftPanel.width === 260 ? colorHighlight: colorParagraph
        iconColor: settings_button.color_button
        iconPath: "../../../images/svg_images/settings.svg"
        buttonSize: 30
        backgroundVisible: false
        z:2

        Shortcut {
            sequence: "Ctrl+P"
            onActivated: {
                if(settings_button.anchors.rightMargin === 5){
                    colorAnimationOpening.running = true;
                }else{
                    colorAnimationFolding.running = true;
                }
                animationSettingsPannel.running = true;
                animationSettingsButton.running = true
            }
        }
        Shortcut{
            sequence: "Ctrl+Shift+P"

            onActivated: {
                company_mode = !company_mode
            }
        }
        onClicked: {
            if(settings_button.anchors.rightMargin === 5){
                colorAnimationOpening.running = true;
            }else{
                colorAnimationFolding.running = true;
            }
            animationSettingsPannel.running = true;
            animationSettingsButton.running = true
        }

        PropertyAnimation{
            id: animationSettingsButton
            target: settings_button
            property: "anchors.rightMargin"
            to: if(settings_button.anchors.rightMargin === 5) return 210; else return 5
            duration: 1000
            easing.type: Easing.InOutQuint
        }
        ColorAnimation on color_button{
            id: colorAnimationFolding; to: colorParagraph; duration: 1000 ; running: false; onFinished: settings_button.color_button = colorParagraph; easing.type: Easing.InOutQuint
        }
        ColorAnimation on color_button{
            id: colorAnimationOpening; to: colorHighlight; duration: 1000 ; running: false; onFinished: settings_button.color_button = colorHighlight; easing.type: Easing.InOutQuint
        }
        ColorAnimation on color_button{
            id: colorAnimationChanging; to: colorHighlight; duration: 1000 ; running: false; onFinished: settings_button.color_button = colorHighlight; easing.type: Easing.InOutQuint
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
            onFinished: {
            }
        }

        TabBar {
            id: themeSelector

            anchors.left: parent.left
            anchors.leftMargin: (19.5-150)/260*settingsLeftPanel.width + 150
            anchors.top: parent.top
            anchors.topMargin: 50
            z:2

            background: Rectangle {
                color: colorBackground // Couleur de la séparation
            }
            TabButton {
                id: temporaryButton
            }
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

            onClicked: main.open_github()

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

        function onSend_theme_list_signal(list_theme){
            // for each theme in list_theme add a tab button in the tabbar with the theme name
            for(var i = 0; i < list_theme.length; i++){
                internal.createSettingsTarButton(list_theme[i], themeName)
            }
            temporaryButton.destroy()
        }

        function onSend_theme_info_signal(info_theme, theme_name){
            tab_button_clickable = false

            themeName = theme_name

            colorBackgroundAnimation.to = info_theme["Background"]
            colorBackgroundAnimation.running = true

            colorBackgroundDarkAnimation.to = info_theme["BackgroundDark"]
            colorBackgroundDarkAnimation.running = true

            colorHeadlineAnimation.to = info_theme["Headline"]
            colorHeadlineAnimation.running = true

            colorParagraphAnimation.to = info_theme["Paragraph"]
            colorParagraphAnimation.running = true

            colorHighlightAnimation.to = info_theme["Highlight"]
            colorHighlightAnimation.running = true

            colorSecondaryAnimation.to = info_theme["Secondary"]
            colorSecondaryAnimation.running = true

            colorTertiaryAnimation.to = info_theme["Tertiary"]
            colorTertiaryAnimation.running = true

            colorStrokeAnimation.to = info_theme["Stroke"]
            colorStrokeAnimation.running = true

            if(settings_button.anchors.rightMargin === 5){
                settings_button.color_button = info_theme["Paragraph"]
            }else{
                colorAnimationChanging.to = info_theme["Highlight"]
                colorAnimationChanging.running = true
            }
        }

        function onSend_settings_signal(entreprise_mode){
            company_mode = entreprise_mode
        }

    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
