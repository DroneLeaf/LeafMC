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
    property bool   _leafSDKHealthy:    _activeVehicle ? _activeVehicle.leafSDKHealthy : false
    property int    _heartbeatAge:      _activeVehicle ? _activeVehicle.missionHeartbeatAge : -1
    property bool   _isStale:           _activeVehicle ? _activeVehicle.missionHeartbeatStale : true
    property bool   _isUnhealthyState:  _activeVehicle ? _activeVehicle.missionHeartbeatSDKState === "UNHEALTHY" : true
    property string _rawState:          _activeVehicle ? _activeVehicle.missionHeartbeatState : ""
    property string _indicatorText: {
        if (!_activeVehicle || _isStale || _isUnhealthyState || !_leafSDKHealthy) return "⚠️"
        switch (_rawState) {
        case "Waiting":          return "⏳"
        case "PausedScheduled":  return "⏸️🕒"
        case "PausedBetween":    return "⏸️↔️"
        case "PausedMidStep":    return "⏸️"
        case "Running":          return "▶️"
        case "Completed":        return "✅"
        case "Failed":           return "❌"
        case "Aborted":          return "🛑"
        case "Ready":            return "🟢"
        case "Unhealthy":        return "⚠️"
        default:                  return _rawState !== "" ? _rawState : "⏳"
        }
    }
    property color  _indicatorColor: {
        if (_indicatorText === "⚠️") return qgcPal.colorRed
        if (_heartbeatAge > 5) return qgcPal.colorRed
        if (_heartbeatAge > 2) return qgcPal.colorOrange
        if (_indicatorText === "⏸️🕒" || _indicatorText === "⏸️↔️" || _indicatorText === "⏸️") return qgcPal.colorOrange
        if (_indicatorText === "▶️" || _indicatorText === "✅") return qgcPal.colorGreen
        if (_indicatorText === "🟢") return qgcPal.colorBlue
        if (_indicatorText === "❌" || _indicatorText === "🛑") return qgcPal.colorRed
        return qgcPal.text
    }
    property string _stateLabelText: {
        if (!_activeVehicle || _isStale || _isUnhealthyState || !_leafSDKHealthy) return "⚠️ Unhealthy"
        if (_rawState === "PausedScheduled")  return "⏸️🕒 Paused \u00b7 Scheduled"
        if (_rawState === "PausedBetween")    return "⏸️↔️ Paused \u00b7 Between Steps"
        if (_rawState === "PausedMidStep")    return "⏸️ Paused \u00b7 Mid-Step"
        if (_rawState === "Ready")            return "🟢 Ready to Start"
        if (_rawState === "Waiting")          return "⏳ Waiting"
        if (_rawState === "Running")          return "▶️ Running"
        if (_rawState === "Completed")        return "✅ Completed"
        if (_rawState === "Failed")           return "❌ Failed"
        if (_rawState === "Aborted")          return "🛑 Aborted"
        if (_rawState === "Unhealthy")        return "⚠️ Unhealthy"
        return _rawState !== "" ? _rawState : "⏳ Waiting"
    }
    property bool   _activeMission: _activeVehicle ? _activeVehicle.leafMissionInProgress : false
    property bool   _hasMissionDetails: {
        if (!_activeVehicle) {
            return false
        }
        return (_activeVehicle.missionHeartbeatName !== "") ||
               (_activeVehicle.missionHeartbeatStepName !== "") ||
               (_activeVehicle.missionHeartbeatStepType !== "") ||
               (_rawState !== "")
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
            }
        }

        QGCLabel {
            text:                   !_activeVehicle ? "N/A" : _indicatorText
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  _indicatorColor
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 250 }
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
            property bool   _leafSDKHealthy:    _activeVehicle ? _activeVehicle.leafSDKHealthy : false
            property int    _heartbeatAge:      _activeVehicle ? _activeVehicle.missionHeartbeatAge : -1
            property bool   _isStale:           _activeVehicle ? _activeVehicle.missionHeartbeatStale : true
            property bool   _isUnhealthyState:  _activeVehicle ? _activeVehicle.missionHeartbeatSDKState === "UNHEALTHY" : true
            property string _rawState:          _activeVehicle ? _activeVehicle.missionHeartbeatState : ""
            property string _indicatorText:     _root._indicatorText
            property color  _stateColor:        !_leafSDKHealthy ? qgcPal.colorRed : (_heartbeatAge > 5 ? qgcPal.colorRed : (_heartbeatAge > 2 ? qgcPal.colorOrange : qgcPal.colorGreen))
            property color  _statusColor: {
                if (!_activeVehicle) return qgcPal.text
                if (_indicatorText === "▶️" || _indicatorText === "✅") return qgcPal.colorGreen
                if (_indicatorText === "🟢") return qgcPal.colorBlue
                if (_indicatorText === "⏸️🕒" || _indicatorText === "⏸️↔️" || _indicatorText === "⏸️") return qgcPal.colorOrange
                if (_indicatorText === "❌" || _indicatorText === "🛑" || _indicatorText === "⚠️") return qgcPal.colorRed
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
                    visible:            !_leafSDKHealthy
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
                        text:           !_leafSDKHealthy ? qsTr("UNHEALTHY") : qsTr("HEALTHY")
                        color:          _stateColor
                        Behavior on color { ColorAnimation { duration: 250 } }
                    }

                    QGCLabel { text: qsTr("Heartbeat Age"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _heartbeatAge >= 0 ? _heartbeatAge + "s ago" : "Never"
                        color:          _heartbeatAge > 5 ? qgcPal.colorRed : (_heartbeatAge > 2 ? qgcPal.colorOrange : qgcPal.text)
                    }

                    QGCLabel { text: qsTr("Mission Queue Count"); Layout.fillWidth: false }
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
                    visible:            _root._hasMissionDetails
                }

                GridLayout {
                    visible:            _root._hasMissionDetails
                    columns:            2
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.2

                    QGCLabel { text: qsTr("Mission State"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _root._stateLabelText : "N/A"
                        color:          _statusColor
                    }

                    QGCLabel { text: qsTr("Mission Name"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? _activeVehicle.missionHeartbeatName : "None"
                        wrapMode:       Text.WordWrap
                        Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 20
                    }

                    QGCLabel { text: qsTr("Mission Mode"); Layout.fillWidth: false }
                    QGCLabel {
                        text: {
                            if (!_activeVehicle) return "N/A"
                            return _activeVehicle.missionHeartbeatMissionMode === 0 ? qsTr("Predefined") : qsTr("Interactive")
                        }
                    }

                    QGCLabel { text: qsTr("Mission Type"); Layout.fillWidth: false }
                    QGCLabel {
                        text:           _activeVehicle ? (_activeVehicle.missionHeartbeatMissionType !== "" ? _activeVehicle.missionHeartbeatMissionType : "N/A") : "N/A"
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
