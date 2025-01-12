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

    text:       _guidedController.inspectSlap2Title
    iconSource: "/res/inspection.svg"
    visible:    leafMode.startsWith("INSPECTION")
    enabled:    true
    actionID:   _guidedController.actionInspectSlap2
}
