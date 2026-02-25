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
    property bool   _unhealthy_SDK: leafMode.startsWith(LeafConstants.modeLeafSDKMission) && _heartbeatStale
    property bool   _modes_without_land: leafMode.startsWith(LeafConstants.modeRCStabilized) || leafMode.startsWith(LeafConstants.modeRollPitchLearning) || leafMode.startsWith(LeafConstants.modeLearningOuter) || leafMode.startsWith(LeafConstants.modeRefinedTuning)
    property bool   _status_without_land: leafStatus.startsWith(LeafConstants.statusArmed) || leafStatus.startsWith(LeafConstants.statusReadyToFly) || leafStatus.startsWith(LeafConstants.statusNotReady)
    property bool   hideLand: _modes_without_land || !_unhealthy_SDK
    property bool   disableLand: _status_without_land || !_unhealthy_SDK

    text:       _guidedController.landTitle
    message:    (_unhealthy_SDK ? "FC Land": _guidedController.landMessage)
    iconSource: "/res/land.svg"
    visible:    !hideLand
    enabled:    !disableLand
    actionID:   _guidedController.actionLand
}
