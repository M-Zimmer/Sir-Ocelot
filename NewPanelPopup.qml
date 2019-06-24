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
    background:  Rectangle{
                   color: "#dddddd"
                 }
    padding: 6;
    anchors.centerIn: parent;
    implicitWidth: parent.width;
    implicitHeight: parent.height;
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }
    Component{
        id: tabUrlsComp;
        ListModel{}
    }
    ColumnLayout{
        anchors.fill: parent;
        Item{
            id: caption;
            Layout.preferredHeight: 30;
            Layout.fillWidth: true;
            Text{
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.verticalCenter: parent.verticalCenter;
                text: "New panel";
                font.family: "Century Gothic"
                font.letterSpacing: 0.5
                font.pointSize: 12;
            }
            Button{
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
                anchors.right: parent.right;
                anchors.top: parent.top;
                anchors.bottom: parent.bottom;
                width: parent.height;
                text: "\u26CC";
            }
        }
        ScrollView{
            id: scrollView;
            clip: true;
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            contentHeight: container.height;
            contentWidth: container.width;
            ColumnLayout{
                id: container;
                NewPanelViewTemplate{
                    id: currentlyOpened;
                    label.text: "Currently opened";
                    Connections{
                        target: currentlyOpened.view;
                        onFillModel: {
                            currentlyOpened.model.clear();
                            var tabUrls;
                            var i;
                            var name = "";
                            for (i = 0; i < leftPanel.count; i++){
                                tabUrls = leftPanel.children[i].getTabUrls();
                                name = "Left Panel %1 - %2";
                                currentlyOpened.model.append({"name" : name.arg(i+1).arg(leftPanel.children[i].panelName), "tabUrls" : tabUrls });
                            }
                            for (i = 0; i < rightPanel.count; i++){
                                tabUrls = rightPanel.children[i].getTabUrls();
                                name = "Right Panel %1 - %2";
                                currentlyOpened.model.append({"name" : name.arg(i+1).arg(rightPanel.children[i].panelName), "tabUrls" : tabUrls });
                            }
                        }
                    }
                }
                NewPanelViewTemplate{
                    id: favoritePanels;
                    label.text: "Favorite";
                    Connections{
                        target: favoritePanels.view;
                        onFillModel: {
                            favoritePanels.model.clear();
                            var favPanels = AppWindow.favoritePanels();
                            for (var i = 0; i < favPanels.length; i++){
                                var newTabUrls = tabUrlsComp.createObject(null);
                                for (var j = 0; j < favPanels[i][1].length; j++){
                                    newTabUrls.append({"tabUrl" : favPanels[i][1][j]});
                                }
                                favoritePanels.model.append({"name" : favPanels[i][0], "tabUrls" : newTabUrls });
                            }
                            var tmp = favoritePanels.view.model;
                            favoritePanels.view.model = undefined;
                            favoritePanels.view.model = tmp;
                        }
                    }
                }
                NewPanelViewTemplate{
                    id: recentlyClosed;
                    label.text: "Recently closed";
                    Connections{
                        target: recentlyClosed.view;
                        onFillModel: {
                            recentlyClosed.model.clear();
                            var recPanels = AppWindow.recentlyClosedPanels();
                            for (var i = 0; i < recPanels.length; i++){
                                var newTabUrls = tabUrlsComp.createObject(null);
                                for (var j = 0; j < recPanels[i][1].length; j++){
                                    newTabUrls.append({"tabUrl" : recPanels[i][1][j]});
                                }
                                recentlyClosed.model.append({"name" : recPanels[i][0], "tabUrls" : newTabUrls });
                            }
                            var tmp = recentlyClosed.view.model;
                            recentlyClosed.view.model = undefined;
                            recentlyClosed.view.model = tmp;
                        }
                    }
                }
                Item{
                    id: fromPathItem;
                    Layout.preferredHeight: 120;
                    Layout.preferredWidth: popup.width;
                    function createPanelFromInput(){
                        var newTabUrl = tabUrlsComp.createObject(null);
                        var newUrl = AppWindow.urlFromPath(newPathField.text);
                        newTabUrl.append({"tabUrl" : newUrl.toString()});
                        popup.parent.addPanel("Custom", newTabUrl);
                    }
                    Text{
                        id: fromPathLabel;
                        anchors.top: parent.top;
                        anchors.left: parent.left;
                        font.family: "Century Gothic"
                        font.letterSpacing: 0.5
                        font.pointSize: 8;
                        text: "From path"
                    }
                    Rectangle{
                        anchors.left: fromPathLabel.right;
                        anchors.right: parent.right;
                        anchors.top: parent.top;
                        anchors.topMargin: 8;
                        anchors.leftMargin: 8;
                        height: 1;
                        color: "#ff9e9e9e";
                    }
                    Text{
                        id: newPathLabel
                        text: "New path:";
                        anchors.bottom: newPathField.top;
                        anchors.bottomMargin: 8;
                        anchors.left: newPathField.left;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        leftPadding: 2;
                        font.pointSize: 10;
                    }
                    TextField{
                        id: newPathField;
                        background: Rectangle{
                            border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
                            radius: 2;
                        }
                        anchors.verticalCenter: parent.verticalCenter;
                        anchors.verticalCenterOffset: 20;
                        anchors.left: parent.left;
                        anchors.right: okButton.left;
                        anchors.leftMargin: 8;
                        anchors.rightMargin: 8;
                        height: 25;
                        onAccepted: {
                            parent.createPanelFromInput();
                            popup.close();
                        }
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
                                   fromPathItem.createPanelFromInput();
                                   popup.close();
                                }
                            }
                        }
                        anchors.top: newPathField.top;
                        anchors.right: cancelButton.left;
                        font.pointSize: 10;
                        width: 75;
                        height: 25;
                        text: "OK";
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
                        anchors.top: newPathField.top;
                        anchors.right: parent.right;
                        font.pointSize: 10;
                        width: 75;
                        height: 25;
                        text: "Cancel";
                    }
                }
            }
        }
    }
}

