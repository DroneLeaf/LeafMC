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
    property string leafMode:    _guidedController._activeVehicle ? _guidedController._activeVehicle.leafMode    : ""
    property bool   inSDKMission:    leafMode.startsWith(LeafConstants.modeLeafSDKMission)
    property bool   _modes_without_takeoff:    leafMode.startsWith(LeafConstants.modeRCStabilized) || leafMode.startsWith(LeafConstants.modeRollPitchLearning) || leafMode.startsWith(LeafConstants.modeLearningOuter) || leafMode.startsWith(LeafConstants.modeRefinedTuning)
    property bool   isArmed: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafArmStage !== LeafConstants.armStageDisarmed : false
    property bool   isAirborne: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafIsAirborne : false

    text:       _guidedController.takeoffTitle
    iconSource: "/res/takeoff.svg"
    visible:    !inSDKMission && !_modes_without_takeoff
    enabled:    !isAirborne && isArmed
    actionID:   _guidedController.actionTakeoff
}
