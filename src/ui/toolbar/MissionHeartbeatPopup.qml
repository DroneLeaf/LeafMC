/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

// Detailed mission heartbeat information popup
Popup {
    id:                 popup
    width:              mainLayout.width + (ScreenTools.defaultFontPixelWidth * 2)
    height:             mainLayout.height + (ScreenTools.defaultFontPixelHeight * 2)
    modal:              true
    focus:              true
    padding:            ScreenTools.defaultFontPixelHeight
    closePolicy:        Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    x:                  (parent.width - width) / 2
    y:                  (parent.height - height) / 2

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _isStale:           _activeVehicle ? _activeVehicle.missionHeartbeatStale : true
    property int    _heartbeatAge:      _activeVehicle ? _activeVehicle.missionHeartbeatAge : -1
    property color  _stateColor:        _isStale ? qgcPal.colorRed : (_heartbeatAge > 5 ? qgcPal.colorOrange : qgcPal.colorGreen)

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    background: Rectangle {
        color:          qgcPal.window
        border.color:   qgcPal.text
        border.width:   1
        radius:         ScreenTools.defaultFontPixelWidth * 0.5
    }

    ColumnLayout {
        id:         mainLayout
        spacing:    ScreenTools.defaultFontPixelHeight * 0.5

        // Header
        RowLayout {
            Layout.fillWidth:   true
            spacing:            ScreenTools.defaultFontPixelWidth

            QGCColoredImage {
                source:             "/qmlimages/Plan.svg"
                color:              qgcPal.text
                width:              ScreenTools.defaultFontPixelHeight * 2
                height:             width
                sourceSize.width:   width
                fillMode:           Image.PreserveAspectFit
            }

            QGCLabel {
                text:               "Mission Heartbeat Status"
                font.pointSize:     ScreenTools.largeFontPointSize
                font.bold:          true
            }
        }

        Rectangle {
            Layout.fillWidth:   true
            height:             1
            color:              qgcPal.text
        }

        // Status indicator
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

        // Mission State
        GridLayout {
            columns:            2
            rowSpacing:         ScreenTools.defaultFontPixelHeight * 0.25
            columnSpacing:      ScreenTools.defaultFontPixelWidth

            QGCLabel {
                text:               "Mission State:"
                font.pointSize:     ScreenTools.mediumFontPointSize
                Layout.minimumWidth: ScreenTools.defaultFontPixelWidth * 15
            }
            QGCLabel {
                text:               _activeVehicle ? _activeVehicle.missionHeartbeatState : "N/A"
                font.pointSize:     ScreenTools.mediumFontPointSize
                font.bold:          true
            }

            QGCLabel {
                text:               "Mission ID:"
                font.pointSize:     ScreenTools.mediumFontPointSize
            }
            QGCLabel {
                text:               _activeVehicle && _activeVehicle.missionHeartbeatId !== "" ? 
                                        _activeVehicle.missionHeartbeatId : "None"
                font.pointSize:     ScreenTools.mediumFontPointSize
                font.bold:          true
                wrapMode:           Text.WordWrap
                Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 25
            }

            QGCLabel {
                text:               "Heartbeat Age:"
                font.pointSize:     ScreenTools.mediumFontPointSize
            }
            QGCLabel {
                text:               _heartbeatAge >= 0 ? _heartbeatAge + "s ago" : "Never received"
                font.pointSize:     ScreenTools.mediumFontPointSize
                font.bold:          true
                color:              _heartbeatAge > 5 ? qgcPal.colorOrange : (_heartbeatAge > 10 ? qgcPal.colorRed : qgcPal.text)
            }

            QGCLabel {
                text:               "Status:"
                font.pointSize:     ScreenTools.mediumFontPointSize
            }
            QGCLabel {
                text:               _isStale ? "⚠ STALE" : "✓ Fresh"
                font.pointSize:     ScreenTools.mediumFontPointSize
                font.bold:          true
                color:              _stateColor
            }
        }

        Rectangle {
            Layout.fillWidth:   true
            height:             1
            color:              qgcPal.text
        }

        // Warning if stale
        QGCLabel {
            visible:            _isStale
            text:               "⚠ Mission heartbeat not being received.\nCheck petal-leafsdk connection."
            font.pointSize:     ScreenTools.mediumFontPointSize
            color:              qgcPal.colorRed
            wrapMode:           Text.WordWrap
            Layout.maximumWidth: ScreenTools.defaultFontPixelWidth * 30
        }
    }

    // Timer to update age display every second
    Timer {
        interval:   1000
        running:    popup.visible && _activeVehicle
        repeat:     true
        onTriggered: {
            // Trigger property bindings refresh
            // C++ timer handles staleness checking
        }
    }
}
