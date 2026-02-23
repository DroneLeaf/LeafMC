import QGroundControl.FlightDisplay 1.0

GuidedToolStripAction {
    property string leafMode: _guidedController._activeVehicle ? _guidedController._activeVehicle.leafMode : ""
    property bool   hideMRFTYaw: !_guidedController._fcMRFTPitchOn && !_guidedController._fcMRFTRollOn && !_guidedController._fcMRFTXOn && !_guidedController._fcMRFTYOn && !_guidedController._fcMRFTAltOn

    text:       _guidedController._fcMRFTYawOn ? _guidedController.toggleMRFTYawOffTitle : _guidedController.toggleMRFTYawOnTitle
    iconSource: "/res/firmware/swing-arrow.png"
    visible:    leafMode == "Refined Tuning - Collect Data"
    enabled:    hideMRFTYaw
    actionID:   _guidedController.actionMRFTYawToggle
}