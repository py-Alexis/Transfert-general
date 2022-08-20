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
    property bool destroy_bars: true
    QtObject{
        id: internal_copy_page
        function destroy_progress_bars(){
            destroy_bars = !destroy_bars
            destroy_bars = !destroy_bars
            total_progress.progression = 0
            total_progress.progression_text = "0 %"
        }

    }

    Shortcut {
        sequence: "Ctrl+R"

        onActivated: {
            internal_copy_page.destroy_progress_bars()
        }
    }

    Shortcut {
        sequence: "Ctrl+H"

        onActivated: console.log("Ctrl+H")
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

        onClicked: {
            main.cancel_copy()
        }
    }
    Single_progress{
        id: total_progress

        name: "Total"
        bar_height: 10
        anchors.left: cancel_btn.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (80-height)/2

        percent: true
        progression: 0
        progression_text: "0 %"
    }

    Connections {
        target: main

        function onSend_create_bars_signal(folders){

            for (const [key, value] of Object.entries(folders)) {
                var selection = `Single_progress{width: selectionScrollView.width; name: "${key}"; total: "${value}"; destroy: destroy_bars}`
                var objectString = `import QtQuick 2.0; import QtQuick.Controls 2.13;import "../controls/Copy_page"; ${selection}`;

                var newObject = Qt.createQmlObject(objectString, selectionColumn, "bars");
            }

        }

        function onSignal_copy_finished(){
            stackView.replace(Qt.resolvedUrl("../pages/Home_page.qml"))
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.9;height:480;width:640}
}
##^##*/
