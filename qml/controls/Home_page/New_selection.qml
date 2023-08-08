import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import QtQuick.Dialogs 1.3

import "../../"
import "../../controls/button"

Item {

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

    property bool destroy: true
    property string old_name: ""
    onDestroyChanged: destroy()

    id: new_selection

    visible: !company_mode

    height: 80

    Rectangle{
        id: foreground_rectangle
        color: "#00000000"

        anchors.fill: parent
        radius: 20
        border.color: colorBackgroundDark

        opacity:if(button.hovered){
                    if(mouse_area.pressed){0.9}else{0.4}
                }else{1}

        border.width: 4
    }

    Image{
        id: iconImage
        source: "../../../images/svg_images/plus.svg"

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        sourceSize.width: 40
        sourceSize.height: 40
        height: 60
        width: 60

        opacity:if(button.hovered){
                    if(mouse_area.pressed){0.9}else{0.4}
                }else{1}



        visible: true
        mipmap: true

        ColorOverlay {
            anchors.fill: iconImage
            source: iconImage
            antialiasing: false
            color: colorParagraph
        }
    }
    Button {
        id: button
        anchors.fill: parent
        opacity: 0.0
    }
    MouseArea{

        id: mouse_area

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: new_selection_dialog.open()
    }
    Dialog{
        id: new_selection_dialog

        title: "Nouveau chemin"

        contentItem: Rectangle {
            color: colorBackground
            implicitWidth: 600
            implicitHeight: 350
            TextInput{

            }
            TextField {
                id: name_textfield

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 10
                anchors.leftMargin: 10

                placeholderTextColor: colorParagraph
                font.pointSize: 12
                placeholderText: qsTr("Nom du chemin")
                selectedTextColor: colorParagraph
                selectionColor: colorHighlight
                selectByMouse: true
                color: colorHeadline
                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 50
                    color: name_textfield.activeFocus ? "transparent" : colorBackgroundDark
                    border.color: name_textfield.activeFocus ? colorHighlight : "transparent"
                    border.width: 3
                    radius: 8

                }
            }
            Rectangle{
                id: name_description_rectangle

                anchors.top: name_textfield.top
                anchors.topMargin: -height/2 + 1.5
                anchors.left: name_textfield.left
                anchors.leftMargin: 12

                color: colorBackground
                width: name_description_label.width + 10
                height: name_description_label.height + 5

                visible: name_textfield.activeFocus ? true : false


                Label{
                    id: name_description_label

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: "Nom du chemin"
                    font.pointSize: 8
                    color: colorParagraph
                }
            }

            Label{
                id: from_label
                text: "De :"
                anchors.top: name_textfield.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 11
                color: colorParagraph
            }

            TextField {
                id: from_textfield

                anchors.top: from_label.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: from_button.left
                anchors.rightMargin: 10

                placeholderText: qsTr("Chemin de départ")
                placeholderTextColor: colorParagraph

                font.pointSize: 10
                selectedTextColor: colorParagraph
                selectionColor: colorHighlight
                selectByMouse: true
                color: colorHeadline

                KeyNavigation.tab: to_textfield

                background: Rectangle {
                    implicitHeight: 40
                    color: from_textfield.activeFocus ? "transparent" : colorBackgroundDark
                    radius: 8
                    Rectangle{
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 3
                        color: colorHighlight
                        visible: from_textfield.activeFocus ? true : false
                    }
                }
            }
            UI_iconButton{
               id: from_button

                anchors.top: from_textfield.top
                anchors.right: parent.right
                anchors.rightMargin: 10

                iconPath: "../../../images/svg_images/open.svg"

                buttonSize: 40

                iconColor: colorParagraph
                backgroundColor: colorBackgroundDark
                onClicked: from_fileImport.open()

                FileDialog{
                    id: from_fileImport
                    title: "Choisir le dossier de départ"
                    folder: shortcuts.desktop
                    selectMultiple: false
                    selectFolder: true
                    onAccepted: {
                        console.log(to_fileImport.fileUrl)
                        from_textfield.text = String(from_fileImport.fileUrl).slice(8)
                    }
                }
            }


            Label{
                id: to_label
                text: "Vers :"
                anchors.top: from_textfield.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pointSize: 11
                color: colorParagraph
            }

            TextField {
                id: to_textfield

                anchors.top: to_label.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: to_button.left
                anchors.rightMargin: 10

                placeholderText: qsTr("Chemin d'arrivée")
                placeholderTextColor: colorParagraph

                font.pointSize: 10
                selectedTextColor: colorParagraph
                selectionColor: colorHighlight
                selectByMouse: true
                color: colorHeadline

                KeyNavigation.tab: validate_btn


                background: Rectangle {
                    implicitHeight: 40
                    color: to_textfield.activeFocus ? "transparent" : colorBackgroundDark
                    radius: 8
                    Rectangle{
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 3
                        color: colorHighlight
                        visible: to_textfield.activeFocus ? true : false
                    }
                }
            }
            UI_iconButton{
               id: to_button

                anchors.top: to_textfield.top
                anchors.right: parent.right
                anchors.rightMargin: 10

                iconPath: "../../../images/svg_images/open.svg"

                buttonSize: 40

                iconColor: colorParagraph
                backgroundColor: colorBackgroundDark
                onClicked: to_fileImport.open()

                FileDialog{
                    id: to_fileImport
                    title: "Choisir le dossier d'arrivée"
                    folder: shortcuts.desktop
                    selectMultiple: false
                    selectFolder: true
                    onAccepted: {
                        to_textfield.text = String(to_fileImport.fileUrl).slice(8)
                    }
                }
            }
            UI_textButton {
                id: validate_btn
                textBtn: "Valider"
                textColor: colorHeadline
                backgroundColor: colorHighlight
                secondBackgroundColor: colorTertiary
                emphasis: true
                enabled: if(name_textfield.text === "" || from_textfield.text === "" || to_textfield.text === ""){false}else{true}
                opacity: if(!enabled){0.4}else{1}

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.bottomMargin: 20

                onClicked: {
                    // if the name is not in the all_selections list create a selection
                    if(!all_selections.includes(name_textfield.text)){
                        main.create_path(name_textfield.text, from_textfield.text, to_textfield.text, false, "")
                        internal_home_page.destroy_and_reload_selections()

                        new_selection_dialog.reject()
                        name_textfield.text = ""
                        from_textfield.text = ""
                        to_textfield.text = ""
                    }else{
                        // todo : if the name is in the all_selections list, ask the user if he wants to overwrite the selection
                    }
                }
            }
            DropShadow{
                id: dropShadow
                horizontalOffset: 2
                verticalOffset: 2
                radius: 10
                anchors.fill: validate_btn
                samples: 16
                color: "#4d010000"
                source: validate_btn
                visible: if(!validate_btn.enabled){false}else{true}
            }
            UI_textButton {
                id: cancel_btn
                textBtn: "Annuler"
                textColor: colorHeadline
                backgroundColor: colorBackground
                emphasis: false

                anchors.right: validate_btn.left
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.bottomMargin: 20

                onClicked: {
                    new_selection_dialog.reject()
                    name_textfield.text = ""
                    from_textfield.text = ""
                    to_textfield.text = ""
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.33}
}
##^##*/
