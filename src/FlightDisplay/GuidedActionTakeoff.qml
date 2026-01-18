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
    property bool   show_button: !leafMode.startsWith(LeafConstants.modeLeafSDKMission)
    property bool   hideTakeoff: leafMode.startsWith(LeafConstants.modeRCStabilized) || leafMode.startsWith(LeafConstants.modeRollPitchLearning) || leafMode.startsWith(LeafConstants.modeLearningOuter) || leafMode.startsWith(LeafConstants.modeRefinedTuning)
    property bool   isLeafArmed: leafStatus.startsWith(LeafConstants.statusArmed)

    text:       _guidedController.takeoffTitle
    iconSource: "/res/takeoff.svg"
    visible:    show_button && !hideTakeoff
    enabled:    !hideTakeoff && isLeafArmed
    actionID:   _guidedController.actionTakeoff
}
