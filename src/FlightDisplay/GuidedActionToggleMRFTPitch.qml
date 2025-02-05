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
    property bool   hideMRFTPitch: !_guidedController._fcMRFTAltOn && !_guidedController._fcMRFTRollOn && !_guidedController._fcMRFTXOn && !_guidedController._fcMRFTYOn

    text:       _guidedController._fcMRFTPitchOn ? _guidedController.toggleMRFTPitchOffTitle : _guidedController.toggleMRFTPitchOnTitle
    iconSource: "/res/firmware/swing-arrow.png"
    visible:    leafMode.startsWith("Refined")
    enabled:    hideMRFTPitch
    actionID:   _guidedController.actionMRFTPitchToggle
}
