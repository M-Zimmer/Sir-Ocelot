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
