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

MenuBar{
        id: menuBar
        anchors.top: topBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 25
        spacing: 1
        background: Rectangle{
                color: "#cccccc"
            }
        font.family: "Arial"
        font.weight: Font.Thin
        MenuBarItem{
            id: fileMenu
            height: 25
            anchors.left: parent.left
            menu:
                Menu{
                    title: qsTr("Files")
                    MenuItem{
                        action: newDirectoryAction;
                    }
                    MenuItem{
                        action: newShortcutAction;
                    }
                    MenuItem{
                        action: mkdirAction;
                    }
                    MenuSeparator{}
                    MenuItem{
                        action: propertiesAction;
                    }
                    MenuSeparator{}
                    MenuItem{
                        action: exitAction;
                    }
                }
        }
        MenuBarItem{
            id: markMenu;
            height: 25
            anchors.left: fileMenu.right
            menu:
                Menu{
                    title: qsTr("Mark")
                    MenuItem{
                        action: selectAllAction;
                    }
                    MenuItem{
                        action: deselectAllAction;
                    }
                    MenuItem{
                        action: invertSelectionAction;
                    }
                }
        }
        MenuBarItem{
            id: commandsMenu
            height: 25
            anchors.left: markMenu.right;
            menu:
                Menu{
                    title: qsTr("Commands")
                    MenuItem{
                        action:  openSearchPopup;
                    }
                    MenuSeparator{}
                    MenuItem{
                        action: swapPanelsAction;
                    }
                    MenuItem{
                        action: swapTabsAction;
                    }
                    MenuItem{
                        action: targetTabsAction;
                    }
                    MenuItem{
                        action: targetPanelsAction;
                    }
                    MenuItem{
                        action: runTerminalAction;
                    }
                }
        }
        MenuBarItem{
            id: panelsMenu;
            height: 25
            anchors.left: commandsMenu.right;
            menu:
                Menu{
                    title: qsTr("Panels")
                    MenuItem{
                        action:  newPanelAction;
                    }
                    MenuItem{
                        action:  closePanelAction;
                    }
                    MenuSeparator{}
                    MenuItem{
                        action:  setFavoriteAction;
                    }
                    MenuItem{
                        action:  nextPanelAction;
                    }
                    MenuItem{
                        action:  previousPanelAction;
                    }
                    MenuItem{
                        action:  minimizePanelAction;
                    }
                    MenuItem{
                        action:  minimizeBothPanelsAction;
                    }
                    MenuSeparator{}
                    MenuItem{
                        action:  showSingleListAction;
                    }
                    MenuItem{
                        action:  showPairedListAction;
                    }
                }
        }
        MenuBarItem{
            id: tabsMenu;
            height: 25
            anchors.left: panelsMenu.right;
            menu:
                Menu{
                    title: qsTr("Tabs")
                    MenuItem{
                        action:  newTabAction;
                    }
                    MenuItem{
                        action:  closeTabAction;
                    }
                    MenuSeparator{}
                    MenuItem{
                        action:  nextTabAction;
                    }
                    MenuItem{
                        action:  previousTabAction;
                    }
                    MenuSeparator{}
                    MenuItem{
                        action:  forwardAction;
                    }
                    MenuItem{
                        action:  backAction;
                    }
                    MenuItem{
                        action:  upAction;
                    }
                }
        }
        MenuBarItem{
            id: showMenu;
            height: 25
            anchors.left: tabsMenu.right;
            menu:
                Menu{
                    title: qsTr("Show")
                    MenuItem{
                        action:  sortByNameAction;
                    }
                    MenuItem{
                        action:  sortByExtAction;
                    }
                    MenuItem{
                        action:  sortBySizeAction;
                    }
                    MenuItem{
                        action:  sortByTimeAction;
                    }
                }
        }
        MenuBarItem{
            height: 25
            anchors.right: parent.right
            text: qsTr("About");
            action: aboutAction;
        }

    }
