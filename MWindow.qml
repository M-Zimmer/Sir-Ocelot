import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window{
    id: window
    visible: true
    width: Screen.width/1.5
    height: Screen.height/1.5
    color: "transparent";
    property int columnCount: 4
    property var columnWidths: [200, 100, 125, 150]
    TopBar{
        id: topBar;
    }
    MenuBar{
        id: menuBar
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 25
        spacing: 1
        background: Rectangle{
                color: "#cccccc"
            }
        font.family: "Arial"
        font.weight: Font.Thin
        MenuBarItem{
            id: fileMenu
            height: 25
            anchors.left: parent.left
            menu:
                Menu{
                    title: qsTr("File")
                }
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        MenuBarItem{
            height: 25
            anchors.left: fileMenu.right
            menu:
                Menu{
                    title: qsTr("Edit")
                }
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        MenuBarItem{
            height: 25
            anchors.right: parent.right
            menu:
                Menu{
                    title: qsTr("About")
                }
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }

    }
    PanelBar{
        id: panelBar;
    }
    PanelContainer{
        id: panelContainer;
    }
    CmdBar{
        id: cmdBar;
    }
    ToolBar {
        id: toolBar
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
            text: qsTr("View (F3)")
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            text: qsTr("Copy (F5)")
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            text: qsTr("Move (F6)")
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            text: qsTr("Mkdir (F7)")
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            text: qsTr("Delete (F8)")
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            text: qsTr("Exit (Alt+F4)")
            onClicked: Qt.quit()
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
    }
}
}
