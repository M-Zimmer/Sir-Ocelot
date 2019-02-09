import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FSModel 1.0
import QtQml.Models 2.12

//"#ff9e9e9e"
FocusScope{
    id: scope;
    property alias model: fsModel;
Rectangle{
    id: topRect
    color: "#ededed";
    anchors.fill: parent;
    focus: true;
    Rectangle{
        id: topSection
        color: "#ededed";
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 25;
        Row{
            anchors.left: parent.left;
            anchors.top: parent.top;
            anchors.topMargin: 2;
            anchors.right: minimizePanelButton.left;
            anchors.bottom: parent.bottom;
            anchors.leftMargin: 2;
            anchors.rightMargin: 2
            Button{
                id: newPanelButton;
                background: Rectangle{
                    color: "transparent";
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onPressed: parent.color = "#cccccc"
                        onReleased: parent.color = "#88c4c4c4"
                        onEntered: parent.color = "#88c4c4c4";
                        onExited: parent.color = "transparent";
                    }
                }
                font.pointSize: 8;
                width: height * 1.1;
                height: parent.height;
                text: "\u2795";
            }
            ComboBox{
                id: dataSourceBox;
                background: Rectangle{
                    color: "transparent"
                    border.color: "#ff9e9e9e";
                    radius: 2
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: parent.color = "#E2E2E2";
                        onExited: parent.color = "transparent";
                        onClicked: dataSourceBox.popup.opened ? dataSourceBox.popup.close() : dataSourceBox.popup.open();
                    }
                }
                indicator.width: 20;
                indicator.height: 15;
                model: ["C", "D", "E"]
                width: height * 1.8;
                height: parent.height;
                leftInset: 2;
                bottomInset: 2;
                rightInset: 2;
            }
            Button{
                id: directoryLogButton;
                background: Rectangle{
                    color: "transparent";
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onPressed: parent.color = "#cccccc"
                        onReleased: parent.color = "#88c4c4c4"
                        onEntered: parent.color = "#88c4c4c4";
                        onExited: parent.color = "transparent";
                    }
                }
                font.pointSize: 8;
                width: height * 1.5;
                height: parent.height;
                text: "log"
            }
            Button{
                id: searchButton;
                background: Rectangle{
                    color: "transparent";
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onPressed: parent.color = "#cccccc"
                        onReleased: parent.color = "#88c4c4c4"
                        onEntered: parent.color = "#88c4c4c4";
                        onExited: parent.color = "transparent";
                    }
                }
                font.pointSize: 8;
                width: height * 1.5;
                height: parent.height;
                rightInset: 2;
                text: "find"
            }
            Rectangle{
                id: storageInfoRect
                anchors.top: parent.top;
                anchors.bottom: parent.bottom;
                width: minimizePanelButton.x - x - 5;

                color: scope.focus ? Qt.lighter("#f4f4f4") : "#f4f4f4"
                border.color: "#ff9e9e9e"
                radius: 5;
            Text{
                anchors.fill: parent
                id: storageInfoText
                text: AppWindow.storageInfo(fsModel.rootPath);
                elide: Text.ElideMiddle;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
                leftPadding: 2;
            }
            }
        }
        Button{
            id: minimizePanelButton;
            anchors.right: closePanelButton.left;
            anchors.top: parent.top;
            anchors.topMargin: 2;
            anchors.bottom: parent.bottom;
            background: Rectangle{
                color : "transparent"
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#88c4c4c4";
                    onEntered: parent.color = "#88c4c4c4";
                    onExited: parent.color = "transparent"
                }
            }
            width: height * 1.1;
            text: "\u268A";
        }
        Button{
            id: closePanelButton;
            anchors.top: parent.top;
            anchors.topMargin: 2;
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
            anchors.rightMargin: 2;
            background: Rectangle{
                color : "transparent"
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#88c4c4c4";
                    onEntered: parent.color = "#88c4c4c4";
                    onExited: parent.color = "transparent"
                }
            }
            width: height * 1.1;
            text: "\u26CC";
        }
    }


    Rectangle{
        id: middleSection
        anchors.topMargin: 2;
        anchors.top: topSection.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        height: 25;
        color: "#ff9e9e9e";
        Rectangle{
            id: visMidRect;
            anchors.fill: parent;
            color: "#f4f4f4"
            Row{
                anchors.fill: parent;
                anchors.topMargin: 2;
                anchors.leftMargin: 2;
                Button{
                    id: backButton;
                    background: Rectangle{
                        color: "transparent";
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onPressed: parent.color = "#cccccc"
                            onReleased: parent.color = "#88c4c4c4"
                            onEntered: parent.color = "#88c4c4c4";
                            onExited: parent.color = "transparent";
                        }
                    }
                    font.pointSize: 14;
                    width: height * 1.1;
                    height: parent.height;
                    text: "\u2190";
                }
                Button{
                    id: forwardButton;
                    background: Rectangle{
                        color: "transparent";
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onPressed: parent.color = "#cccccc"
                            onReleased: parent.color = "#88c4c4c4"
                            onEntered: parent.color = "#88c4c4c4";
                            onExited: parent.color = "transparent";
                        }
                    }
                    font.pointSize: 14;
                    width: height * 1.1;
                    height: parent.height;
                    text: "\u2192";
                }
                Button{
                    id: upButton;
                    background: Rectangle{
                        color: "transparent";
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onPressed: parent.color = "#cccccc"
                            onReleased: parent.color = "#88c4c4c4"
                            onEntered: parent.color = "#88c4c4c4";
                            onExited: parent.color = "transparent";
                            onClicked: fsModel.cdUp();
                        }
                    }
                    font.pointSize: 14;
                    width: height * 1.1;
                    height: parent.height;
                    text: "\u2191";
                    rightInset: 2;
                }
                TextField{
                    id: pathField;
                    background: Rectangle{
                        border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
                        radius: 2;
                    }
                    height: parent.height
                    width: parent.width - x - 2;
                    text: fsModel.rootPath;
                    onAccepted: fsModel.rootPath = text;
                    Connections{
                        target: fsModel;
                        onRootPathChanged: pathField.text = path;
                    }
                }
            }
        }
    }
    ListView{
        id: fsView;
        objectName: viewObjName;
        property var selectedIndexes: [];
        signal updateHighlighter();
        signal requestRangeSelection(int left, int right);
        signal requestDeselectAll();
        signal requestSelectAll();
        property int shiftAnchorIndex: 0;
        anchors.topMargin: 5;
        anchors.top: middleSection.bottom;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        clip: true
        boundsBehavior: Flickable.StopAtBounds;
        synchronousDrag: true;
        pixelAligned: true;
        keyNavigationEnabled: true;
        keyNavigationWraps: true;
        highlightFollowsCurrentItem: false;
        model: FileSystemModel{ // use a static number to prevent laggy creation and removal of delegates
                                // will have to come up with a way to dynamically load the needed info into those fixed delegates
                                // think of how 8-bit games used to scroll back in the day
            id: fsModel;
            objectName: modelObjName;
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
        onRequestDeselectAll: selectedIndexes = [];
        onRequestSelectAll: {
            for (var i = 0; i < fsModel.getRowCount(); i++)
              selectedIndexes[i] = true;
        }
        Connections{
                target: viewOpenAction;
                onTriggered: if (scope.activeFocus){
                    var path = fsView.currentItem.propFilePath;
                    if (AppWindow.isDir(path)) fsModel.rootPath = path;
                    else Qt.openUrlExternally(path);
                }
        }
        Connections{
                target: copyAction;
                onTriggered: if (scope.activeFocus){
                    if (fsModel.objectName === leftPanel.modelObjName)
                        fsModel.fileCopy(fsView.selectedIndexes, AppWindow.getRootPathOfModel(rightPanel.modelObjName));
                    else if (fsModel.objectName === rightPanel.modelObjName)
                        fsModel.fileCopy(fsView.selectedIndexes, AppWindow.getRootPathOfModel(leftPanel.modelObjName));
                }
        }
        Connections{
                target: moveAction;
                onTriggered: if (scope.activeFocus){
                    if (fsModel.objectName === leftPanel.modelObjName)
                        fsModel.fileMove(fsView.selectedIndexes, AppWindow.getRootPathOfModel(rightPanel.modelObjName));
                    else if (fsModel.objectName === rightPanel.modelObjName)
                        fsModel.fileMove(fsView.selectedIndexes, AppWindow.getRootPathOfModel(leftPanel.modelObjName));
                }
        }
        Connections{
                target: deleteAction;
                onTriggered: if (scope.activeFocus){
                    fsModel.fileDelete(fsView.selectedIndexes);
                }
        }
        Connections{
                target: renameAction;
                onTriggered: {
                    if (scope.activeFocus){
                      fsView.currentItem.edit.focus = true;
                    }
                }
        }
        Connections{
                target: selectAllAction;
                onTriggered: {
                    if (scope.activeFocus){
                        fsView.requestSelectAll();
                    }
                }
        }
        Connections{
                target: deselectAllAction;
                onTriggered: {
                    if (scope.activeFocus){
                        fsView.requestDeselectAll();
                        fsView.shiftAnchorIndex = 0;
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
        Connections{
            target: fsModel;
            onRootPathChanged: {fsView.currentIndex = -1; fsView.shiftAnchorIndex = 0; fsView.selectedIndexes = [];}
        }
    }
    MouseArea{
        id: topMouseArea
        anchors.fill: parent;
        propagateComposedEvents: true
        onClicked: mouse.accepted = false;
        onPressed: {scope.focus = true; mouse.accepted = false;}
        onReleased: mouse.accepted = false;
        onDoubleClicked: mouse.accepted = false;
        onPositionChanged: mouse.accepted = false;
        onPressAndHold: mouse.accepted = false;
    }
}
}
