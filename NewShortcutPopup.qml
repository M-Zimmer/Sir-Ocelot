import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window{
    id: popup;
    width: 600
    height: 240
    property string fileName;
    color: "transparent";
    Item{
        id: topItem;
        anchors.fill: parent;
        Rectangle{
            id: topBar;
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
            color: "#9e9e9e"
            Label{
                id: caption
                text: "Create a shortcut...";
                anchors.centerIn: parent;
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
                            onClicked: popup.showMinimized();
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
                                if (popup.visibility != Window.Maximized)
                                    popup.showMaximized();
                                else
                                    popup.showNormal();
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
                            onClicked: popup.close();
                        }
                    }
                anchors.right: parent.right;
                width: height * 1.5;
                height: parent.height - 2;
                text: "\u26CC";
            }
        }
        Rectangle{
            color: "#cccccc"
            anchors.top: topBar.bottom;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            ColumnLayout{
                    id: mainLayout;
                    anchors.top: parent.top;
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    Text{
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 30;
                            text: "Shortcut name";
                            font.family: "Century Gothic"
                            verticalAlignment: Text.AlignBottom;
                            font.letterSpacing: 0.5
                            font.pointSize: 10;
                            Layout.leftMargin: 8;
                    }
                    TextField{
                            id: shortcutNameField
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 30;
                            Layout.leftMargin: 10;
                            Layout.rightMargin: 10;
                            background: Rectangle{
                            border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
                            radius: 2;
                            }
                            placeholderText: "Optional - Will use the default shortcut name.";
                            onAccepted: {
                                beginCreateShortcutAction.trigger();
                            }
                    }
                    Rectangle{
                        Layout.fillWidth: true;
                        Layout.preferredHeight: 1;
                        Layout.topMargin: 8;
                        Layout.leftMargin: 8;
                        Layout.rightMargin: 8;
                        color: "#ff9e9e9e";
                    }
                    Text{
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 25;
                            Layout.leftMargin: 8;
                            text: "Source file/folder:";
                            font.family: "Century Gothic"
                            verticalAlignment: Text.AlignVCenter;
                            font.letterSpacing: 0.5
                            font.pointSize: 10;
                    }
                    TextField{
                            id: sourceObjField;
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 30;
                            Layout.leftMargin: 10;
                            Layout.rightMargin: 10;
                            text: fileName;
                            background: Rectangle{
                            border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
                            radius: 2;
                            }
                            onAccepted:{
                                beginCreateShortcutAction.trigger();
                            }
                    }
                    Rectangle{
                        Layout.fillWidth: true;
                        Layout.preferredHeight: 1;
                        Layout.topMargin: 8;
                        Layout.leftMargin: 8;
                        Layout.rightMargin: 8;
                        color: "#ff9e9e9e";
                    }
                }
            RowLayout{
                anchors.top: mainLayout.bottom;
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.margins: 10;
                Button{
                    id: okBtn;
                    Layout.preferredHeight: 30;
                    text: "OK";
                    onClicked: {
                       beginCreateShortcutAction.trigger();
                    }
                }
                Button{
                    id: cancelBtn;
                    Layout.preferredHeight: 30;
                    text: "Cancel";
                    onClicked: cancelAction.trigger();
                }
            }
        }
    }
    Action{
        id: beginCreateShortcutAction;
        onTriggered: {
           AppWindow.makeNewFile(AppWindow.pathFromUrl(activeView.model.folder), 1, sourceObjField.text, shortcutNameField.text);
           popup.close();
        }
    }
    Action{
        id: cancelAction;
        shortcut: "Ctrl+X";
        onTriggered: {
            popup.close();
        }
    }
}
