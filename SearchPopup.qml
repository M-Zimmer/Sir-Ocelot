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
    id: popup;
    width: 600
    height: 329;
    property string startDir;
    Connections{
        target: searchStack
        onCurrentIndexChanged: {
            if (searchStack.currentIndex == 0) height = 329;
            else height = 515;
        }
    }
    color: "transparent";
    Item{
        id: topItem;
        anchors.fill: parent;
        Rectangle{
            id: topBar;
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
            color: "#9e9e9e"
            Label{
                id: caption
                text: "Search for files/directories...";
                anchors.centerIn: parent;
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
                            onClicked: popup.showMinimized();
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
                                if (popup.visibility != Window.Maximized)
                                    popup.showMaximized();
                                else
                                    popup.showNormal();
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
                            onClicked: cancelSearch.trigger();
                        }
                    }
                anchors.right: parent.right;
                width: height * 1.5;
                height: parent.height - 2;
                text: "\u26CC";
            }
        }
        Rectangle{
            color: "#cccccc"
            anchors.top: topBar.bottom;
            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            anchors.right: parent.right;
            TabBar {
                id: bar
                background: Rectangle{ color: "#c1c1c1"}
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right;
                TabButton {
                    id: setupBtn;
                    text: "Setup"
                    width: 100;
                    background: Rectangle{
                        color: setupBtn.TabBar.index === bar.currentIndex ? "#cccccc" : "transparent"
                        MouseArea{
                        anchors.fill: parent;
                        onClicked: bar.setCurrentIndex(setupBtn.TabBar.index);
                        }
                    }
                    Connections{
                        target: bar
                        onCurrentIndexChanged: setupBtn.background.color = setupBtn.TabBar.index === bar.currentIndex ? "#cccccc" : "transparent";
                    }
                }
                TabButton {
                    id: resultsBtn;
                    text: "Results"
                    width: 100;
                    enabled: false;
                    background: Rectangle{
                        color: resultsBtn.TabBar.index === bar.currentIndex ? "#cccccc" : "transparent"
                        MouseArea{
                        anchors.fill: parent;
                        onClicked: bar.setCurrentIndex(resultsBtn.TabBar.index);
                        }
                    }
                    Connections{
                        target: bar
                        onCurrentIndexChanged: resultsBtn.background.color = resultsBtn.TabBar.index === bar.currentIndex ? "#cccccc" : "transparent";
                    }
                }
            }
            StackLayout{
                id: searchStack;
                anchors.top: bar.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                currentIndex: bar.currentIndex;
                anchors.margins: 10;
                height: children[0].height;
                onCurrentIndexChanged: height = children[currentIndex].height;
                ColumnLayout{
                    anchors.left: parent.left;
                    anchors.right: parent.right;
                    RowLayout{
                        Text{
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 30;
                            text: "Pattern";
                            font.family: "Century Gothic"
                            verticalAlignment: Text.AlignBottom;
                            font.letterSpacing: 0.5
                            font.pointSize: 10;
                        } // pattern label, row 0
                        Text{
                            Layout.preferredWidth: 170;
                            Layout.preferredHeight: 30;
                            Layout.rightMargin: 10;
                            text: "Mode";
                            horizontalAlignment: Text.AlignHCenter;
                            verticalAlignment: Text.AlignBottom;
                            font.family: "Century Gothic"
                            font.letterSpacing: 0.5
                            font.pointSize: 10;
                        } // mode label, row 0
                    }
                    RowLayout{
                        TextField{
                            id: patternField;
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 30;
                            Layout.rightMargin: 10;
                            background: Rectangle{
                            border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
                            radius: 2;
                            }
                            onAccepted: {
                                startStopSearch.trigger();
                                topItem.forceActiveFocus();
                            }
                        } // pattern field, row 1
                        Item{
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 170;
                            Layout.rightMargin: 10;
                            Text{
                                id: wildCardLabel;
                                anchors.left: parent.left;
                                anchors.verticalCenter: parent.verticalCenter;
                                text: "Wildcard";
                                elide: Text.ElideRight;
                                verticalAlignment: Text.AlignVCenter;
                                horizontalAlignment: Text.AlignHCenter;
                                font.family: "Century Gothic"
                                font.letterSpacing: 0.5
                                font.pointSize: 10;
                            }
                            Switch{
                                id: modeSwitch;
                                anchors.verticalCenter: parent.verticalCenter;
                                anchors.left: wildCardLabel.right;
                                anchors.right: regExpLabel.left;
                            }
                            Text{
                                id: regExpLabel;
                                anchors.verticalCenter: parent.verticalCenter;
                                anchors.right: parent.right;
                                text: "RegEx";
                                elide: Text.ElideRight;
                                verticalAlignment: Text.AlignVCenter;
                                horizontalAlignment: Text.AlignHCenter;
                                font.family: "Century Gothic"
                                font.letterSpacing: 0.5
                                font.pointSize: 10;
                            }
                        }// switch, row 1
                    }
                    Rectangle{
                        Layout.preferredWidth: parent.width - Layout.rightMargin;
                        Layout.preferredHeight: 1;
                        Layout.topMargin: 8;
                        Layout.leftMargin: 8;
                        Layout.rightMargin: 8;
                        color: "#ff9e9e9e";
                    }
                    RowLayout{
                        Text{
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 25;
                            text: "Starting dir:";
                            font.family: "Century Gothic"
                            verticalAlignment: Text.AlignVCenter;
                            font.letterSpacing: 0.5
                            font.pointSize: 10;
                        } // starting dir label, row 2
                        Text{
                            Layout.preferredWidth: 270;
                            Layout.preferredHeight: 25;
                            text: "Depth";
                            horizontalAlignment: Text.AlignHCenter;
                            verticalAlignment: Text.AlignVCenter;
                            font.family: "Century Gothic"
                            font.letterSpacing: 0.5
                            font.pointSize: 10;
                        }// search depth slider label, row 2
                    }
                    RowLayout{
                        TextField{
                            id: startingDirField;
                            Layout.fillWidth: true;
                            Layout.preferredHeight: 30;
                            Layout.rightMargin: 10;
                            background: Rectangle{
                            border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
                            radius: 2;
                            }
                            text: startDir;
                            onAccepted:{
                                startStopSearch.trigger();
                                topItem.forceActiveFocus();
                            }
                        } // starting dir field, row 3
                        ColumnLayout{
                            Layout.rightMargin: 10;
                            RowLayout{
                                Slider{
                                        Layout.preferredWidth: 170;
                                        Layout.preferredHeight: 50;
                                        id: depthSlider;
                                        enabled:  !unlimitedDepthCheckBox.checked;
                                        from: 0;
                                        to: 100;
                                        stepSize: 1;
                                    Text{
                                        parent: depthSlider.handle;
                                        anchors.fill: parent;
                                        verticalAlignment: Text.AlignVCenter;
                                        horizontalAlignment: Text.AlignHCenter;
                                        font.family: "Century Gothic"
                                        font.letterSpacing: 0.5
                                        font.pointSize: 10;
                                        text: depthSlider.value.toString();
                                    }
                                }
                                TextField{
                                    id: depthField;
                                    Layout.maximumWidth: 70;
                                    Layout.preferredHeight: 30;
                                    enabled: customDepthCheckBox.checked;
                                }
                            }
                            RowLayout{
                                RadioButton{
                                    id: unlimitedDepthCheckBox;
                                    Layout.preferredWidth: 100;
                                    Layout.preferredHeight: 30;
                                    text: "Unlimited"
                                    MouseArea{
                                        anchors.fill: parent;
                                        onClicked: parent.toggle();
                                    }
                                }
                                RadioButton{
                                    id: customDepthCheckBox;
                                    Layout.preferredWidth: 100;
                                    Layout.preferredHeight: 30;
                                    text: "Manual"
                                    MouseArea{
                                        anchors.fill: parent;
                                        onClicked: parent.toggle();
                                    }
                                }
                            }
                        }// range slider, row 3
                    }
                    Rectangle{
                        Layout.preferredWidth: parent.width - Layout.rightMargin;
                        Layout.preferredHeight: 1;
                        Layout.topMargin: 8;
                        Layout.leftMargin: 8;
                        Layout.rightMargin: 8;
                        color: "#ff9e9e9e";
                    }
                }
                ColumnLayout{
                    Layout.preferredHeight: 400;
                    Layout.fillHeight: false;
                    Layout.fillWidth: true;
                    ListView{
                        Layout.fillHeight: true;
                        Layout.fillWidth: true;
                        property var selectedIndexes: [];
                        signal updateHighlighter();
                        signal updateHeaderSortIndicator();
                        signal requestRangeSelection(int left, int right);
                        signal requestDeselectAll();
                        signal requestSelectAll();
                        signal requestInvertSelection();
                        property int shiftAnchorIndex: 0;
                        clip: true;
                        interactive: false;
                        pixelAligned: true;
                        keyNavigationEnabled: true;
                        keyNavigationWraps: true;
                        highlightFollowsCurrentItem: false;
                        id: searchView;
                        Component{
                            id: modelComp;
                            ListModel{}
                        }
                        function initModel(){
                            var newModel = modelComp.createObject(null);
                            var pattern = patternField.text;
                            var startingDir = startingDirField.text;
                            var mode = modeSwitch.checked;
                            var depth;
                            if (unlimitedDepthCheckBox.checked) depth = -1;
                            else if (customDepthCheckBox.checked && depthField.text.length) depth = depthField.text;
                            else depth = depthSlider.value;
                            var searchResults = AppWindow.startSearch(pattern, startingDir, mode, depth); // each entry has 4 values - filename, filepath, size, lastmodified
                            for (var i = 0; i < searchResults.length; i++){
                                newModel.append({fileName : searchResults[i][0], filePath: searchResults[i][1],
                                                 fileSize : searchResults[i][2], fileModified: searchResults[i][3],
                                                 isFolder : searchResults[i][4]});
                            }
                            model = newModel;
                        }
                        function getSelectedPaths(){
                            var paths = [];
                            for (var i = 0; i < selectedIndexes.length; i++){
                                if (selectedIndexes[i]) paths.push(model.get(i).filePath);
                            }
                            return paths;
                        }
                        model: null;
                        onRequestRangeSelection: {
                            if (left > right){
                                var t = left;
                                left = right;
                                right = t;
                            }
                            for (var i = left; i <= right; i++)
                              selectedIndexes[i] = true;
                        }
                        onRequestDeselectAll: selectedIndexes = [];
                        onRequestInvertSelection: {
                            for (var i = 0; i < model.count; i++)
                              selectedIndexes[i] = !selectedIndexes[i];
                        }
                        onRequestSelectAll: {
                            for (var i = 0; i < model.count; i++)
                              selectedIndexes[i] = true;
                        }
                        delegate: SearchResultDelegate{}
                        ScrollBar.vertical: ScrollBar{
                            id: scrollBar;
                            stepSize: 0.05;
                        }
                        MouseArea{
                                anchors.fill: parent;
                                onWheel: if (wheel.angleDelta.y < 0) scrollBar.increase(); else scrollBar.decrease();
                                z: -10;
                        }
                        Connections{
                                target: selectAllAction;
                                onTriggered: {
                                    searchView.requestSelectAll();
                                }
                        }
                        Connections{
                                target: deselectAllAction;
                                onTriggered: {
                                    searchView.requestDeselectAll();
                                    searchView.shiftAnchorIndex = 0;
                                }
                        }
                        Connections{
                                target: invertSelectionAction;
                                onTriggered: {
                                    searchView.requestInvertSelection();
                                }
                        }
                    }
                }
            }
            RowLayout{
                anchors.top: searchStack.bottom;
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.margins: 10;
                Button{
                    id: startStopSearchBtn;
                    Layout.preferredHeight: 30;
                    text: "Start/Stop";
                    onClicked: {
                        startStopSearch.trigger();
                    }
                }
                Button{
                    id: cancelSearchBtn;
                    Layout.preferredHeight: 30;
                    text: "Cancel";
                    onClicked: cancelSearch.trigger();
                }
            }
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
        id: startStopSearch;
        onTriggered: {
            bar.setCurrentIndex(1);
            bar.currentItem.enabled = true;
            searchView.initModel();
        }
    }
    Action{
        id: cancelSearch;
        shortcut: "Ctrl+X";
        onTriggered: {
            popup.close();
            openSearchPopup.enabled = true;
        }
}
}
