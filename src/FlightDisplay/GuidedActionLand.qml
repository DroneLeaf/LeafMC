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

    property bool   hideLand: leafMode.startsWith(LeafConstants.modeRCStabilized) || leafMode.startsWith(LeafConstants.modeRollPitchLearning) || leafMode.startsWith(LeafConstants.modeRefinedTuningOuter)
    property bool   disableLand: leafStatus.startsWith(LeafConstants.statusArmed) || leafStatus.startsWith(LeafConstants.statusReadyToFly) || leafStatus.startsWith(LeafConstants.statusNotReady)
    property bool   enableLand_leafMission: leafMissionStatus.startsWith(LeafConstants.missionStatusIdle)

    text:       _guidedController.landTitle
    message:    _guidedController.landMessage
    iconSource: "/res/land.svg"
    visible:    true
    enabled:    !disableLand && !hideLand && enableLand_leafMission
    actionID:   _guidedController.actionLand
}
