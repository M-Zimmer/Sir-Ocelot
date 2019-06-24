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
import QtQuick.Controls 2.12

Button{
    background: Rectangle{
                    color: "transparent";
                }
    MouseArea{
        anchors.fill: parent;
        hoverEnabled: true;
        onPressed: parent.background.color = "#cccccc"
        onReleased: parent.background.color = "#ffbcbcbc";
        onEntered: parent.background.color = "#ffbcbcbc";
        onExited: parent.background.color = "transparent";
        onClicked: action.trigger(parent);
    }
    height: parent.height - 4;
}
