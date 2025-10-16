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
    property string leafStatus: _guidedController._activeVehicle.leafStatus
    property string leafMissionStatus: _guidedController._activeVehicle.leafMissionStatus
    
    property bool   show_button: leafMode.startsWith("LeafSDK Mission")
    property bool   disable_button: leafMissionStatus.startsWith("MISSION STATUS: IDLE") || leafMissionStatus.startsWith("MISSION STATUS: READY")

    text:       _guidedController.cancelTitle
    message:    _guidedController.cancelMessage
    iconSource: "/res/XDelete.svg"
    visible:    show_button
    enabled:    !disable_button
    actionID:   _guidedController.actionCancel
}
