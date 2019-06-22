import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ItemDelegate{
    height: parent.height;
    width: 150;
    ColumnLayout{
        anchors.fill: parent;
        anchors.margins: 8;
        Item{
            Layout.preferredHeight: 0.1 * parent.height;
            Layout.preferredWidth: parent.width;
            Text {
                id: popupItemText;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                elide: Text.ElideRight;
                text: name;
            }
        }
        Rectangle{
            clip: true;
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            border.color: "#ff9e9e9e";
            color: "transparent";
            Column{
                anchors.fill: parent;
                spacing: 0;
                Repeater{
                    model: tabUrls;
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
    onClicked: {
        popup.parent.addPanel(name, tabUrls);
        popup.close();
    }
}
