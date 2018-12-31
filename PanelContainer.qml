import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle{
    color: "transparent";
    anchors.top: panelBar.bottom;
    anchors.bottom: cmdBar.top;
    anchors.left: parent.left;
    anchors.right: parent.right;
    LeftPanel{
        id: leftPanel;
    }
    Item{
        id: splitterBar;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        width: 10
        x: parent.width/2 - width/2;
        z: -1;
        Rectangle{
            id: splitterA;
            color: leftPanel.color;
            anchors.left: parent.left;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            width: parent.width/2;
        }
        Rectangle{
            id: splitterB;
            color: rightPanel.color;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
            width: parent.width/2;
        }
        MouseArea{
            anchors.fill: parent;
            cursorShape: Qt.SplitHCursor;
            drag.target: splitterBar;
            drag.axis: Drag.XAxis;
            drag.smoothed: false;
            drag.threshold: 0;
            drag.minimumX: 0;
            drag.maximumX: panelContainer.width - parent.width;
        }
    }
    RightPanel{
        id: rightPanel;
    }
}
