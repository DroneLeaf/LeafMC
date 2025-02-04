/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QGroundControl.FlightDisplay 1.0

GuidedToolStripAction {
    property string leafMode: _guidedController._activeVehicle.leafMode
    property bool showTraj: leafMode.startsWith("Refined")
    
    text:       _guidedController.executeCircleTrajTitle
    iconSource: "/res/circle-arrows.svg"
    visible:    leafMode.length > 0 && showTraj
    enabled:    true
    actionID:   _guidedController.actionExecuteCircleTraj
}
