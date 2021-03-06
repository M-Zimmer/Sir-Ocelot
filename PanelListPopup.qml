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
    y: 20;
    width: parent.width;
    height: 300;
    background: Rectangle{ color: "#cccccc"}
    property var model: ListModel{
        id: popupModel;
    }
    function isMinimized(index){
        return model.get(index).minimized;
    }
    property var count: model.count;
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        NumberAnimation { property: "y"; from: 20; to: 25 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
        NumberAnimation { property: "y"; from: 25; to: 20 }
    }
    ListView{
        id: popupList;
        anchors.fill: parent;
        orientation: ListView.Horizontal;
        model: popupModel;
        delegate: ItemDelegate{
            height: parent.height;
            width: 150;
            Item{
                id: popupTopRow
                height: 0.1 * parent.height;
                width: parent.width;
                Text {
                    id: popupItemText;
                    anchors.top: parent.top;
                    anchors.bottom: parent.bottom;
                    anchors.left: parent.left;
                    anchors.right: popupItemCloseButton.left;
                    elide: Text.ElideRight;
                    text: name;
                    verticalAlignment: Text.AlignVCenter;
                }
                Button{
                    id: popupItemCloseButton;
                    anchors.top: parent.top;
                    anchors.bottom: parent.bottom;
                    anchors.right: parent.right;
                    width: height * 1.1;
                    text: "\u26CC";
                    background: Rectangle{
                    color : "transparent"
                    enabled: popup.parent.count > 1 ? true : false;
                    MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onPressed: parent.color = "#cccccc"
                            onReleased: parent.color = "#88c4c4c4";
                            onEntered: parent.color = "#88c4c4c4";
                            onExited: parent.color = "transparent"
                            onClicked: popup.parent.removePanel(index);
                        }
                    }
                }
            }
            Image{
                asynchronous: true;
                id: popupItemImage;
                fillMode: Image.PreserveAspectFit;
                anchors.top: popupTopRow.bottom;
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                source: imageUrl;
            }
            onClicked: {
                minimized = false;
                popup.parent.currentIndex = index;
            }
        }
    }
    onClosed: showSingleListAction.enabled = true;
}
