import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Qt.labs.folderlistmodel 2.12
import FWatcher 1.0

//"#ff9e9e9e"
FocusScope{
    id: scope;
    property alias model: fsView.model;
    function isMinimizable(){
        return minimizePanelButton.enabled;
    }
    function minimize(){
        minimizePanelButton.minimize();
    }

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
                        onClicked: newPanelAction.trigger();
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
                model: AppWindow.getDrives();
                width: height * 1.8;
                height: parent.height;
                leftInset: 2;
                bottomInset: 2;
                rightInset: 2;
                onActivated: {
                    console.log(AppWindow.urlFromPath(textAt(index)));
                    fsView.model.folder = AppWindow.urlFromPath(textAt(index));
                   // fsView.model.rootFolder = AppWindow.urlFromPath(textAt(index));
                }
                Connections{
                    target: dataSourceBox.popup;
                    onAboutToShow: dataSourceBox.model = AppWindow.getDrives();
                }
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
                        onClicked: {
                            openSearchPopup.trigger();
                            openSearchPopup.enabled = false;
                        }
                    }
                }
                 // if (panel.parent !== null && panel.parent.searchPopup) !panel.parent.searchPopup.opened;
                     //else true;
                action: openSearchPopup;
                font.pointSize: 16;
                width: height * 1.5;
                height: parent.height;
                rightInset: 2;
                text: "\u26B2"
            }
            Rectangle{
                id: storageInfoRect
                anchors.top: parent.top;
                anchors.bottom: parent.bottom;
                width: minimizePanelButton.x - x - 5;

                color: activeView === scope ? Qt.lighter("#f4f4f4") : "#f4f4f4"
                border.color: "#ff9e9e9e"
                radius: 5;
            Text{
                anchors.fill: parent
                id: storageInfoText
                text: AppWindow.storageInfo(AppWindow.pathFromUrl(model.folder));
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
            function minimize(){
                           panel.parent.panelList.model.set(panel.stackIndex, {"minimized" : true});

                           var offset = 1;

                           if (panel.stackIndex === panel.parent.count - 1) {
                            while (panel.parent.panelList.isMinimized(panel.stackIndex - offset)) ++offset;
                            panel.parent.currentIndex = panel.stackIndex - offset;
                           }
                           else {
                            while (panel.parent.panelList.isMinimized(panel.stackIndex + offset)) ++offset;
                            panel.parent.currentIndex = panel.stackIndex + offset;
                           }
            }
            enabled: {
                var k = 0;
                if (panel.parent !== null){
                for (var i = 0; i < panel.parent.panelList.count; i++){
                    if (panel.parent.panelList.isMinimized(i)) k++
                }
                if (k >= panel.parent.panelList.count - 1) return false;
                else return true;
                }else return false;
            }
            background: Rectangle{
                color : "transparent"
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onPressed: parent.color = "#cccccc"
                    onReleased: parent.color = "#88c4c4c4";
                    onEntered: parent.color = "#88c4c4c4";
                    onExited: parent.color = "transparent"
                    onClicked: minimizePanelAction.trigger();
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
                    onClicked: closePanelAction.trigger();
                }
            }
            enabled: panel.parent && panel.parent.count > 1 ? true : false;
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
                            onClicked: backAction.trigger();
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
                            onClicked: forwardAction.trigger();
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
                            onClicked: upAction.trigger();
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
                    onAccepted: model.folder = AppWindow.urlFromPath(text, AppWindow.pathFromUrl(model.folder));
                    text: AppWindow.pathFromUrl(model.folder);
                    Button{
                        id: directoryLogButton;
                        background: Rectangle{
                                color: pathField.background.border.color;
                                Rectangle{
                                    anchors.fill: parent;
                                    anchors.topMargin: 1;
                                    anchors.bottomMargin: 1;
                                    color: "white";
                                    MouseArea{
                                        anchors.fill: parent;
                                        hoverEnabled: true;
                                        onClicked: historyPopup.open();
                                        onPressed: parent.color = "#cccccc"
                                        onReleased: parent.color = "#88ffffff"
                                        onEntered: parent.color = "#88ffffff";
                                        onExited: parent.color = "white";
                                    }
                                }
                        }
                        enabled: historyPopup.opened ? false : true;
                        PathHistoryPopup{ id: historyPopup;}
                        font.pointSize: 12;
                        anchors.top: parent.top;
                        anchors.right: addToFavoritesButton.left;
                        width: height * 1.2;
                        height: parent.height;
                        text: "\u22C1"
                        Connections{
                            target: historyPopup;
                            onAboutToShow: {
                                historyPopup.model.clear();
                                for (var i = 0; i < fsView.pathHistory.length; i++){
                                    historyPopup.model.append({"url": Qt.resolvedUrl(fsView.pathHistory[i]), "path" : AppWindow.pathFromUrl(fsView.pathHistory[i])});
                                }
                            }
                        }
                    }
                    Button{
                        id: addToFavoritesButton;
                        background: Rectangle{
                            color: "white";
                            border.color: pathField.background.border.color;
                            MouseArea{
                                anchors.fill: parent;
                                hoverEnabled: true;
                                onClicked: setFavoriteAction.trigger();
                                onPressed: parent.color = "#cccccc"
                                onReleased: parent.color = "#88c4c4c4"
                                onEntered: parent.color = "#88c4c4c4";
                                onExited: parent.color = "white";
                            }
                        }
                        font.pointSize: 12;
                        anchors.top: parent.top;
                        anchors.right: parent.right;
                        width: height * 1.2;
                        height: parent.height;
                        text: "\u2606";
                    }
                }
            }
        }
    }

    PanelViewList{
        id: fsView;
        objectName: viewObjName;
    }

    MouseArea{
        id: topMouseArea
        anchors.fill: parent;
        propagateComposedEvents: true
        onClicked: mouse.accepted = false;
        onPressed: {activeView = scope; mouse.accepted = false;}
        onReleased: mouse.accepted = false;
        onDoubleClicked: mouse.accepted = false;
        onPositionChanged: mouse.accepted = false;
        onPressAndHold: mouse.accepted = false;
    }
}
}
