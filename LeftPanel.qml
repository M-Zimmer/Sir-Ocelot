import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle{
    color: "#dddddd";
    anchors.left: parent.left;
    anchors.right: splitterBar.left;
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;
    MouseArea{
        anchors.fill: parent;
        onClicked: {
            parent.color = rightPanel.color == "#dddddd" ? "#dddddd" : parent.color;
            rightPanel.color = "#c6c6c6";
        }
    }
}
