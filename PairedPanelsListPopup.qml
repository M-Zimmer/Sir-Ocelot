// Copyright 2018-2019 Max Mazur
/*
    This file is part of Sir Ocelot File Manager.

    Sir Ocelot File Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Sir Ocelot File Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Sir Ocelot File Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

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
