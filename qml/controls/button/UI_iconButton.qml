import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13

Button {
    id: btnText

    //CUSTOM PROPERTIES
    property string iconPath: "icon.svg"
    property double buttonSize: 40

    property color iconColor: "#fffffe"
    property color backgroundColor: "#7f5af0"
    property color iconColorDisabled: "#242629"

    property bool backgroundVisible: true
    property bool circle: false


    height: buttonSize
    width: buttonSize

    background: Rectangle{
        id: bgBtn
        color: if(backgroundVisible){backgroundColor}else{"#00000000"}
        radius: circle ? buttonSize/2 : buttonSize/5

        opacity: if(backgroundVisible){
            if(enabled){
                if(btnText.hovered){
                    if(btnText.down){1}else{0.5}
                }else{1}
            }else{0.8}
        }else{0}
   }

    contentItem: Item{
        id: content

        Image{
            id: iconImage
            source: iconPath

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            sourceSize.width: buttonSize - 10
            sourceSize.height: buttonSize - 10
            height: buttonSize - 10
            width: buttonSize - 10

            opacity:
            if(enabled){
                if(btnText.hovered){
                    if(btnText.down){1}else{0.5}
                }else{1}
            }else{if(backgroundVisible){1}else{0.7}}


            visible: true
            mipmap: true

            ColorOverlay {
                anchors.fill: iconImage
                source: iconImage
                antialiasing: false
                color: if(enabled){iconColor}else{iconColorDisabled}
            }
        }
    }
}
