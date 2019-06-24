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
    anchors.bottom: toolBar.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25
    color: "#ff9e9e9e"
    Rectangle{
        anchors.fill: parent;
        anchors.topMargin: 1;
        color: "#ffffff";
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: {parent.anchors.bottomMargin = 1;}
            onExited: { parent.anchors.bottomMargin = 0;}
        }
    }
}
