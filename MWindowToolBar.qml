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
import QtQuick.Layouts 1.12

ToolBar {
        background: Rectangle{
            color: "#dddddd"
        }
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: implicitHeight + 5
    RowLayout {
        anchors.fill: parent
        ToolButton {
            Layout.fillWidth: true
            action: viewOpenAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: copyAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: moveAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: mkdirAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: deleteAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
        ToolSeparator{}
        ToolButton {
            Layout.fillWidth: true
            action: exitAction;
            Rectangle{
                anchors.fill: parent
                color: "transparent"
            }
        }
    }
}
