import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Button {
    id: btnText

    //CUSTOM PROPERTIES
    property string textBtn: "nouveau"

    property color textColor: "#fffffe"
    property color backgroundColor: "#7f5af0"

    property bool emphasis: false

    width: text_of_btn.width + 20
    height: text_of_btn.height + 7

    font.pointSize: 13

    background: Rectangle{
        id: bgBtn
        color: if(!emphasis){"#00000000"}else{backgroundColor}
        radius: 7

        border.color: textColor
        border.width: if(!emphasis){if(btnText.hovered){1.5}else{0}}else{0}

        opacity: if(emphasis){
            if(btnText.hovered){
                if(btnText.down){1}else{0.6}
            }else{1}
        }else{
            if(btnText.down){0.6}else{1}
        }
    }

    contentItem: Item{
        id: content

        Text{
            id: text_of_btn
            color: textColor
            text: textBtn
            font.pointSize: btnText.font.pointSize

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            opacity: if(emphasis == "low"){if(btnText.hovered){0.7}else{1}}else{1}
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
