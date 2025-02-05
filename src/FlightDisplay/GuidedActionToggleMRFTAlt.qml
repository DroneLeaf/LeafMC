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
    property bool   hideMRFTAlt: !_guidedController._fcMRFTPitchOn && !_guidedController._fcMRFTRollOn && !_guidedController._fcMRFTXOn && !_guidedController._fcMRFTYOn

    text:       _guidedController._fcMRFTAltOn ? _guidedController.toggleMRFTAltOffTitle : _guidedController.toggleMRFTAltOnTitle
    iconSource: "/res/up-down.svg"
    visible:    leafMode.startsWith("Refined")
    enabled:    hideMRFTAlt
    actionID:   _guidedController.actionMRFTAltToggle
}
