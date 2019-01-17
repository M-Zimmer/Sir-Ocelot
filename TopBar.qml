import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    color: "#9e9e9e"
    Label{
        text: "Sir Ocelot File Manager";
        anchors.centerIn: parent;
        font.family: "Century Gothic"
        font.letterSpacing: 0.5
        font.pointSize: 12;
    }
    RoundButton{
        id: minimizeButton;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: maximizeButton.left;
        anchors.margins: 5
        width: 22;
        height: 22;
        text: "\u268A";
        onClicked: window.showMinimized();
    }
    RoundButton{
        id: maximizeButton;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: exitButton.left;
        anchors.margins: 5
        width: 22;
        height: 22;
        text: "\u2610";
        onClicked: {
         if (window.visibility != Window.Maximized)
           window.showMaximized();
         else
           window.showNormal();
        }
    }
    RoundButton{
        id: exitButton;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: parent.right;
        anchors.margins: 5
        width: 22;
        height: 22;
        text: "\u26CC";
        onClicked: Qt.quit();
    }
}
