import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    color: "transparent";
    anchors.top: panelBar.bottom;
    anchors.bottom: cmdBar.top;
    anchors.left: parent.left;
    anchors.right: parent.right;
    Panel{
        id: leftPanel;
        anchors.left: parent.left;
        anchors.right: splitterBar.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        property string viewObjName: "leftViewObj"
        property string modelObjName: "leftFSModel"
    }
    Rectangle{
        id: splitterBar;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        width: 20;
        x: parent.width/2 - width/2;
        color: "#cecece";
        MouseArea{
            anchors.fill: parent;
            cursorShape: Qt.SplitHCursor;
            drag.target: parent;
            drag.axis: Drag.XAxis;
            drag.smoothed: false;
            drag.threshold: 0;
            drag.minimumX: 0;
            drag.maximumX: panelContainer.width - parent.width;
        }
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
    Panel{
        id: rightPanel;
        anchors.left: splitterBar.right;
        anchors.right: parent.right
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        property string viewObjName: "rightViewObj"
        property string modelObjName: "rightFSModel"
    }
}
