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
import StdPaths 1.0

Rectangle{
    anchors.top: menuBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 35
    color: "#ff9e9e9e"
    Rectangle{
        anchors.fill: parent;
        anchors.topMargin: 1;
        anchors.bottomMargin: 1;
        color: "#cccccc";
        Row{
            anchors.fill: parent;
            spacing: 5;
            topPadding: 2;
            PanelBarButton{
                id: selectAllButton;
                action: selectAllAction;
            }
            PanelBarButton{
                id: deselectAllButton;
                action: deselectAllAction;
            }
            PanelBarButton{
                id: invertSelectionButton;
                action: invertSelectionAction;
            }
            PanelBarButton{
                id: terminalButton;
                action: runTerminalAction;
            }
            PanelBarButton{
                id: desktopButton;
                action: setUrlAction;
                text: "Desktop";
                property url pathUrl: AppWindow.getStandardPathUrl(QStandardPaths.DesktopLocation);
            }
            PanelBarButton{
                id: documentsButton;
                action: setUrlAction;
                text: "Documents";
                property url pathUrl: AppWindow.getStandardPathUrl(QStandardPaths.DocumentsLocation);
            }
            PanelBarButton{
                id: rootButton;
                action: setUrlAction;
                text: "Root";
            }
        }
    }
}
