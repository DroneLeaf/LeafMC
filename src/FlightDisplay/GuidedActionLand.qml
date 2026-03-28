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
    property bool   sdkModeWithUnhealthyHeartbeat: leafMode.startsWith(LeafConstants.modeLeafSDKMission) && _guidedController.is_unhealthy
    property bool   _modes_without_land:    leafMode.startsWith(LeafConstants.modeRCStabilized) || leafMode.startsWith(LeafConstants.modeRollPitchLearning) || leafMode.startsWith(LeafConstants.modeLearningOuter) || leafMode.startsWith(LeafConstants.modeRefinedTuning) || leafMode.startsWith(LeafConstants.modeLeafSDKMission)
    property bool   isAirborne:        _guidedController._activeVehicle ? _guidedController._activeVehicle.leafIsAirborne : false

    text:       _guidedController.landTitle
    message:    sdkModeWithUnhealthyHeartbeat ? "FC Land" : _guidedController.landMessage
    iconSource: "/res/land.svg"
    visible:    sdkModeWithUnhealthyHeartbeat || !_modes_without_land
    enabled:    isAirborne
    actionID:   _guidedController.actionLand
}
