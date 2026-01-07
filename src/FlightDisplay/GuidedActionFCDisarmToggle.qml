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
    property string leafMissionStatus: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafMissionStatus : ""
    property bool isLeafArmed: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafFCArmed : false

    text:       _guidedController.disarmFCTitle
    iconSource: "/res/PowerButton.svg"
    visible:    (isLeafArmed) && leafMode.length > 0 && (!leafMode.startsWith(LeafConstants.modeLeafSDKMission)  || leafMode.startsWith(LeafConstants.modeLeafSDKMission) && leafMissionStatus.startsWith(LeafConstants.missionStatusIDLE))
    enabled:    true
    actionID:   _guidedController.actionFCDisarm
}
