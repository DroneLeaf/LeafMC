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
    property string leafMode: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafMode : ""
    property string leafStatus: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafStatus : ""
    property string leafMissionStatus: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafMissionStatus : ""
    
    property bool   show_button: leafMode.startsWith("LeafSDK Mission")
    property bool   enable_start_button: leafMissionStatus.startsWith("MISSION STATUS: READY") && leafStatus.startsWith("ARMED IDLE")
    property bool   enable_cancel_button: !(leafMissionStatus.startsWith("MISSION STATUS: IDLE") || leafMissionStatus.startsWith("MISSION STATUS: READY"))

    text        : enable_start_button ? _guidedController.startMissionTitle
                : enable_cancel_button ? _guidedController.cancelTitle
                : _guidedController.startMissionTitle

    message     : enable_start_button ? _guidedController.startMissionMessage
                : enable_cancel_button ? _guidedController.cancelMessage
                : _guidedController.startMissionMessage

    iconSource  : enable_start_button ? "/res/check.svg"
                : enable_cancel_button ? "/res/XDelete.svg"
                : "/res/check.svg"

    visible     : show_button

    enabled     : enable_cancel_button || enable_start_button

    actionID    : enable_start_button ? _guidedController.actionStartMission
                : enable_cancel_button ? _guidedController.actionCancel
                : _guidedController.actionStartMission
}
