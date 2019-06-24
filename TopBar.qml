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

Rectangle{
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32
    color: "#9e9e9e"
    Image{
        id: icon;
        source: AppWindow.urlFromPath("./icon.ico");
        sourceSize.width: 32;
        sourceSize.height: 32;
        anchors.left: parent.left;
    }
    Label{
        id: caption
        text: "Sir Ocelot File Manager";
        anchors.left: icon.left;
        anchors.leftMargin: 40;
        anchors.verticalCenter: parent.verticalCenter;
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
                    onClicked: window.showMinimized();
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
                        if (window.visibility != Window.Maximized)
                            window.showMaximized();
                        else
                            window.showNormal();
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
                    onClicked: exitAction.trigger();
                }
            }
        anchors.right: parent.right;
        width: height * 1.5;
        height: parent.height - 2;
        text: "\u26CC";
    }
}
