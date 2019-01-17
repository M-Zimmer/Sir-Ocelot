import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FSModel 1.0

    // fs model role names: ((258, "fileName")  (2, "edit")     (259, "filePermissions")
    //                       (3, "toolTip")     (0, "display")      (257, "filePath")
    //                       (1, "fileIcon")    (1, "decoration")   (4, "statusTip")    (5, "whatsThis"))

Rectangle{
    color: "#dddddd";
    anchors.left: parent.left;
    anchors.right: splitterBar.left;
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;
    TableView{
        id: view
        property var columnWidthFactors: [0.25, 0.25, 0.25, 0.25]
        columnWidthProvider: function (column) { return parent.width * columnWidthFactors[column] }
        rowHeightProvider: function (row) { return 17; }
        anchors.fill: parent
        clip: true
        //rowSpacing: 5
        model: FileSystemModel{
            objectName: "leftFSModel";
        }
        delegate: Rectangle {
            color: "transparent"
            Text {
                text: display;
            }
        }
    }
    //onWidthChanged: view.forceLayout()
    MouseArea{
        anchors.fill: parent;
        onClicked: {
            parent.color = rightPanel.color == "#dddddd" ? "#dddddd" : parent.color;
            rightPanel.color = "#c6c6c6";
        }
    }
}
