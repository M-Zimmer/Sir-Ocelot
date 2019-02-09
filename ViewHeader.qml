import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    id: topRect;
    color: "#9e9e9e";
    width: parent.width;
    height: 20;
    Rectangle{
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
                Component.onCompleted: width = window.columnWidths[index]
                Text{
                    id: headerColumnText;
                    anchors.left: parent.left;
                    anchors.top: parent.top;
                    anchors.bottom: parent.bottom;
                    anchors.right: headerSplitter.left;
                    text: fsModel.headerData(index);
                    elide: Text.ElideRight;
                    verticalAlignment: Text.AlignVCenter;
                    leftPadding: 2
                    onWidthChanged: {
                        if (headerSplitterMouseArea.drag.active){
                            window.columnWidths[index] = width; window.columnWidths = window.columnWidths.map(function(x) {return x});
                            AppWindow.updateOtherHeader(topRect.parent.parent.objectName);
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
        }
    }
}
