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
import QGroundControl.Vehicle               1.0

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
    property color  _indicatorColor:    _isStale ? qgcPal.colorRed : (_heartbeatAge > 5 ? qgcPal.colorRed : (_heartbeatAge > 2 ? qgcPal.colorOrange : (_activeMission ? qgcPal.colorGreen : qgcPal.text)))
    property bool   _activeMission: {
        if (!_activeVehicle || _activeVehicle.missionHeartbeatState === "") return false
        var state = _activeVehicle.missionHeartbeatState
        return state !== LeafConstants.missionStatusIdle 
    }
    
    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    Row {
        id:             missionHeartbeatRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth * 0.5

        Item {
            anchors.top:    parent.top
            anchors.bottom: parent.bottom
            width:          height

            QGCColoredImage {
                id:                 indicatorIcon
                anchors.fill:       parent
                sourceSize.width:   width
                source:             "/qmlimages/Plan.svg"
                fillMode:           Image.PreserveAspectFit
                color:              _indicatorColor

                Behavior on color {
                    ColorAnimation { duration: 250 }
                }

                transform: Scale {
                    id:             iconScale
                    origin.x:       indicatorIcon.width / 2
                    origin.y:       indicatorIcon.height / 2
                    xScale:         1.0
                    yScale:         1.0
                }

                // Pulsing animation when stale
                SequentialAnimation on opacity {
                    running: _isStale
                    loops:   Animation.Infinite
                    NumberAnimation { from: 1.0; to: 0.3; duration: 500 }
                    NumberAnimation { from: 0.3; to: 1.0; duration: 500 }
                }

                // Scaling pulse when stale
                SequentialAnimation {
                    running: _isStale
                    loops:   Animation.Infinite
                    ParallelAnimation {
                        NumberAnimation { target: iconScale; property: "xScale"; from: 1.0; to: 0.8; duration: 500; easing.type: Easing.InOutQuad }
                        NumberAnimation { target: iconScale; property: "yScale"; from: 1.0; to: 0.8; duration: 500; easing.type: Easing.InOutQuad }
                    }
                    ParallelAnimation {
                        NumberAnimation { target: iconScale; property: "xScale"; from: 0.8; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                        NumberAnimation { target: iconScale; property: "yScale"; from: 0.8; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                    }
                }
            }

            // Heartbeat "Ping" ripple effect
            Rectangle {
                anchors.fill:   parent
                radius:         width / 2
                color:          _indicatorColor
                visible:        !_isStale && _activeMission

                SequentialAnimation on opacity {
                    id:      pingAnim
                    loops:   1
                    running: false
                    NumberAnimation { from: 0.6; to: 0.0; duration: 400; easing.type: Easing.OutQuad }
                }

                SequentialAnimation on scale {
                    loops:   1
                    running: pingAnim.running
                    NumberAnimation { from: 1.0; to: 2.0; duration: 400; easing.type: Easing.OutQuad }
                }
            }
        }

        QGCLabel {
            text:                   _activeVehicle && _activeVehicle.missionHeartbeatState !== "" ? _activeVehicle.missionHeartbeatState : "N/A"
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  _isStale ? qgcPal.colorRed : qgcPal.text
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 250 }
            }
        }
    }

    // Trigger ping on every heartbeat
    Connections {
        target: _activeVehicle
        onMissionHeartbeatAgeChanged: {
            if (_activeVehicle.missionHeartbeatAge === 0) {
                pingAnim.restart()
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
            id:             popupBg
            width:          mainLayout.width   + (ScreenTools.defaultFontPixelWidth * 2)
            height:         mainLayout.height  + (ScreenTools.defaultFontPixelHeight * 2)
            radius:         ScreenTools.defaultFontPixelHeight / 2
            color:          qgcPal.window
            border.color:   qgcPal.text
            opacity:        0.95

            property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
            property bool   _isStale:           _activeVehicle ? _activeVehicle.missionHeartbeatStale : true
            property int    _heartbeatAge:      _activeVehicle ? _activeVehicle.missionHeartbeatAge : -1
            property color  _stateColor:        _isStale ? qgcPal.colorRed : (_heartbeatAge > 5 ? qgcPal.colorRed : (_heartbeatAge > 2 ? qgcPal.colorOrange : qgcPal.colorGreen))
            property color  _statusColor: {
                if (!_activeVehicle || _activeVehicle.missionHeartbeatState === "" || _activeVehicle.missionHeartbeatState === LeafConstants.missionStatusIdle || _isStale) return qgcPal.text
                var state = _activeVehicle.missionHeartbeatState
                if (state === LeafConstants.missionStatusExecuting || state === LeafConstants.missionStatusCompleted) return qgcPal.colorGreen
                if (state === LeafConstants.missionStatusReady)                               return qgcPal.colorBlue
                if (state.indexOf("PAUSE") !== -1)                  return qgcPal.colorOrange
                if (state === LeafConstants.missionStatusFailed || state === LeafConstants.missionStatusCanceled || state === LeafConstants.missionStatusSafety) return qgcPal.colorRed
                return qgcPal.text
            }

            ColumnLayout {
                id:                 mainLayout
                anchors.centerIn:   parent
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5

                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    text:               qsTr("LeafSDK Mission Status")
                    font.family:        ScreenTools.demiboldFontFamily
                    font.pointSize:     ScreenTools.largeFontPointSize
                }

                Rectangle {
                    Layout.fillWidth:   true
                    height:             1
                    color:              qgcPal.windowShadeDark
                }

                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    visible:            _isStale
                    text:               qsTr("⚠ Check Petal-LeafSDK connection.")
                    color:              qgcPal.colorRed
                    wrapMode:           Text.WordWrap
                    Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 30
                }

                GridLayout {
                    columns:            2
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.2

                    QGCLabel { text: qsTr("Status"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _isStale ? qsTr("UNHEALTHY") : qsTr("HEALTHY")
                        color:          _stateColor
                        Behavior on color { ColorAnimation { duration: 250 } }
                    }

                    QGCLabel { text: qsTr("SDK State"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatSDKState : "N/A"
                    }

                    QGCLabel { text: qsTr("Heartbeat Age"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _heartbeatAge >= 0 ? _heartbeatAge + "s ago" : "Never"
                        color:          _heartbeatAge > 5 ? qgcPal.colorRed : (_heartbeatAge > 2 ? qgcPal.colorOrange : qgcPal.text)
                    }

                    QGCLabel { text: qsTr("Queue Count"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatQueueCount : "0"
                    }

                    QGCLabel { text: qsTr("Joystick Mode"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatJoystickMode : "N/A"
                    }
                }

                Rectangle {
                    Layout.fillWidth:   true
                    height:             1
                    color:              qgcPal.windowShadeDark
                    visible:            _activeMission
                }

                GridLayout {
                    visible:            _activeMission
                    columns:            2
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.2

                    QGCLabel { text: qsTr("Mission State"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatState : "N/A"
                        color:          _statusColor
                    }

                    QGCLabel { text: qsTr("Mission Name"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatName : "None"
                        wrapMode:       Text.WordWrap
                        Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 20
                    }

                    QGCLabel { text: qsTr("Current Step"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatStepName : "N/A"
                        wrapMode:       Text.WordWrap
                        Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 20
                    }

                    QGCLabel { text: qsTr("Step Type"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatStepType : "N/A"
                    }
                }
            }
        }
    }
}
