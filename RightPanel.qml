import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

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
            splitterA.color = leftPanel.color;
            splitterB.color = rightPanel.color;
        }
    }
}
