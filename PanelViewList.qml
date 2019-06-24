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
import Qt.labs.folderlistmodel 2.12
import FWatcher 1.0

ListView{
        id: fsView;
        property var selectedIndexes: [];
        property var pathHistory: [];
        property int pathHistoryPos: 0;
        signal updateHighlighter();
        signal updateHeaderSortIndicator();
        signal requestRangeSelection(int left, int right);
        signal requestDeselectAll();
        signal requestSelectAll();
        signal requestInvertSelection();
        property int shiftAnchorIndex: 0;
        anchors.topMargin: 5;
        anchors.top: middleSection.bottom;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        clip: true
        interactive: false;
        pixelAligned: true;
        keyNavigationEnabled: true;
        keyNavigationWraps: true;
        highlightFollowsCurrentItem: false;
        NewFilePopup{
            id: newFilePopup;
        }
        model: FolderListModel{ // use a static number to prevent laggy creation and removal of delegates
                                // will have to come up with a way to dynamically load the needed info into those fixed delegates
                                // think of how 8-bit games used to scroll back in the day
            id: fsModel;
            objectName: modelObjName;
            showDirsFirst: true;
            showHidden: true;
            folder: AppWindow.urlFromPath(AppWindow.getDrives()[0]);
            rootFolder: AppWindow.getRootFolder(folder);
            sortField: FolderListModel.Name;
            property var watcher: QuickFileWatcher{
                id: watcher
                onFileChanged: {
                    watcher.clear();
                    var oldPath = fsModel.folder;
                    fsModel.folder = "file:/";
                    fsModel.folder = oldPath;
                }
            }
            function getSelectedRole(role){
                var paths = [];
                for (var i = 0; i < fsView.selectedIndexes.length; i++){
                    if (fsView.selectedIndexes[i]){ paths.push(get(i, role)); }
                }
                return paths;
            }
            onFolderChanged: { // compare upper-case strings only
                if (folder.toString().toLocaleUpperCase() !== fsView.pathHistory[fsView.pathHistoryPos].toString().toLocaleUpperCase()){
                    if (fsView.pathHistoryPos !== fsView.pathHistory.length - 1)
                        fsView.pathHistory = fsView.pathHistory.slice(0, fsView.pathHistoryPos + 1);
                    fsView.pathHistory.push(folder);
                    fsView.pathHistoryPos = fsView.pathHistory.length - 1;
                }
                fsView.currentIndex = -1; fsView.shiftAnchorIndex = 0; fsView.selectedIndexes = [];
            }
        }
        onRequestRangeSelection: {
            if (left > right){
                var t = left;
                left = right;
                right = t;
            }
            for (var i = left; i <= right; i++)
              selectedIndexes[i] = true;
        }
        onRequestInvertSelection: {
            for (var i = 0; i < fsModel.count; i++)
              selectedIndexes[i] = !selectedIndexes[i];
        }
        onRequestDeselectAll: selectedIndexes = [];
        onRequestSelectAll: {
            for (var i = 0; i < fsModel.count; i++)
              selectedIndexes[i] = true;
        }
        Connections{
            target: propertiesAction;
            onTriggered: if (activeView === scope){
                AppWindow.openContextMenu(fsModel.getSelectedRole("filePath"), "properties");
            }
        }
        Connections{
                target: viewOpenAction;
                onTriggered: if (activeView === scope){
                    //var path = fsView.currentItem.propFilePath; WHY
                    if (fsModel.isFolder(fsView.currentIndex)){
                        fsModel.folder = fsModel.get(fsView.currentIndex, "fileURL");
                    }
                    else Qt.openUrlExternally(fsModel.get(fsView.currentIndex, "fileURL"));
                }
        }
        Connections{
                target: copyAction;
                onTriggered: if (activeView === scope){
                    if (fsModel.objectName === leftPanel.modelObjName)
                        AppWindow.fileCopy(fsModel.getSelectedRole("filePath"), AppWindow.pathFromUrl(AppWindow.getModel(rightPanel.modelObjName).folder));
                    else if (fsModel.objectName === rightPanel.modelObjName)
                        AppWindow.fileCopy(fsModel.getSelectedRole("filePath"), AppWindow.pathFromUrl(AppWindow.getModel(leftPanel.modelObjName).folder));
                }
        }
        Connections{
                target: moveAction;
                onTriggered: if (activeView === scope){
                    if (fsModel.objectName === leftPanel.modelObjName)
                        AppWindow.fileMove(fsModel.getSelectedRole("filePath"), AppWindow.pathFromUrl(AppWindow.getModel(rightPanel.modelObjName).folder));
                    else if (fsModel.objectName === rightPanel.modelObjName)
                        AppWindow.fileMove(fsModel.getSelectedRole("filePath"), AppWindow.pathFromUrl(AppWindow.getModel(leftPanel.modelObjName).folder));
                }
        }
        Connections{
                target: deleteAction;
                onTriggered: if (activeView === scope){
                    AppWindow.fileDelete(fsModel.getSelectedRole("filePath"));
                }
        }
        Connections{
                target: renameAction;
                onTriggered: {
                    if (activeView === scope){
                      fsView.currentItem.edit.focus = true;
                    }
                }
        }
        Connections{
                target: newDirectoryAction;
                onTriggered: {
                    if (activeView === scope){
                        AppWindow.makeNewFile(AppWindow.pathFromUrl(model.folder), 0);
                    }
                }
        }
        Connections{
                target: newShortcutAction;
                onTriggered: {
                    if (activeView === scope){
                        newShortcutPopup.fileName = model.getSelectedRole("filePath")[0];
                        newShortcutPopup.show();
                        newShortcutPopup.height -= borderlessDeltaSize.height;
                        newShortcutPopup.width -= borderlessDeltaSize.width;
                    }
                }
        }
        Connections{
                target: mkdirAction;
                onTriggered: {
                    if (activeView === scope){
                        newFilePopup.open();
                    }
                }
        }
        Connections{
            target: openSearchPopup;
            onTriggered: {
                if (activeView === scope){
                    panel.parent.searchPopup.startDir = pathField.text;
                    panel.parent.searchPopup.show();
                    panel.parent.searchPopup.height -= borderlessDeltaSize.height;
                    panel.parent.searchPopup.width -= borderlessDeltaSize.width;
                }
            }
        }
        Connections{
            target: runTerminalAction;
            onTriggered: {
                if (activeView === scope){
                    var startingDir = AppWindow.pathFromUrl(model.folder);
                    AppWindow.runApp("cmd.exe /C start cmd.exe /K cd " + startingDir);
                }
            }
        }
        Connections{
            target: newPanelAction;
            onTriggered: {
                if (activeView === scope){
                    panel.parent.newPanelPopup.open();
                }
            }
        }
        Connections{
            target: closePanelAction;
            onTriggered: {
                if (activeView === scope){
                    panel.parent.removePanel(panel.stackIndex);
                }
            }
        }
        Connections{
            target: minimizePanelAction;
            onTriggered: {
                if (activeView === scope){
                    minimizePanelButton.minimize();
                }
            }
        }
        Connections{
            target: showSingleListAction;
            onTriggered: {
                if (activeView === scope){
                    panel.parent.panelList.open();
                }
            }
        }
        Connections{
            target: setFavoriteAction;
            onTriggered: {
                if (activeView === scope){
                    var tabUrlsModel = panel.getTabUrls();
                    var tabUrlsArr = [];
                    for (var i = 0; i < tabUrlsModel.count; i++)
                      tabUrlsArr.push(tabUrlsModel.get(i).tabUrl);
                    AppWindow.addToFavorites(panel.panelName, tabUrlsArr);
                }
            }
        }
        Connections{
            target: forwardAction;
            onTriggered: {
                if (activeView === scope){
                    if (fsView.pathHistoryPos !== fsView.pathHistory.length - 1)
                        fsModel.folder = fsView.pathHistory[++fsView.pathHistoryPos];
                }
            }
        }
        Connections{
            target: backAction;
            onTriggered: {
                if (activeView === scope){
                    if (fsView.pathHistoryPos !== 0)
                        fsModel.folder = fsView.pathHistory[--fsView.pathHistoryPos];
                }
            }
        }
        Connections{
            target: upAction;
            onTriggered: {
                if (activeView === scope){
                    if (fsModel.folder.toString().toLocaleUpperCase() !== fsModel.rootFolder.toString().toLocaleUpperCase()){
                        fsModel.folder = fsModel.parentFolder;
                    }
                }
            }
        }
        Connections{
            target: sortByNameAction;
            onTriggered: {
                if (activeView === scope){
                    model.sortField = FolderListModel.Name;
                    model.sortReversed = !model.sortReversed;
                    fsView.updateHeaderSortIndicator();
                }
            }
        }
        Connections{
            target: sortByExtAction;
            onTriggered: {
                if (activeView === scope){
                    model.sortField = FolderListModel.Type;
                    model.sortReversed = !model.sortReversed;
                    fsView.updateHeaderSortIndicator();
                }
            }
        }
        Connections{
            target: sortBySizeAction;
            onTriggered: {
                if (activeView === scope){
                    model.sortField = FolderListModel.Size;
                    model.sortReversed = !model.sortReversed;
                    fsView.updateHeaderSortIndicator();
                }
            }
        }
        Connections{
            target: sortByTimeAction;
            onTriggered: {
                if (activeView === scope){
                    model.sortField = FolderListModel.Time;
                    model.sortReversed = !model.sortReversed;
                    fsView.updateHeaderSortIndicator();
                }
            }
        }
        Connections{
                target: selectAllAction;
                onTriggered: {
                    if (activeView === scope){
                        fsView.requestSelectAll();
                    }
                }
        }
        Connections{
                target: deselectAllAction;
                onTriggered: {
                    if (activeView === scope){
                        fsView.requestDeselectAll();
                        fsView.shiftAnchorIndex = 0;
                    }
                }
        }
        Connections{
                target: invertSelectionAction;
                onTriggered: {
                    if (activeView === scope){
                        fsView.requestInvertSelection();
                    }
                }
        }
        Connections{
                target: setUrlAction;
                onTriggered:{
                    if (activeView === scope){
                        if (source && source.pathUrl){
                            model.folder = source.pathUrl;
                        }
                        else model.folder = AppWindow.getRootFolder(AppWindow.urlFromPath(dataSourceBox.currentText));
                    }
                }
        }
        header: ViewHeader{z: 4}
        headerPositioning: ListView.OverlayHeader;
        delegate: ViewDelegate{}
        ScrollBar.vertical: ScrollBar{
            id: scrollBar;
            stepSize: 0.05;
        }
        MouseArea{
                anchors.fill: parent;
                onWheel: if (wheel.angleDelta.y < 0) scrollBar.increase(); else scrollBar.decrease();
                z: -10;
        }
        DropArea{
        id: dArea;
        anchors.fill: parent;
        keys: "text/uri-list";
        onDropped: { // REFACTOR FILE OPERATION FUNCTIONS, EXTEND THE DROP AREA TO THE ENTIRE PANEL, PREVENT COPY/MOVING FROM A PANEL TO ITSELF, WHIP OUT CONTEXT MENUS
            var selection = [];
            if (drop.action === Qt.MoveAction){
                selection = drop.urls.map(function(x) {return AppWindow.pathFromUrl(x)});
                AppWindow.fileMove(selection, AppWindow.pathFromUrl(fsModel.folder));
            }
            else if (drop.action === Qt.CopyAction){
                selection = drop.urls.map(function(x) {return AppWindow.pathFromUrl(x)});
                AppWindow.fileCopy(selection, AppWindow.pathFromUrl(fsModel.folder));
            }
        }
        }
        Component.onCompleted: pathHistory.push(fsModel.folder);
    }
