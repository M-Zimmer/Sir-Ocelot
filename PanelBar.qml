import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    anchors.top: menuBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35
    color: "#ff9e9e9e"
    Rectangle{
        anchors.fill: parent;
        anchors.topMargin: 1;
        anchors.bottomMargin: 1;
        color: "#cccccc";
    }
}
