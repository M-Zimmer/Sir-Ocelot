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
import QtQuick.Layouts 1.12

StackLayout{
        id: panelStack;
        currentIndex: 0;
        property string viewObjName;
        property string modelObjName;
        property var panelList: PanelListPopup { }
        property var newPanelPopup: NewPanelPopup { }
        property var searchPopup: SearchPopup { }
        function addPanel(name, urls){
            var newPanel = panelComp.createObject(panelStack, {"viewObjName": viewObjName, "modelObjName": modelObjName, "panelName" : name, "stackIndex": count});
            newPanel.initializePanel(urls);
            panelList.model.append({"name" : "", "imageUrl" : "", "minimized" : false});
            currentIndex = count - 1;
        }
        function removePanel(index){
            var tabUrlsModel = children[index].getTabUrls();
            var tabUrlsArr = [];
            for (var i = 0; i < tabUrlsModel.count; i++)
                tabUrlsArr.push(tabUrlsModel.get(i).tabUrl);
            AppWindow.addToRecentlyClosed(children[index].panelName, tabUrlsArr);
            var removedPanel = children[index];
            removedPanel.parent = null;
            panelList.model.remove(index);
            removedPanel.destroy();
            if (index <= currentIndex ) {
                console.log("true", index, currentIndex);
            currentIndex--;
                console.log(currentIndex);}
        }
        Component.onCompleted:{
            addPanel("Default");
        }
    }
