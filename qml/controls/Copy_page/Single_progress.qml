import QtQuick 2.13
import QtQuick.Controls 2.13
import QtGraphicalEffects 1.13
import QtQuick.Dialogs 1.3

import "../../"
import "../../controls/button"


Rectangle {
    property int bar_height: 5
    property string name: "Name"
    property int progression: 50
    property string total: "1 Go"
    property string progression_text: "1Mo"

    // color transparent
    color: "#00000000"
    height: detail.height + bar_height + 5
    Label{
        id: name_label
        text: name
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 5
        font.pointSize: 12
        color: colorHeadline
    }
    Label{
        id: detail
        text: total + "/" + progression_text
        anchors.bottom: name_label.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        color: colorParagraph
    }
    ProgressBar{
        id: progressBar
        value: progression
        to: 100
        anchors.top: name_label.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.left: parent.left

        background: Rectangle {
            color: colorBackgroundDark
            radius: bar_height/3
        }

        contentItem: Item {

            implicitWidth: 200
            implicitHeight: bar_height

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: colorHighlight
                radius: 2
                gradient: Gradient {
                    orientation : Gradient.Horizontal
                    GradientStop {
                        position: 0
                        color: colorHighlight
                    }

                    GradientStop {
                        position: 3
                        color: colorTertiary
                    }
                }
            }
        }
    }
}
