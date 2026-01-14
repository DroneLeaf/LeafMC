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
    
    property bool   show_button: leafMode.startsWith(LeafConstants.modeLeafSDKMission)
    property bool   enable_ready_button: leafMissionStatus.startsWith(LeafConstants.missionStatusIdle) && leafStatus.startsWith(LeafConstants.statusArmed)
    property bool   enable_start_button: leafMissionStatus.startsWith(LeafConstants.missionStatusReady)

    text        : enable_ready_button ? qsTr("Ready")
                : enable_start_button ? _guidedController.startMissionTitle
                : qsTr("Ready")

    message     : enable_ready_button ? qsTr("Set mission to ready state")
                : enable_start_button ? _guidedController.startMissionMessage
                : qsTr("Set mission to ready state")

    iconSource  : "/res/takeoff.svg"

    visible     : show_button

    enabled     : enable_ready_button || enable_start_button

    actionID    : enable_ready_button ? _guidedController.actionMissionReady
                : enable_start_button ? _guidedController.actionMissionStart
                : _guidedController.actionMissionReady
}
