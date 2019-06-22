import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32
    color: "#9e9e9e"
    Image{
        id: icon;
        source: AppWindow.urlFromPath("./icon.ico");
        sourceSize.width: 32;
        sourceSize.height: 32;
        anchors.left: parent.left;
    }
    Label{
        id: caption
        text: "Sir Ocelot File Manager";
        anchors.left: icon.left;
        anchors.leftMargin: 40;
        anchors.verticalCenter: parent.verticalCenter;
        font.family: "Century Gothic"
        font.letterSpacing: 0.5
        font.pointSize: 12;
    }
    Button{
        id: minimizeButton;
        background: Rectangle{
                color : "transparent"
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#c4c4c4"
                    onEntered: parent.color = "#c4c4c4"
                    onExited: parent.color = "transparent"
                    onClicked: window.showMinimized();
                }
            }
        anchors.right: maximizeButton.left;
        width: height * 1.5;
        height: parent.height - 2;
        text: "\u268A";
    }
    Button{
        id: maximizeButton;
        background: Rectangle{
                color : "transparent"
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#c4c4c4"
                    onEntered: parent.color = "#c4c4c4"
                    onExited: parent.color = "transparent"
                    onClicked: {
                        if (window.visibility != Window.Maximized)
                            window.showMaximized();
                        else
                            window.showNormal();
                    }
                }
            }
        anchors.right: exitButton.left;
        width: height * 1.5;
        height: parent.height - 2;
        text: "\u2610";
    }
    Button{
        id: exitButton;
        background: Rectangle{
                color : "transparent"
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#c4c4c4"
                    onEntered: parent.color = "#c4c4c4"
                    onExited: parent.color = "transparent"
                    onClicked: exitAction.trigger();
                }
            }
        anchors.right: parent.right;
        width: height * 1.5;
        height: parent.height - 2;
        text: "\u26CC";
    }
}
