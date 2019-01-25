import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.12

Rectangle {
    id: topRect;
    property var modelObj: ListView.view.model
    color: index % 2 == 0 ? "#ededed" : "#f4f4f4"
    width: parent.width
    height: 19;
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
                text: modelObj.fileData(filePath, index);
                verticalAlignment: Text.AlignVCenter;
                leftPadding: 2;
            }

        }
    }
    MouseArea{
        anchors.fill: parent;
        hoverEnabled: true;
        onEntered: parent.color = Qt.tint(parent.color, "#1C2977F3")
        onExited: parent.color = index % 2 == 0 ? "#ededed" : "#f4f4f4"
        onClicked: topRect.ListView.view.currentIndex = index;
    }
}
