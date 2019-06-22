import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ToolBar {
        background: Rectangle{
            color: "#dddddd"
        }
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: implicitHeight + 5
    RowLayout {
        anchors.fill: parent
        ToolButton {
            Layout.fillWidth: true
            action: viewOpenAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: copyAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: moveAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: mkdirAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: deleteAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: exitAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
    }
}
