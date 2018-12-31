import QtQuick 2.9
import QtQuick.Window 2.2

Window{
    id: derp
    signal openNewWindow()
        width: 800
    height: 800
    visible: true
    color: "blue"
    MouseArea{
    anchors.fill: parent
    onClicked: derp.openNewWindow();
    }
}
