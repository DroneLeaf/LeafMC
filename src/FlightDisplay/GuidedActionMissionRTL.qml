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
    property bool   mission_inactive: leafMissionStatus.startsWith("MISSION STATUS: IDLE") || leafMissionStatus.startsWith("MISSION STATUS: COMPLETED") || leafMissionStatus.startsWith("MISSION STATUS: FAILED") || leafMissionStatus.startsWith("MISSION STATUS: CANCELLED")
    property bool   enable_button: mission_inactive && leafStatus.startsWith(LeafConstants.statusFlying)

    text:       _guidedController.rtlTitle
    iconSource: "/res/rtl.svg"
    visible:    show_button
    enabled:    enable_button
    actionID:   _guidedController.actionMissionRTL
}
