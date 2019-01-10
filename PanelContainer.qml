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
        width: 20;
        x: parent.width/2 - width/2;
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
        Rectangle{
            id: splLeftBorder;
            anchors.left: parent.left;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            width: 1
            color: "#ff9e9e9e";
        }
        Rectangle{
            id: splBar;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.left: splLeftBorder.right;
            anchors.right: splRightBorder.left;
            color: "#cecece";
            Button{
                id: downArrow;
                background:
                    Rectangle{
                        color : "transparent"
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onPressed: parent.color = "#cccccc"
                            onReleased: parent.color = "#c4c4c4"
                            onEntered: parent.color = "#c4c4c4"
                            onExited: parent.color = "transparent"
                        }
                    }
                font.pointSize: 12;
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                text: "\u2186";
            }
        }
        Rectangle{
            id: splRightBorder;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
            width: 1;
            color: "#ff9e9e9e";
        }
    }
    RightPanel{
        id: rightPanel;
    }
}
