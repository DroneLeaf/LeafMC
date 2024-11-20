/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root

    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl

    // since this file is a placeholder for the custom layer in a standard build, we will just pass through the parent insets
    QGCToolInsets {
        id:                     _toolInsets
        leftEdgeTopInset:       parentToolInsets.leftEdgeTopInset
        leftEdgeCenterInset:    parentToolInsets.leftEdgeCenterInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  parentToolInsets.bottomEdgeCenterInset
        bottomEdgeRightInset:   parentToolInsets.bottomEdgeRightInset
    }

    Canvas {
        id: mycanvas
        anchors.bottom: parent.bottom
        width: height * 2
        height: parent.height / 6
        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = 'white';
            ctx.beginPath();
            ctx.moveTo(120, 0);
            ctx.lineTo(mycanvas.width - 20, 0);
            ctx.arc(mycanvas.width - 20,20,20,-Math.PI/2, 0);
            ctx.lineTo(mycanvas.width, mycanvas.height - 20);
            ctx.arc(mycanvas.width - 20,mycanvas.height - 20,20,0, Math.PI/2);
            ctx.lineTo(20, mycanvas.height);
            ctx.arc(20,mycanvas.height - 20,20,Math.PI/2,Math.PI);
            ctx.lineTo(0, 20);
            ctx.arc(20,20,20,Math.PI,-Math.PI/2);
            ctx.lineTo(30, 0);
            ctx.stroke();
        }
    }

    Rectangle {
        id: droneLeafTitle
        anchors.bottom: mycanvas.anchors.bottom
        anchors.left: _root.left
        anchors.leftMargin: 20
        anchors.bottomMargin: mycanvas.height - 10
        width: mycanvas.width / 3
        height: 20
        radius: 20
        // text: qsTr("DroneLeaf Widget!")
        // color: "green"
    }

}
