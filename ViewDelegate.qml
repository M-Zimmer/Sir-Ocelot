import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.12

//"#1C2977F3";
Rectangle {
    id: topRect;
    color: index % 2 == 0 ? "#ededed" : "#f4f4f4"
    width: parent.width
    height: 19;
    property alias edit: nameEdit;
    property string propFilePath: filePath;
    Row{
        anchors.fill: parent;
        Image{
            id: icon
            asynchronous: true;
            source: AppWindow.requestImageSource(decoration);
            sourceSize.height: 16
            sourceSize.width: 16
            anchors.verticalCenter: parent.verticalCenter
        }
        Repeater{
            id: repeater
            model: window.columnCount;
            Text {
                width: {
                    if (index != 0)
                        return window.columnWidths[index]
                    else return window.columnWidths[index] - icon.implicitWidth
                }
                height: parent.height;
                elide: Text.ElideRight;
                text: fsModel.fileData(filePath, index);
                verticalAlignment: Text.AlignVCenter;
                leftPadding: 2;
            }

        }
    }
    Rectangle{
        id: selectedVisRect;
        anchors.fill: parent;
        color: "#1C2977F3";
    }
    states: [
        State {
            name: "selected"
            PropertyChanges { target: selectedVisRect; visible: true }
        },
        State {
            name: "deselected"
            PropertyChanges { target: selectedVisRect; visible: false }
        }
    ]
    state: fsView.selectedIndexes[index] ? "selected" : "deselected";
    MouseArea{
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton | Qt.RightButton;
        hoverEnabled: true;
        onEntered: parent.color = Qt.tint(parent.color, "#1C2977F3")
        onExited: parent.color = index % 2 == 0 ? "#ededed" : "#f4f4f4"
        onClicked: {
                    topRect.ListView.view.currentIndex = index;
                    if (mouse.modifiers & Qt.ControlModifier){
                       parent.state = parent.state === "selected" ? "deselected" : "selected";
                       fsView.selectedIndexes[index] = parent.state === "selected";
                    }
                    else if (mouse.modifiers & Qt.ShiftModifier){
                       fsView.requestDeselectAll();
                       fsView.requestRangeSelection(index, fsView.shiftAnchorIndex);
                    }else {
                      fsView.requestDeselectAll();
                      parent.state = "selected";
                      fsView.selectedIndexes[index] = true;

                    }


                    if (!(mouse.modifiers & Qt.ShiftModifier)){
                      fsView.shiftAnchorIndex = index;
                    }

                    if (mouse.button === Qt.RightButton)
                        AppWindow.openContextMenu(filePath);
        }
        onDoubleClicked: viewOpenAction.trigger();
    }
    TextField{
        id: nameEdit
        height: parent.height;
        y: 0;
        x: 16;
        visible: focus;
        background: Rectangle{
            //border.color: parent.hovered ? "#ff9e9e9e" : "#889e9e9e";
            border.width: 1;
          //  radius: 2;
        }
        onAccepted: {
            fsModel.fileRename(fsModel.index(fsView.currentIndex,0), text);
            nameEdit.focus = false;
        }
        Component.onCompleted: {
            nameEdit.width = Qt.binding(function(){ return repeater.itemAt(0).contentWidth + 20});
            nameEdit.text = Qt.binding(function(){ return repeater.itemAt(0).text});
        }
    }
    Connections{
        target: fsView
        onRequestDeselectAll: if (topRect.state === "selected"){ topRect.state = "deselected";}
        onRequestSelectAll: if (topRect.state !== "selected"){ topRect.state = "selected";}
        onRequestRangeSelection: {
            if (left > right){
                var t = left;
                left = right;
                right = t;
            }
            if (index >= left && index <= right){
              topRect.state = "selected";
            }
        }
    }
}
