import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import "../../"
import "../../controls/button"

Item {

//    property color colorBackgroundDark: "#16161a"
//
//    property color colorHeadline: "#fffffe"
    property color colorParagraph: "#94a1b2"
//
//    property color colorHighlight: "#7f5af0"
//    property color colorSecondary: "#72757e"
//    property color colorTertiary: "#2cb67d"
//
//    property color colorStroke: "#010101"

    property string from_path: "from_path"
    property bool from_path_is_valide: true
    property string to_path: "D:/backup/ressources"
    property bool to_path_is_valide: true
    property string data_size: "1GB"
    property string data_size_to_copy: "200MB"
    property string data_last_copy: "1 hour ago"

    property string name: "Name"

    property bool checked: false

    QtObject{
        id: internal

        property bool compact: if((background_rectangle.width - (name_label.width + from_path_label.width)) > (940-550) ||(background_rectangle.width - (name_label.width + from_path_label.width)) > (940-550) ){true}else{false}
    }

    height: 80

    Rectangle{
        id: background_rectangle
        anchors.fill: parent
        anchors.topMargin: 0.11
        anchors.leftMargin: 0.11
        anchors.rightMargin: 0.11
        anchors.bottomMargin: 0.11

        visible: if(mouse_area.pressed){false}else{true}
        opacity: if(button.hovered){0.7}else{1}
        color: if(checked){colorHighlight}else{colorBackgroundDark}
        radius: 20

    }

    Rectangle{
        id: foreground_rectangle

        anchors.fill: parent
        anchors.leftMargin: 4
        radius: 20

        color: colorBackgroundDark

        Rectangle{
            id: checkbox
            height: 18
            width: 18

            anchors.left: parent.left
            anchors.leftMargin: 15

            color: background_rectangle.color
            anchors.verticalCenter: parent.verticalCenter
            opacity: if(mouse_area.pressed){0.5}else{background_rectangle.opacity}
            border.width: if(checked){0}else{1.5}
            border.color: colorParagraph
            radius: 5

            Image{
                id: iconImage
                source: "../../../images/svg_images/done.svg"

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                sourceSize.width: checkbox.width - 2
                sourceSize.height: checkbox.width - 2
                height: checkbox.width - 2
                width: checkbox.width - 2


                visible: if(checked){true}else{false}
                mipmap: true

                ColorOverlay {
                    anchors.fill: iconImage
                    source: iconImage
                    antialiasing: false
                    color: colorBackgroundDark
                }
            }
        }

        Label{
            id: name_label

            anchors.left: checkbox.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10

            text: name

            color: colorHeadline
            font.pointSize: 15
        }

        Item{
            id: paths
            anchors.right: parent.right

            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.rightMargin: if(internal.compact){230}else{30}

            Label{
                id: from_label
                font.pointSize: 13
                anchors.top: parent.top
                anchors.rightMargin: 10
                anchors.topMargin: (parent.height - height*2)/3

                text: "De : "
                anchors.right: if(from_path_label.width > to_path_label.width){from_path_label.left}else{to_path_label.left}
                color: colorParagraph


            }   

            Rectangle{
                id: from_path_rectangle
                height: from_path_label.height + 5
                width: from_path_label.width + 10
                anchors.left: from_path_label.left
                anchors.top: from_path_label.top
                anchors.leftMargin: -5
                anchors.topMargin: -2.5
                color: colorBackground
                radius: 5
            }

            Label {
                id: from_path_label
                color: colorParagraph
                text: from_path
                anchors.right: separator.left
                anchors.top: parent.top
                anchors.rightMargin: 20
                font.pointSize: 13
                anchors.topMargin: (parent.height - height*2)/3
            }
            Rectangle{
                id: to_path_rectangle
                height: to_path_label.height + 5
                width: to_path_label.width + 10
                anchors.left: to_path_label.left
                anchors.top: to_path_label.top
                anchors.leftMargin: -5
                anchors.topMargin: -2.5
                color: colorBackground
                radius: 5
            }
            Label{
                id: to_label
                anchors.bottom: parent.bottom
                anchors.rightMargin: 10
                anchors.bottomMargin: (parent.height - height*2)/3
                font.pointSize: 13

                text: "Vers : "
                anchors.right: if(from_path_label.width > to_path_label.width){from_path_label.left}else{to_path_label.left}
                color: colorParagraph


            }
            Label{
                id: to_path_label
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.bottomMargin: (parent.height - height*2)/3
                font.pointSize: 13

                text: to_path
                anchors.right: separator.left

                color: colorParagraph
            }
            Rectangle{
                id: separator
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: -2
                height: parent.height - 14
                width: 2
                color: colorParagraph
                visible: if(internal.compact){true}else{false}
                radius: 4
            }
        }

        Item{
            id: detail
            anchors.left: paths.right
            visible: if(internal.compact){true}else{false}

            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20

            Label{
                id: size

                anchors.top: parent.top
                anchors.topMargin: (parent.height - height*3)/4
                anchors.left: parent.left
                anchors.leftMargin: 0

                text: "Taille : "
                color: colorParagraph
                font.pointSize: 10
            }
            Label{
                id: size_to_copy

                anchors.top: size.bottom
                anchors.topMargin: (parent.height - height*3)/4
                anchors.left: parent.left
                anchors.leftMargin: 0

                text: "Taille à copier: "
                color: colorParagraph
                font.pointSize: 10
            }
            Label{
                id: last_copy

                anchors.top: size_to_copy.bottom
                anchors.topMargin: (parent.height - height*3)/4
                anchors.left: parent.left
                anchors.leftMargin: 0

                text: "Dernière copie : "
                color: colorParagraph
                font.pointSize: 10
            }
            Label{
                id: size_data

                anchors.top: parent.top
                anchors.topMargin: (parent.height - height*3)/4
                anchors.left: size.right
                anchors.leftMargin: 5

                text: data_size
                color: colorParagraph
                font.pointSize: 10
            }
            Label{
                id: size_to_copy_data

                anchors.top: size.bottom
                anchors.topMargin: (parent.height - height*3)/4
                anchors.left: size_to_copy.right
                anchors.leftMargin: 5

                text: data_size_to_copy
                color: colorParagraph
                font.pointSize: 10
            }
            Label{
                id: last_copy_data

                anchors.top: size_to_copy.bottom
                anchors.topMargin: (parent.height - height*3)/4
                anchors.left: last_copy.right
                anchors.leftMargin: 5

                text: data_last_copy
                color: colorParagraph
                font.pointSize: 10
            }
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
        onClicked: checked = !checked
    }
    UI_iconButton{
        id: modify_button

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.topMargin: (foreground_rectangle.height - height*2)/3

        iconPath: "../../../images/svg_images/modify.svg"
        buttonSize: 27

        iconColor: colorParagraph
        backgroundVisible: false

        onClicked: console.log((background_rectangle.width - (name_label.width + from_path_label.width)))


    }
    UI_iconButton{
        id: delete_button

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: (foreground_rectangle.height - height*2)/3

        iconPath: "../../../images/svg_images/delete.svg"
        buttonSize: modify_button.buttonSize

        iconColor: colorParagraph
        backgroundVisible: false

        onClicked: console.log((background_rectangle.width - (name_label.width + from_path_label.width)) < (940-550) ||(background_rectangle.width - (name_label.width + from_path_label.width)) < (940-550) )



    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.33}
}
##^##*/
