import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    id: topRect;
    color: "#dddddd"
    width: parent.width
    height: 20;
    Rectangle {
        color: index % 2 == 0 ? "#ededed" : "#f4f4f4"
        anchors.fill: parent;
        anchors.bottomMargin: 1
        Row{
            anchors.fill: parent;
            Image{
                id: icon
                source: AppWindow.requestImageSource(decoration)
                sourceSize.height: 16
                sourceSize.width: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            Repeater{
                model: window.columnCount;
                Text {
                    width: {
                        if (index != 0)
                          return window.columnWidths[index]
                        else return window.columnWidths[index] - icon.implicitWidth
                    }
                    height: parent.height;
                    elide: Text.ElideRight;
                    text: AppWindow.fileData(filePath, index);
                    verticalAlignment: Text.AlignVCenter;
                    leftPadding: 2;
                }

            }
        }
    }
    MouseArea{
        anchors.fill: parent;
        onClicked: topRect.ListView.view.currentIndex = index;
    }
}
