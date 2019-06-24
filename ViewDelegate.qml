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
    property alias edit: nameEdit;
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
                      case 0: return fileName;
                      case 1: return AppWindow.fileType(filePath);
                      case 2: return fileSize;
                      case 3: return fileModified;
                      }
                verticalAlignment: Text.AlignVCenter;
                leftPadding: 2;
            }

        }
        Component.onCompleted: {
            fsModel.watcher.add(filePath);
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
    state: fsView.selectedIndexes[index] ? "selected" : "deselected";
    Drag.supportedActions: Qt.MoveAction
    Drag.mimeData: {
            "text/uri-list": fileURL
    }
    Drag.onDragFinished: {
        initPressedPos.x = null;
        initPressedPos.y = null;
    }
    MouseArea{
        id: mArea;
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton | Qt.RightButton;
        hoverEnabled: true;
        onEntered: parent.color = Qt.tint(parent.color, "#1C2977F3")
        onExited: parent.color = index % 2 == 0 ? "#ededed" : "#f4f4f4"
        onPositionChanged:
            if (pressedButtons & Qt.LeftButton){
              if (parent.initPressedPos.x === null && parent.initPressedPos.y === null){
                parent.initPressedPos.x = mouse.x;
                parent.initPressedPos.y = mouse.y;
              }
              else if (!parent.Drag.active &&
                        Math.sqrt(Math.pow(mouse.x - parent.initPressedPos.x, 2) +
                                    Math.pow(mouse.y - parent.initPressedPos.y, 2)) >= 7){
                    parent.Drag.active = true;
                    parent.grabToImage(function(result) {
                    parent.Drag.imageSource = result.url;
                    parent.Drag.mimeData = {
                        "text/uri-list": fsModel.getSelectedRole("fileURL").reduce(function (acc, val){
                                                                        return acc + val + "\r\n";
                                                                    }, "")
                    };
                    dArea.enabled = false;
                    parent.Drag.startDrag();
                });
              }
            }
        onReleased: {
            initPressedPos.x = null;
            initPressedPos.y = null;
            dArea.enabled = true;
        }
        onPressed: {
                    topRect.ListView.view.currentIndex = index;
                    if (mouse.modifiers & Qt.ControlModifier){
                       parent.state = parent.state === "selected" ? "deselected" : "selected";
                       fsView.selectedIndexes[index] = parent.state === "selected";
                    }
                    else if (mouse.modifiers & Qt.ShiftModifier){
                       fsView.requestDeselectAll();
                       fsView.requestRangeSelection(index, fsView.shiftAnchorIndex);
                    }else {
                      if (mouse.button === Qt.LeftButton)
                        fsView.requestDeselectAll();
                      parent.state = "selected";
                      fsView.selectedIndexes[index] = true;

                    }


                    if (!(mouse.modifiers & Qt.ShiftModifier)){
                      fsView.shiftAnchorIndex = index;
                    }

                    if (mouse.button === Qt.RightButton){
                        AppWindow.openContextMenu(fsModel.getSelectedRole("filePath"));
                    }
        }
        onDoubleClicked: viewOpenAction.trigger();
    }
    TextField{
        id: nameEdit
        height: parent.height;
        y: 0;
        x: 16;
        visible: focus;
        background: Rectangle{
            //border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
            border.width: 1;
          //  radius: 2;
        }
        onAccepted: {
            AppWindow.fileRename(filePath, text);
            nameEdit.focus = false;
        }
        Component.onCompleted: {
            nameEdit.width = Qt.binding(function(){ return repeater.itemAt(0).contentWidth + 20});
            nameEdit.text = Qt.binding(function(){ return repeater.itemAt(0).text});
        }
    }
    Connections{
        target: fsView
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
