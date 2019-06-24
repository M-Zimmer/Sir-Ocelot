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

//"#1C2977F3";
Rectangle {
    id: topRect;
    color: index % 2 == 0 ? "#ededed" : "#f4f4f4"
    width: parent.width
    height: 19;
    property var initPressedPos: ({x: null, y: null});
    Row{
        anchors.fill: parent;
        Image{
            id: icon
            asynchronous: true;
            source: AppWindow.requestImageSource(filePath);
            sourceSize.height: 16
            sourceSize.width: 16;
            anchors.verticalCenter: parent.verticalCenter
        }
        Repeater{
            id: repeater
            model: window.columnCount;
            Text {
                width: {
                    if (index != 0)
                        return window.columnWidths[index]
                    else return window.columnWidths[index] - icon.implicitWidth
                }
                height: parent.height;
                elide: Text.ElideRight;
                text: switch(index){
                      case 0: return filePath;
                      case 1: return AppWindow.fileType(filePath);
                      case 2: return fileSize;
                      case 3: return fileModified;
                      }
                verticalAlignment: Text.AlignVCenter;
                leftPadding: 2;
            }

        }
    }
    Rectangle{
        id: selectedVisRect;
        anchors.fill: parent;
        color: "#1C2977F3";
    }
    states: [
        State {
            name: "selected"
            PropertyChanges { target: selectedVisRect; visible: true }
        },
        State {
            name: "deselected"
            PropertyChanges { target: selectedVisRect; visible: false }
        }
    ]
    state: searchView.selectedIndexes[index] ? "selected" : "deselected";
    MouseArea{
        id: mArea;
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton | Qt.RightButton;
        hoverEnabled: true;
        onEntered: parent.color = Qt.tint(parent.color, "#1C2977F3")
        onExited: parent.color = index % 2 == 0 ? "#ededed" : "#f4f4f4"
        onClicked: {
                    searchView.currentIndex = index;
                    if (mouse.modifiers & Qt.ControlModifier){
                        parent.state = parent.state === "selected" ? "deselected" : "selected";
                        searchView.selectedIndexes[index] = parent.state === "selected";
                    }
                    else if (mouse.modifiers & Qt.ShiftModifier){
                        searchView.requestDeselectAll();
                        searchView.requestRangeSelection(index, searchView.shiftAnchorIndex);
                    }
                    else {
                        if (mouse.button === Qt.LeftButton)
                            searchView.requestDeselectAll();
                        parent.state = "selected";
                        searchView.selectedIndexes[index] = true;
                    }

                    if (!(mouse.modifiers & Qt.ShiftModifier)){
                      searchView.shiftAnchorIndex = index;
                    }

                    if (mouse.button === Qt.RightButton){
                        AppWindow.openContextMenu(searchView.getSelectedPaths());
                    }

        }
        onDoubleClicked: {
            if (isFolder){
                activeView.model.folder = AppWindow.urlFromPath(filePath);
            }
            else Qt.openUrlExternally(AppWindow.urlFromPath(filePath));
        }
    }
    Connections{
        target: searchView;
        onRequestDeselectAll: if (topRect.state === "selected"){ topRect.state = "deselected";}
        onRequestSelectAll: if (topRect.state !== "selected"){ topRect.state = "selected";}
        onRequestInvertSelection: if (topRect.state === "selected") topRect.state = "deselected";
                                  else if (topRect.state === "deselected") topRect.state = "selected";
        onRequestRangeSelection: {
            if (left > right){
                var t = left;
                left = right;
                right = t;
            }
            if (index >= left && index <= right){
              topRect.state = "selected";
            }
        }
    }
}
