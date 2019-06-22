import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle{
    color: "#cccccc";
    anchors.top: panelBar.bottom;
    anchors.bottom: toolBar.top;
    anchors.left: parent.left;
    anchors.right: parent.right;
    property var activeView: null;
    //property var activePanel: null; ADD THIS LATER
    property var pairedPanelsListPopup: PairedPanelsListPopup{}
    property var newShortcutPopup: NewShortcutPopup{
        id: newShortcutPopup;
    }
    Component{
        id: panelComp;
        Panel{}
    }
    PanelStack{
        id: leftPanel;
        anchors.left: parent.left;
        anchors.right: splitterBar.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        viewObjName: "leftViewObj";
        modelObjName: "leftFSModel";
    }
    Rectangle{
        id: splitterBar;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        width: 20;
        x: parent.width/2 - width/2;
        color: "#cecece";
        MouseArea{
            anchors.fill: parent;
            cursorShape: Qt.SplitHCursor;
            drag.target: parent;
            drag.axis: Drag.XAxis;
            drag.smoothed: false;
            drag.threshold: 0;
            drag.minimumX: 0;
            drag.maximumX: panelContainer.width - parent.width;
        }
        Button{
            id: pairedPanelsListButton;
            anchors.bottom: downArrow.top;
            anchors.left: parent.left;
            anchors.right: parent.right;
            height: width * 1.2;
            enabled: !panelContainer.pairedPanelsListPopup.opened;
            background: Rectangle{
                color: "transparent";
                MouseArea{
                    anchors.fill: parent;
                    hoverEnabled: true;
                    //onPressed: parent.color = "#cccccc"
                    //onReleased: parent.color = "#88c4c4c4"
                    //onEntered: parent.color = "#88c4c4c4";
                    //onExited: parent.color = "transparent";
                    onClicked: {
                        showPairedListAction.trigger();
                        showPairedListAction.enabled = false;
                    }
                }
            }
            action: showPairedListAction;
            font.pointSize: 8;
            text: "\u2630";
        }
        Button{
                id: downArrow;
                enabled: if (leftPanel.children[leftPanel.currentIndex] !== undefined && rightPanel.children[rightPanel.currentIndex] !== undefined &&
                            leftPanel.children[leftPanel.currentIndex].isMinimizable() && rightPanel.children[rightPanel.currentIndex].isMinimizable()) return true; else false;
                background:
                    Rectangle{
                        color : "transparent"
                        MouseArea{
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onPressed: parent.color = "#cccccc"
                            onReleased: parent.color = "#c4c4c4"
                            onEntered: parent.color = "#c4c4c4"
                            onExited: parent.color = "transparent"
                            onClicked: minimizeBothPanelsAction.trigger();
                        }
                    }
                font.pointSize: 12;
                anchors.bottom: parent.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                text: "\u2186";
            }
    }
    PanelStack{
        id: rightPanel;
        anchors.left: splitterBar.right;
        anchors.right: parent.right
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;
        viewObjName: "rightViewObj"
        modelObjName: "rightFSModel"
    }
    Connections{
        target: swapPanelsAction;
        onTriggered: {
            var leftChildren = new Array(leftPanel.children.length),
                rightChildren = new Array(rightPanel.children.length),
                leftCurIndex = leftPanel.currentIndex,
                rightCurIndex = rightPanel.currentIndex;                // CREATING TEMPORARY ARRAYS FOR THE LEFT AND RIGHT PANELS

            for (var i = 0; i < leftPanel.children.length; i++)
                leftChildren[i] = leftPanel.children[i];
            leftChildren.forEach(function(x) { x.parent = null;});
            for (i = 0; i < rightPanel.children.length; i++)
                rightChildren[i] = rightPanel.children[i];
            rightChildren.forEach(function(x) { x.parent = null;});     // UNPARENTING THE PANELS FROM THEIR STACKS AND STORING THEM IN THE ARRAYS

            var tmp = leftChildren[leftCurIndex];
            leftChildren[leftCurIndex] = rightChildren[rightCurIndex];
            rightChildren[rightCurIndex] = tmp;
            leftChildren.forEach(function(x) {x.parent = leftPanel;});
            rightChildren.forEach(function(x) {x.parent = rightPanel;});    // SWAPPING THE CURRENT PANELS AND REPARENTING ALL OF THE PANELS BACK

            leftPanel.currentIndex = leftCurIndex;
            rightPanel.currentIndex = rightCurIndex;    // RESTORING THE CURRENT PANEL INDEXES

            var tmpListElem = Object.assign({}, leftPanel.panelList.model.get(leftPanel.currentIndex));
            leftPanel.panelList.model.set(leftPanel.currentIndex, rightPanel.panelList.model.get(rightPanel.currentIndex));
            rightPanel.panelList.model.set(rightPanel.currentIndex, tmpListElem);   // SWAPPING THE PANEL LISTS' CURRENT ELEMENTS AS WELL
        }
    }
    Connections{
        target: swapTabsAction;
        onTriggered: {
            var tmp = leftPanel.children[leftPanel.currentIndex].tabStack.children[leftPanel.children[leftPanel.currentIndex].tabStack.currentIndex].model.folder;
            leftPanel.children[leftPanel.currentIndex].tabStack.children[leftPanel.children[leftPanel.currentIndex].tabStack.currentIndex].model.folder =
                rightPanel.children[rightPanel.currentIndex].tabStack.children[rightPanel.children[rightPanel.currentIndex].tabStack.currentIndex].model.folder;
            rightPanel.children[rightPanel.currentIndex].tabStack.children[rightPanel.children[rightPanel.currentIndex].tabStack.currentIndex].model.folder = tmp;
        }
    }
    Connections{
        target: targetPanelsAction;
        onTriggered: {
            var target, source;
            if (activeView !== null){
                if (activeView.parent.parent.parent === leftPanel){
                    source = leftPanel;
                    target = rightPanel;
                }
                else if (activeView.parent.parent.parent === rightPanel){
                    source = rightPanel;
                    target = leftPanel;
                }
            }else return;

            var currentIndex = target.currentIndex;

            var targetChildren = new Array(target.children.length);  // temporarily unparent all target's panels and store them in an array
            for (var i = 0; i < target.children.length; i++)
                if (i !== currentIndex)
                    targetChildren[i] = target.children[i];
                else targetChildren[i] = source.children[source.currentIndex]; // store source's current panel at target's current index

            var removedPanel = target.children[currentIndex]; // remove target's current panel
            removedPanel.parent = null;
            removedPanel.destroy();

            targetChildren.forEach(function(x, index) { // unparent all target's elements
                if (index !== currentIndex)
                    x.parent = null;
            });

            targetChildren.forEach(function(x, index) { // loop through targetChildren, if element is source's current panel, create a new panel,
                                                        // parent it to target and assign its name and tabUrls to source's current panel's respective properties
                                                        // else just parent element to target
                if (index === currentIndex){
                    var newPanel = panelComp.createObject(target, {"viewObjName": target.viewObjName, "modelObjName": target.modelObjName,
                                                          "panelName" : x.panelName, "stackIndex": target.count});
                    newPanel.initializePanel(x.getTabUrls());
                    target.panelList.model.set(currentIndex, source.panelList.model.get(source.currentIndex)); // assign target's list's current element to source's
                                                                                                               // respective element
                }
                else x.parent = target;
            });
        }
    }
    Connections{
        target: targetTabsAction;
        onTriggered: {
            var target, source;
            if (activeView !== null){
                if (activeView.parent.parent.parent === leftPanel){
                    source = leftPanel;
                    target = rightPanel;
                }
                else if (activeView.parent.parent.parent === rightPanel){
                    source = rightPanel;
                    target = leftPanel;
                }
            }else return;

            target.children[target.currentIndex].tabStack.children[target.children[target.currentIndex].tabStack.currentIndex].model.folder =
                source.children[source.currentIndex].tabStack.children[source.children[source.currentIndex].tabStack.currentIndex].model.folder;
        }
    }
    Connections{
        target: nextPanelAction;
        onTriggered: {
            var activeStack;
            if (activeView !== null){
                if (activeView.parent.parent.parent === leftPanel){
                    activeStack = leftPanel;
                }
                else if (activeView.parent.parent.parent === rightPanel){
                    activeStack = rightPanel;
                }

                if (activeStack.currentIndex === activeStack.count - 1)
                    activeStack.currentIndex = 0;
                else activeStack.currentIndex++;

                var currentTab = activeStack.children[activeStack.currentIndex].tabStack.currentIndex;
                activeView = activeStack.children[activeStack.currentIndex].tabStack.children[currentTab];
            }
        }
    }
    Connections{
        target: previousPanelAction;
        onTriggered: {
            var activeStack;
            if (activeView !== null){
                if (activeView.parent.parent.parent === leftPanel){
                    activeStack = leftPanel;
                }
                else if (activeView.parent.parent.parent === rightPanel){
                    activeStack = rightPanel;
                }

                if (activeStack.currentIndex === 0)
                    activeStack.currentIndex = activeStack.count - 1;
                else activeStack.currentIndex--;

                var currentTab = activeStack.children[activeStack.currentIndex].tabStack.currentIndex;
                activeView = activeStack.children[activeStack.currentIndex].tabStack.children[currentTab];
            }
        }
    }
    Connections{
        target: minimizeBothPanelsAction;
        onTriggered: {
            if (leftPanel.children[leftPanel.currentIndex] !== undefined && rightPanel.children[rightPanel.currentIndex] !== undefined &&
                            leftPanel.children[leftPanel.currentIndex].isMinimizable() && rightPanel.children[rightPanel.currentIndex].isMinimizable()){

                panelContainer.pairedPanelsListPopup.model.append(
                    {"leftPanelName" : leftPanel.children[leftPanel.currentIndex].panelName,
                    "rightPanelName" : rightPanel.children[rightPanel.currentIndex].panelName,
                    "leftPanelTabUrls" : leftPanel.children[leftPanel.currentIndex].getTabUrls(),
                    "rightPanelTabUrls" : rightPanel.children[rightPanel.currentIndex].getTabUrls(),
                    "leftPanelIndex" : leftPanel.currentIndex,
                    "rightPanelIndex" : rightPanel.currentIndex}
                    );
                leftPanel.children[leftPanel.currentIndex].minimize();
                rightPanel.children[rightPanel.currentIndex].minimize();
            }
        }
    }
    Connections{
        target: showPairedListAction;
        onTriggered: {
            panelContainer.pairedPanelsListPopup.open();
        }
    }
}
