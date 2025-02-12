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
    property bool   hideMRFTY: !_guidedController._fcMRFTPitchOn && !_guidedController._fcMRFTRollOn && !_guidedController._fcMRFTXOn && !_guidedController._fcMRFTAltOn

    text:       _guidedController._fcMRFTYOn ? _guidedController.toggleMRFTYOffTitle : _guidedController.toggleMRFTYOnTitle
    iconSource: "/res/left-right.svg"
    visible:    leafMode == "Refined Tuning - Collect Data"
    enabled:    hideMRFTY
    actionID:   _guidedController.actionMRFTYToggle
}
