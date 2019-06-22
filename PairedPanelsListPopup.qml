import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup{
    id: popup;
    y: parent.height - height;
    width: parent.width;
    height: 200;
    background: Rectangle{ color: "#cccccc"}
    property var model: ListModel{
        id: popupModel;
    }
    property var count: model.count;
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        NumberAnimation { property: "y"; from: parent.height - height + 15; to: parent.height - height; }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
        NumberAnimation { property: "y"; from: parent.height - height; to: parent.height - height + 15; }
    }
    ListView{
        id: popupList;
        anchors.fill: parent;
        orientation: ListView.Horizontal;
        model: popupModel;
        delegate: PairedPanelsListDelegate{}
    }
    onClosed: showPairedListAction.enabled = true;
}
