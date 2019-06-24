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
    x: 0;
    onAboutToShow: {
        var windowCoord = parent.mapToItem(window.contentItem, 0, 0);
        if (windowCoord.x + contentWidth > window.width){
            x = -(windowCoord.x + contentWidth - window.width);
        }else x = 0;
    }
    contentHeight: popupList.height
    contentWidth: popupList.width
    background: Rectangle{ color: "#f9f9f9"}
    padding: 0;
    property var model: ListModel{
        id: popupModel;
    }
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 60; }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 60; }
    }
    ListView{
        id: popupList;
        width: 200;
        height: contentHeight;
        orientation: ListView.Vertical;
        interactive: false;
        model: popupModel;
        delegate: ItemDelegate{
            id: delegate
            height: 25;
            width: parent.width;
            background: Rectangle{
                    color: "transparent";
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onClicked: {
                            fsView.pathHistoryPos = index;
                            fsModel.folder = url;
                            popup.close();
                        }
                        onPressed: parent.color = "#cccccc"
                        onReleased: parent.color = "#88c4c4c4"
                        onEntered: parent.color = "#88c4c4c4";
                        onExited: parent.color = "transparent";
                    }
                }
            Text {
                    id: popupItemText;
                    elide: Text.ElideMiddle;
                    text: path;
                    anchors.fill: parent;
                    anchors.margins: 5;
            }

        }
    }
}
