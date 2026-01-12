/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QGroundControl.FlightDisplay 1.0
import QGroundControl.Vehicle 1.0

GuidedToolStripAction {
    property string leafMode: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafMode : ""
    property string leafStatus: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafStatus : ""
    property string leafMissionStatus: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafMissionStatus : ""
    property bool   _heartbeatStale: _guidedController._activeVehicle ? _guidedController._activeVehicle.missionHeartbeatStale : true
    
    property bool   show_button: leafMode.startsWith(LeafConstants.modeLeafSDKMission) && !_heartbeatStale
    property bool   enable_pause_button: leafMissionStatus.startsWith("MISSION STATUS: EXECUTING") || leafMissionStatus.startsWith("MISSION STATUS: SCHEDULED PAUSE")
    property bool   enable_resume_button: leafMissionStatus.startsWith("MISSION STATUS: PAUSED MID STEP") || leafMissionStatus.startsWith("MISSION STATUS: PAUSED BETWEEN STEPS")

    text        : enable_pause_button ? _guidedController.pauseTitle
                : enable_resume_button ? _guidedController.resumeTitle
                : _guidedController.pauseTitle

    message     : enable_pause_button ? _guidedController.pauseMessage
                : enable_resume_button ? _guidedController.resumeMessage
                : _guidedController.pauseMessage

    iconSource  : enable_pause_button ? "/res/pause-mission.svg"
                : enable_resume_button ? "/res/action.svg"
                : "/res/pause-mission.svg"

    visible     : show_button

    enabled     : enable_pause_button || enable_resume_button

    actionID    : enable_pause_button ? _guidedController.actionMissionPause
                : enable_resume_button ? _guidedController.actionMissionResume
                : _guidedController.actionMissionPause
}
