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
    property string leafMode: _guidedController._activeVehicle.leafMode
    property string leafStatus: _guidedController._activeVehicle.leafStatus
    property string leafMissionStatus: _guidedController._activeVehicle.leafMissionStatus
    
    property bool   show_button: leafMode.startsWith("LeafSDK Mission")
    property bool   enable_button: leafMissionStatus.startsWith("MISSION STATUS: READY") && leafStatus.startsWith("ARMED IDLE")

    text:       _guidedController.startMissionTitle
    iconSource: "/res/check.svg"
    visible:    show_button
    enabled:    enable_button
    actionID:   _guidedController.actionStartMission
}
