import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FSModel 1.0
import QtQml.Models 2.12

//"#ff9e9e9e"
Rectangle{
    color: "#ededed";
    Rectangle{
        id: topSection
        color: "#ededed";
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 25;
        Row{
            anchors.fill: parent;
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
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: parent.color = "#E2E2E2";
                        onExited: parent.color = "transparent";
                        onClicked: dataSourceBox.popup.open();
                    }
                }
                indicator.width: 20;
                indicator.height: 15;
                model: ["C", "D", "E"]
                width: height * 1.8;
                height: parent.height;
                leftInset: 2;
                topInset: 2;
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
                text: "find"
            }
            Text{
                height: parent.height;
                width: minimizePanelButton.x - x;
                text: AppWindow.storageInfo(fsView.model.root());
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
                leftPadding: 2;
            }
        }
        Button{
            id: minimizePanelButton;
            anchors.right: closePanelButton.left
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
            height: parent.height;
            text: "\u268A";
        }
        Button{
            id: closePanelButton;
            anchors.right: parent.right;
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
            height: parent.height;
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
           // anchors.bottomMargin: 1
            color: "#ededed";
            Row{
                anchors.fill: parent;
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
                    font.pointSize: 20;
                    width: height * 2;
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
                    font.pointSize: 20;
                    width: height * 2;
                    height: parent.height;
                    text: "\u2192";
                }
                Rectangle{
                    height: parent.height
                    width: parent.width - x - 5;
                    color: "#ff9e9e9e"
                    Rectangle{
                        anchors.fill: parent;
                        color: "#ffffff";
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onEntered: {parent.anchors.margins = 1;}
                            onExited: { parent.anchors.margins = 0;}
                        }
                    }
                }
            }
        }
    }
    ListView{
        id: fsView;
        objectName: viewObjName;
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
        model: FileSystemModel{
            objectName: modelObjName;
        }
        ItemSelectionModel{
            id: selectionModel
            model: fsView.model;
        }
        header: ViewHeader{z: 4}
        headerPositioning: ListView.OverlayHeader;
        delegate: ViewDelegate{}
        highlight:
            Rectangle{
              color: "#1C2977F3";
              anchors.fill: ListView.view.currentItem;
              z: 3;
            }
        ScrollBar.vertical: ScrollBar{
            id: scrollBar;
            stepSize: 0.05;
        }
        MouseArea{
                anchors.fill: parent;
                onWheel: if (wheel.angleDelta.y < 0) scrollBar.increase(); else scrollBar.decrease();
                z: -10;
        }
    }
}
