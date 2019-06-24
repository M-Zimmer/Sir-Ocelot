// Copyright 2018-2019 Max Mazur
/*
    This file is part of Sir Ocelot File Manager.

    Sir Ocelot File Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Sir Ocelot File Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Sir Ocelot File Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup{
    id: popup;
    property string url: fsModel.folder;
    function callMakeObject(){
        AppWindow.makeNewFile(AppWindow.pathFromUrl(url), objTypeBox.currentIndex, newNameField.text);
        popup.close();
    }
    background: Rectangle{
                 color: "#ff9e9e9e";
                 Rectangle{
                   color: "#cccccc"
                   anchors.fill: parent;
                   anchors.topMargin: 1;
                 }
                }
    width: parent.width;
    height: 90;
    y: parent.height - height;
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        NumberAnimation { property: "y"; from: parent.height - height + 25; to: parent.height - height; }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
        NumberAnimation { property: "y"; from: parent.height - height; to: parent.height - height + 25; }
    }
    Item{
        anchors.fill: parent;
        Text{
            id: newNameLabel
            text: "New object name:";
            anchors.top: parent.top;
            anchors.left: parent.left;
            elide: Text.ElideRight;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
            leftPadding: 2;
            font.pointSize: 10;
        }
        Text{
            id: objTypeLabel
            anchors.top: parent.top;
            anchors.left: objTypeBox.left;
            text: "Object type/extension:";
            elide: Text.ElideRight;
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignHCenter;
            leftPadding: 2;
            font.pointSize: 10;
        }
        TextField{
            id: newNameField;
            background: Rectangle{
                border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
                radius: 2;
            }
            anchors.top: newNameLabel.bottom;
            anchors.topMargin: 10;
            anchors.left: parent.left;
            height: 25;
            width: parent.width/1.5;
            onAccepted: popup.callMakeObject();
        }
        ComboBox{
            id: objTypeBox;
            background: Rectangle{
                color: "transparent"
                border.color: "#ff9e9e9e";
                radius: 2
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onEntered: parent.color = "#E2E2E2";
                    onExited: parent.color = "transparent";
                    onClicked: objTypeBox.popup.opened ? objTypeBox.popup.close() : objTypeBox.popup.open();
                }
            }
            indicator.width: 20;
            indicator.height: 15;
            anchors.top: objTypeLabel.bottom;
            anchors.topMargin: 10;
            anchors.left: newNameField.right;
            anchors.right: parent.right;
            model: AppWindow.getNewFileExt();
            height: 25;
            leftInset: 2;
            bottomInset: 2;
            rightInset: 2;
        }
        Button{
            id: cancelButton;
            background: Rectangle{
                color: "transparent";
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#ffc4c4c4"
                    onEntered: parent.color = "#ffc4c4c4";
                    onExited: parent.color = "transparent";
                    onClicked: {
                        popup.close();
                    }
                }
            }
            anchors.top: objTypeBox.bottom;
            anchors.right: parent.right;
            font.pointSize: 10;
            width: 75;
            height: 25;
            text: "Cancel";
        }
        Button{
            id: okButton;
            background: Rectangle{
                color: "transparent";
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#ffc4c4c4"
                    onEntered: parent.color = "#ffc4c4c4";
                    onExited: parent.color = "transparent";
                    onClicked: {
                        popup.callMakeObject();
                    }
                }
            }
            anchors.top: objTypeBox.bottom;
            anchors.right: cancelButton.left;
            font.pointSize: 10;
            width: 75;
            height: 25;
            text: "OK";
        }
    }
}
