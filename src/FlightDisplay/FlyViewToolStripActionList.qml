/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQml.Models 2.12

import QGroundControl           1.0
import QGroundControl.Controls  1.0
import QGroundControl.Vehicle   1.0

ToolStripActionList {
    id: _root

    signal displayPreFlightChecklist

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property string leafMode: _activeVehicle ? _activeVehicle.leafMode : ""

    model: [
        ToolStripAction {
            text:           qsTr("Plan")
            iconSource:     "/qmlimages/Plan.svg"
            visible:        leafMode.startsWith(LeafConstants.modeLeafSDKMission)
            onTriggered:    mainWindow.showPlanView()
        },
        PreFlightCheckListShowAction { onTriggered: displayPreFlightChecklist() },
        GuidedActionFCArmToggle { },
        GuidedActionFCDisarmToggle { },
        GuidedActionMissionIdleAndStart { },
        GuidedActionTakeoff { },
        GuidedActionLand { },
        GuidedActionExecuteCircleTraj { },
        GuidedActionExecuteFig8Traj { },
        GuidedActionToggleMRFTPitch { },
        GuidedActionToggleMRFTRoll { },
        GuidedActionToggleMRFTAlt { },
        GuidedActionToggleMRFTX { },
        GuidedActionToggleMRFTY { },
        GuidedActionMissionRTL { },
        GuidedActionMissionPause { },
        GuidedActionMissionResume { },
        GuidedActionMissionAbort { },
        GuidedActionMissionLand { }
    ]
}
