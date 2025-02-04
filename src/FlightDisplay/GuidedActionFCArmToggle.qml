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
    property bool leafArmOnly: leafMode.startsWith("RC Stabilized") || leafMode.startsWith("LEARNING INNER")
    property bool isLeafArmed: _guidedController._activeVehicle.leafFCArmed

    text:       leafArmOnly ? "Arm" : _guidedController.armFCTitle
    iconSource: "/res/action.svg"
    visible:    (!isLeafArmed) && leafMode.length > 0
    enabled:    true
    actionID:   _guidedController.actionFCArm
}
