import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import FSModel 1.0

    // fs model role names: ((258, "fileName")  (2, "edit")     (259, "filePermissions")
    //                       (3, "toolTip")     (0, "display")      (257, "filePath")
    //                       (1, "fileIcon")    (1, "decoration")   (4, "statusTip")    (5, "whatsThis"))

// #ededed
// #f4f4f4


Rectangle{
    color: "#f4f4f4";
    anchors.left: parent.left;
    anchors.right: splitterBar.left;
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;
    ListView{
        id: leftView
        objectName: "leftViewObj"
        anchors.fill: parent
        clip: true
        focus: true;
        model: FileSystemModel{
            objectName: "leftFSModel";
        }
        header: ViewHeader{}
        delegate: ViewDelegate{}
        highlight:
            Rectangle{
              color: "#1C2977F3";
              z: 1;
            }
    }
}
