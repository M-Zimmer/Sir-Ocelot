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

ItemDelegate{
    height: parent.height;
    width: 150;
    ColumnLayout{
        anchors.fill: parent;
        anchors.margins: 8;
        Item{
            Layout.preferredHeight: 0.1 * parent.height;
            Layout.preferredWidth: parent.width;
            Text {
                id: popupItemText;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                elide: Text.ElideRight;
                text: name;
            }
        }
        Rectangle{
            clip: true;
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            border.color: "#ff9e9e9e";
            color: "transparent";
            Column{
                anchors.fill: parent;
                spacing: 0;
                Repeater{
                    model: tabUrls;
                    delegate: Rectangle{
                        width: parent.width;
                        height: 25;
                        color: "#f4f4f4";
                        Text{
                           anchors.fill: parent;
                           verticalAlignment: Text.AlignVCenter;
                           horizontalAlignment: Text.AlignHCenter;
                           elide: Text.ElideMiddle;
                           text: AppWindow.pathFromUrl(tabUrl);
                        }
                    }
                }
            }
        }
    }
    onClicked: {
        popup.parent.addPanel(name, tabUrls);
        popup.close();
    }
}
