import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window{
    id: popup;
    width: 420;
    height: 400;
    color: "transparent";
    modality: Qt.ApplicationModal;
    Rectangle{
        id: topItem;
        anchors.fill: parent;
        color: "#cccccc";
        border.width: 1;
        border.color: "#ff9e9e9e";
        radius: 2;
        Rectangle{
            id: topBar;
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
            color: "#9e9e9e"
            Label{
                id: caption
                text: "About";
                anchors.centerIn: parent;
                font.family: "Century Gothic"
                font.letterSpacing: 0.5
                font.pointSize: 12;
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
                            onClicked: popup.close();
                        }
                    }
                anchors.right: parent.right;
                width: height * 1.5;
                height: parent.height - 2;
                text: "\u26CC";
            }
        }
        Image{
            id: icon;
            source: AppWindow.urlFromPath("./icon.ico");
            sourceSize.width: 96;
            sourceSize.height: 96;
            anchors.top: topBar.bottom;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.margins: 25;
        }
        TextEdit{
            id: textArea;
            anchors.top: icon.bottom;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            anchors.margins: 10;
            horizontalAlignment: TextEdit.AlignHCenter;
            verticalAlignment: TextEdit.AlignVCenter;
            readOnly: true;
            text:
            "Sir Ocelot File Manager (SOFM)\n is a file manager with
 multi-panel functionality, allowing to work with several panels (and tabs)
 at once in a single session.\n\n
Early Alpha Version (0.3.0)\n
Qt 5.12.3\n\n
Created by Max \"ZiMMeR_7\" Mazur\n\n
Licensed under the LGPLv3 license, the license file is included with the application.\n
2018-2019"
        }
    }
}
