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

Item{
    id: panel;
    property string viewObjName;
    property string modelObjName;
    property string panelName;
    property int stackIndex;
    property alias tabStack: stack;
    function updateThumbnail(){
        grabToImage(function (result){
            parent.panelList.model.set(stackIndex, {"name" : AppWindow.pathFromUrl(stack.children[stack.currentIndex].model.folder), "imageUrl" : Qt.resolvedUrl(result.url)})
        }, Qt.size(150, 250));
    }
    function isMinimizable(){
        if (stack.children[stack.currentIndex] !== undefined)
            return stack.children[stack.currentIndex].isMinimizable();
        else return false;
    }
    function minimize(){
        stack.children[stack.currentIndex].minimize();
    }
    Component{
        id: tabUrlsComp;
        ListModel{}
    }
    function getTabUrls(){
        var newTabUrls = tabUrlsComp.createObject(null);
        for (var i = 0; i < stack.count; i++){
            newTabUrls.append({"tabUrl" : stack.children[i].model.folder.toString()});
        }
        return newTabUrls;
    }
    function initializePanel(urls){
        if (urls === undefined){
            bar.addItem(btnComp.createObject(bar));
            viewComp.createObject(stack);
        }
        else {
            for (var i = 0; i < urls.count; i++){
                bar.addItem(btnComp.createObject(bar));
                var newView = viewComp.createObject(stack);
                newView.model.folder = urls.get(i).tabUrl;
            }
        }
    }
    Item{
        id: row
        height: 25;
        width: parent.width;
        TabBar {
        id: bar
        background: Rectangle{ color: "#cccccc"}
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        Component{
            id: btnComp;
            TabButton {
                id: topBtn;
                text: if (topBtn.TabBar.index >= 0 && stack.children[topBtn.TabBar.index])
                      return AppWindow.pathFromUrl(stack.children[topBtn.TabBar.index].model.folder);
                onTextChanged: panel.updateThumbnail(); // CHANGE THIS
                width: 100;
                background: Rectangle{
                    color: topBtn.TabBar.index === bar.currentIndex ? "#ededed" : "transparent"
                    MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    //onPressed: parent.color = "#cccccc"
                    //onReleased: parent.color = "#88c4c4c4"
                   // onEntered: parent.color = topBtn.TabBar.index === bar.currentIndex ? "#ededed" : "#88c4c4c4";
                   // onExited: parent.color = topBtn.TabBar.index === bar.currentIndex ? "#ededed" : "transparent";
                    onClicked: bar.currentIndex = topBtn.TabBar.index;
                    }
                }
                Button{
                    id: closeTabButton;
                    anchors.top: parent.top;
                    anchors.margins: 4;
                    anchors.bottom: parent.bottom;
                    anchors.right: parent.right;
                    width: height * 1.1;
                    text: "\u26CC";
                    background: Rectangle{
                    color : "transparent"
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onPressed: parent.color = "#cccccc"
                        onReleased: parent.color = "#88c4c4c4";
                        onEntered: parent.color = "#88c4c4c4";
                        onExited: parent.color = "transparent"
                        onClicked: closeTabAction.trigger();
                    }
                    }
                }
                Connections{
                    target: bar
                    onCurrentIndexChanged: topBtn.background.color = topBtn.TabBar.index === bar.currentIndex ? "#ededed" : "transparent";
                }
            }
        }
        onCurrentIndexChanged:{
            panel.updateThumbnail();} // MIGHT WANNA THINK ABOUT THIS ONE
        }
        Button{
            id: newTabButton;
            anchors.left: bar.right;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            background: Rectangle{
                color: "transparent";
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#88c4c4c4"
                    onEntered: parent.color = "#88c4c4c4";
                    onExited: parent.color = "transparent";
                    onClicked: newTabAction.trigger();
                }
            }
            font.pointSize: 8;
            width: height * 1.1;
            height: parent.height;
            text: "\u2795";
        }
        Button{
            id: showPanelListButton;
            anchors.right: parent.right;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            enabled: if (panel.parent !== null) !panel.parent.panelList.opened;
                     else true;//panel.parent.panelList ? !panel.parent.panelList.opened : true;
            background: Rectangle{
                color: "transparent";
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    //onPressed: parent.color = "#cccccc"
                    //onReleased: parent.color = "#88c4c4c4"
                    //onEntered: parent.color = "#88c4c4c4";
                    //onExited: parent.color = "transparent";
                    onClicked: {
                        showSingleListAction.trigger();
                        showSingleListAction.enabled = false;
                    }
                }
            }
            action: showSingleListAction;
            font.pointSize: 8;
            width: height * 1.1;
            height: parent.height;
            text: "\u2630";
        }
        MouseArea{
            anchors.fill: parent;
            propagateComposedEvents: true;
            onClicked:{
            if (stack.count) activeView = stack.children[stack.currentIndex];
            mouse.accepted = false;
            }
        }
    }
    StackLayout{
        id: stack;
        anchors.top: row.bottom;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        currentIndex: bar.currentIndex;
        Component{
            id: viewComp;
            PanelView{
            id: view;
            }
        }
    }
    Connections{
        target: newTabAction;
        onTriggered: {
            if (activeView !== null && activeView.parent === stack)
            {
                viewComp.createObject(stack);
                bar.addItem(btnComp.createObject(bar));
                bar.setCurrentIndex(bar.count - 1);
            }
        }
    }
    Connections{
        target: closeTabAction;
        onTriggered: {
            if (activeView !== null && activeView.parent === stack)
            {
                var removedItem = stack.children[stack.currentIndex];
                removedItem.parent = null;
                removedItem.destroy();
                bar.removeItem(bar.itemAt(bar.currentIndex));
           }
        }
    }
    Connections{
        target: nextTabAction;
        onTriggered: {
            if (bar.currentIndex === bar.count - 1) bar.setCurrentIndex(0);
            else bar.setCurrentIndex(bar.currentIndex + 1);
        }
    }
    Connections{
        target: previousTabAction;
        onTriggered: {
            if (bar.currentIndex === 0) bar.setCurrentIndex(bar.count - 1);
            else bar.setCurrentIndex(bar.currentIndex - 1);
        }
    }
}
