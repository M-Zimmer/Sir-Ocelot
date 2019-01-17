import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    color: "#c6c6c6";
    anchors.left: splitterBar.right;
    anchors.right: parent.right;
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;
    MouseArea{
        anchors.fill: parent;
        onClicked: {
            parent.color = leftPanel.color == "#dddddd" ? "#dddddd" : parent.color;
            leftPanel.color = "#c6c6c6";
        }
    }
}
