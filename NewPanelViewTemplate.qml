import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item{
    Layout.preferredHeight: 200;
    Layout.preferredWidth: popup.width;
    property string labelText;
    property alias label: label;
    property alias view: view;
    property alias model: view.model;
    Text{
        id: label;
        anchors.top: parent.top;
        anchors.left: parent.left;
        font.family: "Century Gothic"
        font.letterSpacing: 0.5
        font.pointSize: 8;
        text: "Currently opened"
    }
    Rectangle{
        anchors.left: label.right;
        anchors.right: parent.right;
        anchors.top: parent.top;
        anchors.topMargin: 8;
        anchors.leftMargin: 8;
        height: 1;
        color: "#ff9e9e9e";
    }
    ListView{
        id: view;
        anchors.top: label.bottom;
        anchors.topMargin: 8;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        orientation: ListView.Horizontal;
        signal fillModel;
        model: ListModel{}
        delegate: NewPanelDelegate{}
        Connections{
            target: popup;
            onOpened: view.fillModel();
        }
    }
}
