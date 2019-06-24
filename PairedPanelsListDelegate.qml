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
    width: 300;
    Rectangle{
        color: "transparent";
        anchors.fill: parent;
        border.color: "#ff9e9e9e";
        border.width: 2;
        radius: 5;
        GridLayout{
            columns: 2;
            columnSpacing: 5;
            rowSpacing: 0;
            anchors.fill: parent;
            anchors.margins: 16;
            Item{
                Layout.preferredHeight: 0.1 * parent.height;
                Layout.preferredWidth: parent.width/2;
                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    elide: Text.ElideRight;
                    text: leftPanelName;
                }
            }
            Item{
                Layout.preferredHeight: 0.1 * parent.height;
                Layout.preferredWidth: parent.width/2;
                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    elide: Text.ElideRight;
                    text: rightPanelName;
                }
            }
            Rectangle{
                clip: true;
                Layout.fillHeight: true;
                Layout.preferredWidth: parent.width/2;
                border.color: "#ff9e9e9e";
                color: "transparent";
                Column{
                    anchors.fill: parent;
                    spacing: 0;
                    Repeater{
                        model: leftPanelTabUrls;
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
            Rectangle{
                clip: true;
                Layout.fillHeight: true;
                Layout.preferredWidth: parent.width/2;
                border.color: "#ff9e9e9e";
                color: "transparent";
                Column{
                    anchors.fill: parent;
                    spacing: 0;
                    Repeater{
                        model: rightPanelTabUrls;
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
    }
    onClicked: {
        leftPanel.panelList.model.set(leftPanelIndex, {"minimized" : false});
        leftPanel.currentIndex = leftPanelIndex;
        rightPanel.panelList.model.set(rightPanelIndex, {"minimized" : false});
        rightPanel.currentIndex = rightPanelIndex;
        popup.model.remove(index);
        popup.close();
    }
}
