import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle{
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    color: "#9e9e9e"
    MouseArea{
        anchors.fill: parent;
        onPressed: {
            AppWindow.handlePressedEvent();
        }
        onPositionChanged: {
            if (pressedButtons & Qt.LeftButton);
               AppWindow.handleDragEvent();
        }
    }
    Label{
        text: "Sir Ocelot File Manager";
        anchors.centerIn: parent;
        font.family: "Century Gothic"
        font.letterSpacing: 0.5
        font.pointSize: 12;
    }
    // \u26CC CLOSE
    // \u268A MINIMIZE
    // \u2750 MAXIMIZE
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
            AppWindow.handleMaximizeEvent();
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
