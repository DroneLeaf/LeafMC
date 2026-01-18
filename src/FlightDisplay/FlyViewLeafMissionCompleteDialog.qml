/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.12

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

/// Dialog which shows up when a Leaf mission completes
Item {
    visible: false

    property var missionController
    property var planMasterController
    property var activeVehicle

    property bool _wasArmed: false
    property bool _wasExecuting: false

    Connections {
        target: missionController

        function onLeafMissionCompleted() {
            if (activeVehicle && activeVehicle.leafMode.startsWith(LeafConstants.modeLeafSDKMission)) {
                leafMissionCompleteDialogComponent.createObject(mainWindow).open()
            }
        }
    }

    Connections {
        target: activeVehicle
        onArmedChanged: {
            if (activeVehicle.armed) {
                _wasArmed = true
            } else {
                // Disarmed
                if (_wasArmed && _wasExecuting && activeVehicle.leafMode.startsWith(LeafConstants.modeLeafSDKMission)) {
                     // Check if we are at the last waypoint (or passed it)
                     if (missionController.currentMissionIndex >= missionController.visualItems.count - 1) {
                         leafMissionCompleteDialogComponent.createObject(mainWindow).open()
                     }
                }
                _wasArmed = false
                _wasExecuting = false
            }
        }
        onLeafMissionStatusChanged: {
            if (activeVehicle.leafMissionStatus.startsWith(LeafConstants.missionStatusExecuting)) {
                _wasExecuting = true
            }
        }
    }

    Component {
        id: leafMissionCompleteDialogComponent

        QGCPopupDialog {
            id:         leafMissionCompleteDialog
            title:      qsTr("Leaf Mission Complete")
            buttons:    StandardButton.NoButton

            property var activeVehicleCopy: activeVehicle
            onActiveVehicleCopyChanged:
                if (!activeVehicleCopy) {
                    leafMissionCompleteDialog.close()
                }

            ColumnLayout {
                width:      40 * ScreenTools.defaultFontPixelWidth
                spacing:    ScreenTools.defaultFontPixelHeight

                QGCLabel {
                    Layout.fillWidth:       true
                    text:                   qsTr("The mission has completed. What would you like to do?")
                    wrapMode:               Text.WordWrap
                    horizontalAlignment:    Text.AlignHCenter
                }

                QGCButton {
                    Layout.fillWidth:   true
                    text:               qsTr("Abort Mission")
                    onClicked: {
                        if (activeVehicle) {
                            activeVehicle.guidedModeMissionAbort()
                        }
                        leafMissionCompleteDialog.close()
                    }
                }

                QGCButton {
                    Layout.fillWidth:   true
                    text:               qsTr("Delete Mission")
                    onClicked: {
                        if (activeVehicle) {
                            activeVehicle.guidedModeMissionAbort()
                        }
                        if (planMasterController) {
                            planMasterController.removeAllFromVehicle()
                        }
                        leafMissionCompleteDialog.close()
                    }
                }

                QGCButton {
                    Layout.fillWidth:   true
                    text:               qsTr("Reload Mission")
                    onClicked: {
                        if (planMasterController) {
                            planMasterController.loadFromVehicle()
                        }
                        leafMissionCompleteDialog.close()
                    }
                }

                QGCButton {
                    Layout.fillWidth:   true
                    text:               qsTr("Close")
                    onClicked:          leafMissionCompleteDialog.close()
                }
            }
        }
    }
}
