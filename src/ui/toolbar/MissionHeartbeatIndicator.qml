/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Layouts  1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
//-- Mission Heartbeat Indicator
Item {
    id:             _root
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    width:          missionHeartbeatRow.width
    visible:        _activeVehicle

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _isStale:           _activeVehicle ? _activeVehicle.missionHeartbeatStale : true
    property int    _heartbeatAge:      _activeVehicle ? _activeVehicle.missionHeartbeatAge : -1
    property color  _indicatorColor:    _isStale ? qgcPal.colorRed : (_heartbeatAge > 5 ? qgcPal.colorOrange : qgcPal.colorGreen)

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    Row {
        id:             missionHeartbeatRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth * 0.5

        QGCColoredImage {
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            width:              height
            sourceSize.width:   width
            source:             "/qmlimages/Plan.svg"
            fillMode:           Image.PreserveAspectFit
            color:              qgcPal.text

            // Pulsing animation when stale
            SequentialAnimation on opacity {
                running: _isStale
                loops:   Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 500 }
                NumberAnimation { from: 0.3; to: 1.0; duration: 500 }
            }
        }

        QGCLabel {
            text:                   getMissionStateText()
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  qgcPal.text
            anchors.verticalCenter: parent.verticalCenter

            function getMissionStateText() {
                if (!_activeVehicle || _activeVehicle.missionHeartbeatState === "") {
                    return "N/A"
                }
                // Extract state name from "LEAF_MISSION_STATE_IDLE: IDLE" format
                var parts = _activeVehicle.missionHeartbeatState.split(":")
                if (parts.length > 1) {
                    return parts[1].trim()
                }
                return _activeVehicle.missionHeartbeatState
            }
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, missionHeartbeatPopup)
        }
    }

    Component {
        id: missionHeartbeatPopup

        Rectangle {
            width:          mainLayout.width   + mainLayout.anchors.margins * 2
            height:         mainLayout.height  + mainLayout.anchors.margins * 2
            radius:         ScreenTools.defaultFontPixelHeight / 2
            color:          qgcPal.window
            border.color:   qgcPal.text

            property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
            property bool   _isStale:           _activeVehicle ? _activeVehicle.missionHeartbeatStale : true
            property int    _heartbeatAge:      _activeVehicle ? _activeVehicle.missionHeartbeatAge : -1
            property color  _stateColor:        _isStale ? qgcPal.colorRed : (_heartbeatAge > 5 ? qgcPal.colorOrange : qgcPal.colorGreen)

            ColumnLayout {
                id:                 mainLayout
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.top:        parent.top
                anchors.right:      parent.right
                spacing:            ScreenTools.defaultFontPixelHeight

                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    text:               qsTr("Mission Heartbeat Status")
                    font.family:        ScreenTools.demiboldFontFamily
                }

                RowLayout {
                    spacing: ScreenTools.defaultFontPixelWidth

                    Rectangle {
                        width:      ScreenTools.defaultFontPixelHeight
                        height:     width
                        radius:     width / 2
                        color:      _stateColor
                    }

                    QGCLabel {
                        text:       _isStale ? "STALE - No heartbeat received" : "ACTIVE"
                        font.bold:  true
                        color:      _stateColor
                    }
                }

                GridLayout {
                    columns:            2
                    columnSpacing:      ScreenTools.defaultFontPixelWidth

                    QGCLabel {
                        text:           qsTr("Mission State")
                        Layout.fillWidth: false
                    }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatState : "N/A"
                    }

                    QGCLabel {
                        text:           qsTr("Mission ID")
                        Layout.fillWidth: false
                    }
                    QGCLabel {
                        text:           _activeVehicle && _activeVehicle.missionHeartbeatId !== "" ? 
                                            _activeVehicle.missionHeartbeatId : "None"
                        wrapMode:       Text.WordWrap
                        Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 25
                    }

                    QGCLabel {
                        text:           qsTr("Heartbeat Age")
                        Layout.fillWidth: false
                    }
                    QGCLabel {
                        text:           _heartbeatAge >= 0 ? _heartbeatAge + "s ago" : "Never received"
                        color:          _heartbeatAge > 5 ? qgcPal.colorOrange : (_heartbeatAge > 10 ? qgcPal.colorRed : qgcPal.text)
                    }

                    QGCLabel {
                        text:           qsTr("Status")
                        Layout.fillWidth: false
                    }
                    QGCLabel {
                        text:           _isStale ? "⚠ STALE" : "✓ Fresh"
                        color:          _stateColor
                    }
                }

                QGCLabel {
                    visible:            _isStale
                    text:               qsTr("⚠ Mission heartbeat not being received.\nCheck petal-leafsdk connection.")
                    color:              qgcPal.colorRed
                    wrapMode:           Text.WordWrap
                    Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 30
                }
            }

            Timer {
                interval:   1000
                running:    _activeVehicle !== null
                repeat:     true
                onTriggered: {
                    // Trigger property bindings refresh
                }
            }
        }
    }
}
