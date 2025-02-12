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
    property bool   hideTakeoff: leafMode.startsWith("RC Stabilized") || leafMode.startsWith("LEARNING INNER") || leafMode == "Refined Tuning Outer - Collect Data"
    property bool isLeafArmed: _guidedController._activeVehicle.leafFCArmed

    text:       _guidedController.takeoffTitle
    iconSource: "/res/takeoff.svg"
    visible:    true
    enabled:    !_guidedController._fcTookOff && !hideTakeoff && isLeafArmed
    actionID:   _guidedController.actionTakeoff
}
