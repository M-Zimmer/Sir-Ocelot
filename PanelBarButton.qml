import QtQuick 2.12
import QtQuick.Controls 2.12

Button{
    background: Rectangle{
                    color: "transparent";
                }
    MouseArea{
        anchors.fill: parent;
        hoverEnabled: true;
        onPressed: parent.background.color = "#cccccc"
        onReleased: parent.background.color = "#ffbcbcbc";
        onEntered: parent.background.color = "#ffbcbcbc";
        onExited: parent.background.color = "transparent";
        onClicked: action.trigger(parent);
    }
    height: parent.height - 4;
}
