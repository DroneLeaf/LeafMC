/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick 2.12

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0

Item {
    id:         _root
    visible:    QGroundControl.videoManager.hasVideo

    focus:      true

    Component.onCompleted: {
        console.log("[FlyViewVideo] Component completed. visible=", visible, "focus=", focus)
    }

    onActiveFocusChanged: {
        console.log("[FlyViewVideo] activeFocus changed:", activeFocus, "focus=", focus)
    }

    Keys.onPressed: {
        console.log("[FlyViewVideo] Keys.onPressed: key=", event.key, "text=", event.text)
        if (event.key == Qt.Key_H) {
            console.log("[FlyViewVideo] Key H pressed - toggling video paused")
            QGroundControl.videoManager.toggleVideoPaused()
            event.accepted = true;
        } else if (event.key === Qt.Key_C) {
            console.log("[FlyViewVideo] Key C pressed - clearing video tracker")
            var vehicle = QGroundControl.multiVehicleManager.activeVehicle
            if (vehicle) {
                vehicle.leafSendVideoClear()
            }
            event.accepted = true;
        }
    }

    property alias iconLeftMargin: siyiController.iconLeftMargin

    property int    _track_rec_x:       0
    property int    _track_rec_y:       0

    property Item pipState: videoPipState
    QGCPipState {
        id:         videoPipState
        pipOverlay: _pipOverlay
        isDark:     true

        onWindowAboutToOpen: {
            QGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onWindowAboutToClose: {
            QGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onStateChanged: {
            if (pipState.state !== pipState.fullState) {
                QGroundControl.videoManager.fullScreen = false
            }
        }
    }

    Timer {
        id:           videoStartDelay
        interval:     2000;
        running:      false
        repeat:       false
        onTriggered:  QGroundControl.videoManager.startVideo()
    }

    //-- Video Streaming
    FlightDisplayViewVideo {
        id:             videoStreaming
        anchors.fill:   parent
        useSmallFont:   _root.pipState.state !== _root.pipState.fullState
        visible:        QGroundControl.videoManager.isGStreamer
    }
    //-- UVC Video (USB Camera or Video Device)
    Loader {
        id:             cameraLoader
        anchors.fill:   parent
        visible:        !QGroundControl.videoManager.isGStreamer
        source:         QGroundControl.videoManager.uvcEnabled ? "qrc:/qml/FlightDisplayViewUVC.qml" : "qrc:/qml/FlightDisplayViewDummy.qml"
    }

    QGCLabel {
        text: qsTr("Double-click to exit full screen")
        font.pointSize: ScreenTools.largeFontPointSize
        visible: QGroundControl.videoManager.fullScreen && flyViewVideoMouseArea.containsMouse
        anchors.centerIn: parent

        onVisibleChanged: {
            if (visible) {
                labelAnimation.start()
            }
        }

        PropertyAnimation on opacity {
            id: labelAnimation
            duration: 10000
            from: 1.0
            to: 0.0
            easing.type: Easing.InExpo
        }
    }

    /* Paused label with translucent background */
    Item {
        anchors.centerIn: parent
        visible: QGroundControl.videoManager.videoPaused

        Rectangle {
            id: pausedBg
            anchors.centerIn: parent
            width: noVideoLabel.contentWidth + ScreenTools.defaultFontPixelHeight
            height: noVideoLabel.contentHeight + ScreenTools.defaultFontPixelHeight
            radius: ScreenTools.defaultFontPointSize / 2
            color: "black"
            opacity: 0.5
        }

        QGCLabel {
            id: noVideoLabel
            text: qsTr("Video Paused. Press \"H\" to Resume")
            font.pointSize: ScreenTools.largeFontPointSize * 1.5
            color: "white"
            anchors.centerIn: parent
        }
    }

    OnScreenGimbalController {
        id:                      onScreenGimbalController
        anchors.fill:            parent
        screenX:                 flyViewVideoMouseArea.mouseX
        screenY:                 flyViewVideoMouseArea.mouseY
        cameraTrackingEnabled:   videoStreaming._camera && videoStreaming._camera.trackingEnabled
    }

    MouseArea {
        id:                         flyViewVideoMouseArea
        anchors.fill:               parent
        enabled:                    pipState.state === pipState.fullState
        hoverEnabled:               true

        property double x0:         0
        property double x1:         0
        property double y0:         0
        property double y1:         0
        property double offset_x:   0
        property double offset_y:   0
        property double radius:     20
        property var trackingROI:   null
        property var trackingStatus: trackingStatusComponent.createObject(flyViewVideoMouseArea, {})

        function clampToRange(value, minValue, maxValue) {
            return Math.max(minValue, Math.min(maxValue, value))
        }

        function videoMapping() {
            var sourceSize = QGroundControl.videoManager.videoSize
            var sourceW = sourceSize.width
            var sourceH = sourceSize.height

            if (sourceW <= 0 || sourceH <= 0) {
                sourceW = videoStreaming ? videoStreaming.getWidth() : 0
                sourceH = videoStreaming ? videoStreaming.getHeight() : 0
            }

            var contentRect = videoStreaming ? videoStreaming.getContentRect() : null
            if (!contentRect || sourceW <= 0 || sourceH <= 0) {
                return null
            }

            var fullLeft = contentRect.x
            var fullTop = contentRect.y
            var fullW = contentRect.width
            var fullH = contentRect.height
            var visLeft = Math.max(fullLeft, 0)
            var visTop = Math.max(fullTop, 0)
            var visRight = Math.min(fullLeft + fullW, width)
            var visBottom = Math.min(fullTop + fullH, height)
            var visW = visRight - visLeft
            var visH = visBottom - visTop

            if (fullW <= 0 || fullH <= 0 || visW <= 0 || visH <= 0) {
                return null
            }

            return {
                sourceW: sourceW,
                sourceH: sourceH,
                fullLeft: fullLeft,
                fullTop: fullTop,
                fullW: fullW,
                fullH: fullH,
                visLeft: visLeft,
                visTop: visTop,
                visRight: visRight,
                visBottom: visBottom,
                cropLeft: visLeft - fullLeft,
                cropTop: visTop - fullTop,
                fitMode: videoStreaming ? videoStreaming._fitMode : 0
            }
        }

        function pointInsideVisibleVideo(mouseX, mouseY, mapping) {
            return mapping &&
                   mouseX >= mapping.visLeft && mouseX <= mapping.visRight &&
                   mouseY >= mapping.visTop && mouseY <= mapping.visBottom
        }

        function normalizePointToVideo(mouseX, mouseY, mapping) {
            if (!mapping) {
                return null
            }

            var clampedX = clampToRange(mouseX, mapping.visLeft, mapping.visRight)
            var clampedY = clampToRange(mouseY, mapping.visTop, mapping.visBottom)
            var fullX = mapping.cropLeft + (clampedX - mapping.visLeft)
            var fullY = mapping.cropTop + (clampedY - mapping.visTop)

            return {
                normalizedX: clampToRange(fullX / mapping.fullW, 0.0, 1.0),
                normalizedY: clampToRange(fullY / mapping.fullH, 0.0, 1.0),
                clampedX: clampedX,
                clampedY: clampedY,
                insideVisible: pointInsideVisibleVideo(mouseX, mouseY, mapping)
            }
        }

        function normalizedSelection(releaseX, releaseY) {
            var mapping = videoMapping()
            if (!mapping) {
                return null
            }

            var start = normalizePointToVideo(_track_rec_x, _track_rec_y, mapping)
            var end = normalizePointToVideo(releaseX, releaseY, mapping)
            if (!start || !end) {
                return null
            }

            if (!start.insideVisible && !end.insideVisible) {
                console.log('[FlyViewVideo] Ignoring selection outside visible video rect:',
                            'press=', _track_rec_x, _track_rec_y,
                            'release=', releaseX, releaseY,
                            'visibleRect=', mapping.visLeft, mapping.visTop, mapping.visRight, mapping.visBottom)
                return null
            }

            var x0 = Math.min(start.normalizedX, end.normalizedX)
            var y0 = Math.min(start.normalizedY, end.normalizedY)
            var x1 = Math.max(start.normalizedX, end.normalizedX)
            var y1 = Math.max(start.normalizedY, end.normalizedY)
            var deltaX = Math.abs(start.clampedX - end.clampedX)
            var deltaY = Math.abs(start.clampedY - end.clampedY)

            console.log('[FlyViewVideo] Video selection mapping:',
                        'source=', mapping.sourceW, mapping.sourceH,
                        'fitMode=', mapping.fitMode,
                        'visibleRect=', mapping.visLeft, mapping.visTop, mapping.visRight, mapping.visBottom,
                        'fullRect=', mapping.fullLeft, mapping.fullTop, mapping.fullW, mapping.fullH,
                        'crop=', mapping.cropLeft, mapping.cropTop,
                        'press=', _track_rec_x, _track_rec_y,
                        'release=', releaseX, releaseY,
                        'norm=', x0, y0, x1, y1)

            return {
                mapping: mapping,
                x0: x0,
                y0: y0,
                x1: x1,
                y1: y1,
                isClick: deltaX < 10 && deltaY < 10
            }
        }

        onClicked:       onScreenGimbalController.clickControl()
        onDoubleClicked: QGroundControl.videoManager.fullScreen = !QGroundControl.videoManager.fullScreen

        onPressed: {
            _root.forceActiveFocus()
            onScreenGimbalController.pressControl()

            _track_rec_x = mouse.x
            _track_rec_y = mouse.y

            //create a new rectangle at the wanted position (always, for visual feedback)
            trackingROI = trackingROIComponent.createObject(flyViewVideoMouseArea, {
                "x": mouse.x,
                "y": mouse.y
            });
        }

        onPositionChanged: {
            console.log("[FlyViewVideo] MouseArea.onPositionChanged - mouse.x=", mouse.x, "mouse.y=", mouse.y)
            //on move, update the width of rectangle
            if (trackingROI !== null) {
                if (mouse.x < trackingROI.x) {
                    trackingROI.x = mouse.x
                    trackingROI.width = Math.abs(mouse.x - _track_rec_x)
                } else {
                    trackingROI.width = Math.abs(mouse.x - trackingROI.x)
                }
                if (mouse.y < trackingROI.y) {
                    trackingROI.y = mouse.y
                    trackingROI.height = Math.abs(mouse.y - _track_rec_y)
                } else {
                    trackingROI.height = Math.abs(mouse.y - trackingROI.y)
                }
            }
        }
        onReleased: {
            onScreenGimbalController.releaseControl()
            
            //if there is already a selection, delete it
            if (trackingROI !== null) {
                trackingROI.destroy();
            }

            var selection = normalizedSelection(mouse.x, mouse.y)
            if (!selection) {
                _track_rec_x = 0
                _track_rec_y = 0
                return
            }

            // === Always send via MAVLink (independent of camera tracking) ===
            var vehicle = QGroundControl.multiVehicleManager.activeVehicle
            if (vehicle) {
                if (selection.isClick) {
                    console.log('[FlyViewVideo] MAVLink video click:', selection.x0, selection.y0)
                    vehicle.leafSendVideoTarget(selection.x0, selection.y0, 0, 0)
                } else {
                    console.log('[FlyViewVideo] MAVLink video ROI:',
                                selection.x0, selection.y0,
                                selection.x1 - selection.x0, selection.y1 - selection.y0)
                    vehicle.leafSendVideoTarget(selection.x0, selection.y0,
                                                selection.x1 - selection.x0, selection.y1 - selection.y0)
                }
            }

            _track_rec_x = 0
            _track_rec_y = 0
        }

        Component {
            id: trackingROIComponent

            Rectangle {
                color:              Qt.rgba(0.1,0.85,0.1,0.25)
                border.color:       "green"
                border.width:       1
            }
        }

        Component {
            id: trackingStatusComponent

            Rectangle {
                color:              "transparent"
                border.color:       "red"
                border.width:       5
                radius:             5
            }
        }

        Timer {
            id: trackingStatusTimer
            interval:               50
            repeat:                 true
            running:                true
            onTriggered: {
                if (videoStreaming._camera) {
                    if (videoStreaming._camera.trackingEnabled && videoStreaming._camera.trackingImageStatus) {
                        var margin_hor = (parent.parent.width - videoStreaming.getWidth()) / 2
                        var margin_ver = (parent.parent.height - videoStreaming.getHeight()) / 2
                        var left = margin_hor + videoStreaming.getWidth() * videoStreaming._camera.trackingImageRect.left
                        var top = margin_ver + videoStreaming.getHeight() * videoStreaming._camera.trackingImageRect.top
                        var right = margin_hor + videoStreaming.getWidth() * videoStreaming._camera.trackingImageRect.right
                        var bottom = margin_ver + !isNaN(videoStreaming._camera.trackingImageRect.bottom) ? videoStreaming.getHeight() * videoStreaming._camera.trackingImageRect.bottom : top + (right - left)
                        var width = right - left
                        var height = bottom - top

                        flyViewVideoMouseArea.trackingStatus.x = left
                        flyViewVideoMouseArea.trackingStatus.y = top
                        flyViewVideoMouseArea.trackingStatus.width = width
                        flyViewVideoMouseArea.trackingStatus.height = height
                    } else {
                        flyViewVideoMouseArea.trackingStatus.x = 0
                        flyViewVideoMouseArea.trackingStatus.y = 0
                        flyViewVideoMouseArea.trackingStatus.width = 0
                        flyViewVideoMouseArea.trackingStatus.height = 0
                    }
                }
            }
        }
    }

    ProximityRadarVideoView{
        anchors.fill:   parent
        vehicle:        QGroundControl.multiVehicleManager.activeVehicle
    }

    ObstacleDistanceOverlayVideo {
        id: obstacleDistance
        showText: pipState.state === pipState.fullState
    }

    FlyViewVideoSiYiController {
        id: siyiController
        anchors.fill: parent
        visible: !_mainWindowIsMap
    }
}
