import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Qt.labs.folderlistmodel 2.12

Rectangle{
    id: topRect;
    color: "#9e9e9e";
    width: parent.width;
    height: 20;
    Rectangle{
        id: innerRect;
        color: "#ededed";
        anchors.fill: parent;
        //anchors.bottomMargin: 1
        Repeater{
            id: repeater;
            objectName: "repeaterObj";
            model: window.columnCount
            anchors.fill: parent;
            Item{
                width: 1 //placeholder value, didn't assign to window.columnWidths[index] to prevent binding loops
                height: parent.height;
                parent: index != 0 ? repeater.itemAt(index - 1).children[1] : parent;
                Component.onCompleted: width = window.columnWidths[index];
                Text{
                    id: headerColumnText;
                    property bool sortIndicator: false;
                    property string columnText: switch(index){
                                                case 0: return "Name";
                                                case 1: return "Type";
                                                case 2: return "Size";
                                                case 3: return "Last modified";
                                                }
                    anchors.left: parent.left;
                    anchors.top: parent.top;
                    anchors.bottom: parent.bottom;
                    anchors.right: headerSplitter.left;
                    text: columnText;
                    elide: Text.ElideRight;
                    verticalAlignment: Text.AlignVCenter;
                    leftPadding: 2
                    onWidthChanged: {
                        if (headerSplitterMouseArea.drag.active){
                            window.columnWidths[index] = width; window.columnWidths = window.columnWidths.map(function(x) {return x});
                            AppWindow.updateOtherHeader(topRect.parent.parent.objectName);
                        }
                    }
                    Rectangle{
                        id: hoverRect;
                        color: Qt.tint("#AAededed", "#1C2977F3");
                        anchors.fill: parent;
                        visible: false;
                        z: parent.z - 1;
                    }
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        onEntered: hoverRect.visible = true;
                        onExited: hoverRect.visible = false;
                        onClicked: {
                            if (parent.text.includes("Name")) sortByNameAction.trigger();
                            else if (parent.text.includes("Type")) sortByNameAction.trigger();
                            else if (parent.text.includes("Size")) sortByNameAction.trigger();
                            else if (parent.text.includes("Last modified")) sortByNameAction.trigger();
                        }
                    }
                    Connections{
                        target: fsView;
                        onUpdateHeaderSortIndicator: {
                            switch(index){
                                case 0: headerColumnText.sortIndicator = (fsModel.sortField === FolderListModel.Name); break;
                                case 1: headerColumnText.sortIndicator = (fsModel.sortField === FolderListModel.Type); break;
                                case 2: headerColumnText.sortIndicator = (fsModel.sortField === FolderListModel.Size); break;
                                case 3: headerColumnText.sortIndicator = (fsModel.sortField === FolderListModel.Time); break;
                            }
                            var str = headerColumnText.columnText;
                            if (headerColumnText.sortIndicator)
                                if (fsModel.sortReversed) str = str.concat(' \u22C1');
                                else str = str.concat(' \u22C0');
                            headerColumnText.text = str;
                        }
                    }
                }
                Rectangle{
                    id: headerSplitter;
                    visible: index == window.columnCount - 1 ? false : true;
                    width: 1;
                    anchors.top: parent.top;
                    anchors.bottom: parent.bottom;
                    x: parent.width - width;
                    color: "#9e9e9e";
                    Item{
                        id: headerSplitterHitbox
                        x: -width/2;
                        width: parent.width + 5;
                        height: parent.height;
                        MouseArea{
                            id: headerSplitterMouseArea
                            anchors.fill: headerSplitterHitbox;
                            cursorShape: Qt.SplitHCursor;
                            hoverEnabled: true;
                            onEntered: topMouseArea.cursorShape = cursorShape;
                            onExited: topMouseArea.cursorShape = MouseArea.cursorShape;
                            drag.target: headerSplitter;
                            drag.axis: Drag.XAxis;
                            drag.smoothed: false;
                            drag.threshold: 0;
                            drag.minimumX: headerColumnText.x;
                        }
                    }
                }
            }
            Component.onCompleted: fsView.updateHeaderSortIndicator();
        }
    }
}
