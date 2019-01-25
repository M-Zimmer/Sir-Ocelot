import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    anchors.bottom: toolBar.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25
    color: "#ff9e9e9e"
    Rectangle{
        anchors.fill: parent;
        anchors.topMargin: 1;
        color: "#ffffff";
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: {parent.anchors.bottomMargin = 1;}
            onExited: { parent.anchors.bottomMargin = 0;}
        }
    }
}
