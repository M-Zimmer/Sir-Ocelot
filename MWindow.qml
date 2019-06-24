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

Window{
    id: window
    visible: true
    width: initialSize.width;
    height: initialSize.height;

    Component.onCompleted: {
        borderlessDeltaSize.width = width - initialSize.width;
        borderlessDeltaSize.height = height - initialSize.height;
        width = initialSize.width;
        height = initialSize.height;
    }
    color: "transparent";
    property size initialSize: Qt.size(Screen.width/1.5, Screen.height/1.5);
    property size borderlessDeltaSize;
    property int columnCount: 4
    property var columnWidths: [200, 100, 125, 150]
    AboutPopup{
        id: aboutPopup;
    }
    TopBar{
        id: topBar;
    }
    MainMenuBar{
        id: menuBar
    }
    PanelBar{
        id: panelBar;
    }
    PanelContainer{
        id: panelContainer;
    }
    /*CmdBar{
        id: cmdBar;
    }*/
    MWindowToolBar{
        id: toolBar;
    }
    Action{
        id: propertiesAction;
        text: "Properties"
        shortcut: "Alt+Return"
    }
    Action{
        id: viewOpenAction;
        text: qsTr("View/Open (F3)")
        shortcut: "F3"
    }
    Action{
        id: copyAction;
        text: qsTr("Copy (F5)")
        shortcut: "F5";
    }
    Action{
        shortcut: "Ctrl+C";
        onTriggered: copyAction.trigger();
    }
    Action{
        id: moveAction;
        text: qsTr("Move (F6)")
        shortcut: "F6";
    }
    Action{
        id: pasteAction;
        shortcut: "Ctrl+V";
    }
    Action{
        id: renameAction;
        text: "&Rename";
        shortcut: "F2"
    }
    Action{
        id: deleteAction;
        text: qsTr("Delete (F8)");
        shortcut: "Delete"
    }
    Action{
        shortcut: "F8"
        onTriggered: deleteAction.trigger();
    }
    Action{
        id: newDirectoryAction;
        text: "Create Directory"
    }
    Action{
        id: newShortcutAction
        text: "Create Shortcut"
    }
    Action{
        id: mkdirAction;
        text: qsTr("Make file/folder\n (F7)")
        shortcut: "F7"
    }
    Action{
        id: openSearchPopup;
        text: "Search...";
        shortcut: "Ctrl+F";
    }
    Action{
        id: swapPanelsAction;
        text: "Swap Panels";
    }
    Action{
        id: swapTabsAction;
        text: "Swap Tabs";
    }
    Action{
        id: targetPanelsAction;
        text: "Target = Source (Panels)";
    }
    Action{
        id: targetTabsAction;
        text: "Target = Source (Tabs)";
    }
    Action{
        id: runTerminalAction;
        text: "Run Terminal"
    }
    Action{
        id: newPanelAction;
        text: "New Panel";
    }
    Action{
        id: closePanelAction;
        text: "Close Panel";
    }
    Action{
        id: setFavoriteAction;
        text: "Set Panel As Favorite";
    }
    Action{
        id: nextPanelAction;
        text: "Next Panel";
    }
    Action{
        id: previousPanelAction;
        text: "Previous Panel";
    }
    Action{
        id: minimizePanelAction;
        text: "Minimize Panel";
    }
    Action{
        id: minimizeBothPanelsAction;
        text: "Minimize Both Panels";
    }
    Action{
        id: showSingleListAction;
        text: "Show Panel List";
    }
    Action{
        id: showPairedListAction;
        text: "Show Paired Panels List";
    }
    Action{
        id: newTabAction;
        text: "New Tab";
    }
    Action{
        id: closeTabAction;
        text: "Close Tab";
    }
    Action{
        id: nextTabAction;
        text: "Next Tab";
    }
    Action{
        id: previousTabAction;
        text: "Previous Tab";
    }
    Action{
        id: forwardAction;
        text: "Forward";
    }
    Action{
        id: backAction;
        text: "Back";
    }
    Action{
        id: upAction;
        text: "Up";
    }
    Action{
        id: sortByNameAction;
        text: "Sort By Name";
    }
    Action{
        id: sortByExtAction;
        text: "Sort By Extension";
    }
    Action{
        id: sortBySizeAction
        text: "Sort By Size";
    }
    Action{
        id: sortByTimeAction;
        text: "Sort By Last Modified";
    }
    Action{
        id: aboutAction;
        text: qsTr("About");
        onTriggered: {
            aboutPopup.show();
            aboutPopup.height -= borderlessDeltaSize.height;
            aboutPopup.width -= borderlessDeltaSize.width;
        }
    }
    Action{
        id: selectAllAction;
        text: "Select All";
        shortcut: "Ctrl+A";
    }
    Action{
        id: deselectAllAction;
        text: "Deselect All";
        shortcut: "Shift+Ctrl+A";
    }
    Action{
        id: invertSelectionAction;
        text: "Invert Selection";
        shortcut: "Ctrl+I";
    }
    Action{
        id: setUrlAction;
    }
    Action{
        id: exitAction;
        shortcut: "Alt+F4"
        text: qsTr("Exit (Alt+F4)")
        onTriggered: Qt.quit();
    }
}
