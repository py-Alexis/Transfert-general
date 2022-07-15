import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.13
import "../controls"
import "../controls/button"
import "../controls/Home_page"
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
    property bool reload_selections: true
    property bool destroy_selections: true
    property var selections: []
    property var all_selections: []
    Shortcut{
        sequence: "Ctrl+N"

        onActivated:{

        }
    }
    QtObject{
        id: internal_home_page
        function destroy_and_reload_selections(){
            selections = []
            all_selections = []
            destroy_selections = !destroy_selections
            destroy_selections = !destroy_selections
            main.get_folders()
            internal_home_page.check_selections()
        }
        function check_selections(){
            if(selections.length === 0){
                validate_btn.something_to_copy = false
            }else{
                validate_btn.something_to_copy = true
            }
            if(selections.length === all_selections.length){

                select_all_btn.textBtn = "Désélectionner tout"
            }else{
                select_all_btn.textBtn = "Sélectionner tout"
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+R"

        onActivated: {
            internal_home_page.destroy_and_reload_selections()
        }
    }

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
        font.pointSize: 27

    }

    Label {
        id: to_backup
        color: colorHeadline
        text: "à copier"
        anchors.left: copy_size.right
        anchors.bottom: rectangle.top
        anchors.bottomMargin: 5
        anchors.leftMargin: 0
        font.pointSize: 27
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


        ScrollView {
            id: selectionScrollView
            anchors.fill: parent
            clip: true

            Column {
                id: selectionColumn
                anchors.fill: parent
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: spacing
                spacing: 10
            }
        }
    }

    UI_textButton {
        id: validate_btn

        property bool something_to_copy: false

        textBtn: "Valider"
        textColor: colorHeadline
        backgroundColor: colorHighlight
        emphasis: true
        enabled: if(copy_size.text === "Rien " || !something_to_copy){false}else{true}
        opacity: if(!enabled){0.4}else{1}

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 30
        anchors.bottomMargin: 20

        onClicked:{
            // display selections
            for(var i = 0; i < selections.length; i++){
                console.log(selections[i])
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
        id: select_all_btn
        textBtn: "Sélectionner tout"
        textColor: colorHeadline
        backgroundColor: colorBackground
        emphasis: false
        enabled: if(copy_size.text === "Rien "){false}else{true}
        opacity: if(copy_size.text === "Rien "){0.5}else{1}

        anchors.right: validate_btn.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: 20
        anchors.bottomMargin: 20

        onClicked: {
            if(selections.length === all_selections.length){
                selections = []
                internal_home_page.check_selections()
            }else{
//                selections = all_selections
//                  don't work because it link both array
                selections.splice(0,selections.length)
                for(var i = 0; i < selections.length; i++){
                }
                for(var i = 0; i < all_selections.length; i++){
                    selections.push(all_selections[i])
                }
                internal_home_page.check_selections()
            }
            reload_selections = !reload_selections
            reload_selections = !reload_selections

        }
    }

    Connections {
        target: main

        function onSend_folders(folders){

            for (const [key, value] of Object.entries(folders)) {
                if(value["from_valid"] === true && value["to_valid"] === true){
                    all_selections.push(key)
                var selection = `Selection{anchors.left: selectionColumn.left; width: selectionScrollView.width; name: "${key}"; from_path: "${value['from']}"; to_path: "${value['to']}"; data_size: "${value['size']}"; data_size_to_copy: "${value['size_to_copy']}"; data_last_copy: "${value['last_copy']}"; from_path_is_valid: ${value['from_valid']}; to_path_is_valid: ${value['to_valid']}; destroy: destroy_selections;selection: selections;reload_selection: reload_selections;}`
                var objectString = `import QtQuick 2.0; import QtQuick.Controls 2.13;import "../controls/Home_page"; ${selection}`;


                var newObject = Qt.createQmlObject(objectString, selectionColumn, "selections");
                }
            }
            for (const [key, value] of Object.entries(folders)) {
                if(value["from_valid"] !== true || value["to_valid"] !== true){
                    var selection = `Selection{anchors.left: selectionColumn.left; width: selectionScrollView.width; name: "${key}"; from_path: "${value['from']}"; to_path: "${value['to']}"; data_size: "${value['size']}"; data_size_to_copy: "${value['size_to_copy']}"; data_last_copy: "${value['last_copy']}"; from_path_is_valid: ${value['from_valid']}; to_path_is_valid: ${value['to_valid']}; destroy: destroy_selections;selection: selections;reload_selection: reload_selections;}`
                    var objectString = `import QtQuick 2.0; import QtQuick.Controls 2.13;import "../controls/Home_page"; ${selection}`;


                    var newObject = Qt.createQmlObject(objectString, selectionColumn, "selections");
                }
            }
        }
        function onSend_size(size){
            if(size === "0o "){
                copy_size.text = "Rien "
            }else{
                copy_size.text = size
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}
}
##^##*/
