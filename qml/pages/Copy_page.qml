import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.13
import "../controls"
import "../controls/button"
import "../controls/Copy_page"
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
           console.log(mqlkdjfmlqdkjf.height)
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

                cancel_btn.textBtn = "Désélectionner tout"
            }else{
                cancel_btn.textBtn = "Sélectionner tout"
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
        id: listview
        color: "#00000000"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: rectangle.top
        anchors.topMargin: 60
        anchors.leftMargin: 50
        anchors.rightMargin: 50


        ScrollView {
            id: selectionScrollView
            anchors.fill: parent
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            Column {
                id: selectionColumn
                anchors.fill: parent
                spacing: 20

                Single_progress{
                id: mqlkdjfmlqdkjf
                    width: selectionScrollView.width
                }
                Single_progress{
                    width: selectionScrollView.width
                }
                Single_progress{
                    width: selectionScrollView.width
                }
            }
        }
    }


    Rectangle {
        id: rectangle
        height: 3
        color: colorParagraph
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 80
        anchors.rightMargin: 30
        anchors.leftMargin: anchors.rightMargin
    }

    UI_textButton {
        id: cancel_btn
        textBtn: "Annuler"
        textColor: colorHeadline
        backgroundColor: colorBackground
        emphasis: false

        anchors.left: rectangle.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (80-height)/2
    }
    Single_progress{
        bar_height: 10
        anchors.left: cancel_btn.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (80-height)/2
    }

    Connections {
        target: main

//        function onSend_folders(folders){
//
//            for (const [key, value] of Object.entries(folders)) {
//                if(value["from_valid"] === true && value["to_valid"] === true){
//                    all_selections.push(key)
//                var selection = `Selection{anchors.left: selectionColumn.left; width: selectionScrollView.width; name: "${key}"; from_path: "${value['from']}"; to_path: "${value['to']}"; data_size: "${value['size']}"; data_size_to_copy: "${value['size_to_copy']}"; data_last_copy: "${value['last_copy']}"; from_path_is_valid: ${value['from_valid']}; to_path_is_valid: ${value['to_valid']}; destroy: destroy_selections;selection: selections;reload_selection: reload_selections;}`
//                var objectString = `import QtQuick 2.0; import QtQuick.Controls 2.13;import "../controls/home_page"; ${selection}`;
//
//
//                var newObject = Qt.createQmlObject(objectString, selectionColumn, "selections");
//                }
//            }
//            for (const [key, value] of Object.entries(folders)) {
//                if(value["from_valid"] !== true || value["to_valid"] !== true){
//                    var selection = `Selection{anchors.left: selectionColumn.left; width: selectionScrollView.width; name: "${key}"; from_path: "${value['from']}"; to_path: "${value['to']}"; data_size: "${value['size']}"; data_size_to_copy: "${value['size_to_copy']}"; data_last_copy: "${value['last_copy']}"; from_path_is_valid: ${value['from_valid']}; to_path_is_valid: ${value['to_valid']}; destroy: destroy_selections;selection: selections;reload_selection: reload_selections;}`
//                    var objectString = `import QtQuick 2.0; import QtQuick.Controls 2.13;import "../controls/Home_page"; ${selection}`;
//
//
//                    var newObject = Qt.createQmlObject(objectString, selectionColumn, "selections");
//                }
//            }
//
//            var new_selection = "import QtQuick 2.0; import '../controls/home_page'; New_selection{anchors.left: selectionColumn.left; width: selectionScrollView.width; destroy: destroy_selections}"
//            var newObject = Qt.createQmlObject(new_selection, selectionColumn, "new_selections");
//        }
//        function onSend_size(size){
//            if(size === "0o "){
//                copy_size.text = "Rien "
//            }else{
//                copy_size.text = size
//            }
//        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}
}
##^##*/
