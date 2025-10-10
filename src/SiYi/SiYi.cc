#include <QCoreApplication>

#include "SiYi.h"
#include <QSettings>
#include <QFile>
#include <QStandardPaths>

SiYi *SiYi::instance_ = Q_NULLPTR;
SiYi::SiYi(QObject *parent)
    : QObject{parent}
{
    // Use the same QSettings pattern as Joystick instead of custom config.ini


    const QString defaultIp = QStringLiteral("192.168.144.25");
    const quint16 defaultTransmitterPort = 5864;
    const quint16 defaultCameraPort = 37256; // per requirements

    QString ip = defaultIp;
    quint16 txPort = defaultTransmitterPort;
    quint16 camPort = defaultCameraPort;

    QSettings settings;
    settings.beginGroup("SiYi");

    if (!settings.contains("siyiGimbalIp")) {
        settings.setValue("siyiGimbalIp", ip);
    }
    else {
        ip = settings.value("siyiGimbalIp").toString();
    }
    if (!settings.contains("siyiTransmitterPort")) {
        settings.setValue("siyiTransmitterPort", txPort);
    }
    else {
        bool ok = false;
        int txPortValue = settings.value("siyiTransmitterPort").toInt(&ok);
        if (ok && txPortValue > 0 && txPortValue <= 0xffff) {
            txPort = quint16(txPortValue);
        }
    }
    if (!settings.contains("siyiCameraPort")) {
        settings.setValue("siyiCameraPort", camPort);
    }
    else {
        bool ok = false;
        int camPortValue = settings.value("siyiCameraPort").toInt(&ok);
        if (ok && camPortValue > 0 && camPortValue <= 0xffff) {
            camPort = quint16(camPortValue);
        }
    }

    
    settings.endGroup();
    

    camera_ = new SiYiCamera(ip, camPort, this);
    // set camera's ip/port if necessary (SiYiCamera currently constructs its own SiYiTcpClient with defaults)
    // If SiYiCamera needs custom ip/port plumbing, further changes would be needed.
    transmitter_ = new SiYiTransmitter(ip, txPort, this);
    connect(transmitter_, &SiYiCamera::connected, this, [=](){
        this->isTransmitterConnected_ = true;
        camera_->start();
    });
    connect(transmitter_, &SiYiCamera::disconnected, this, [=](){
        this->isTransmitterConnected_ = false;
        transmitter_->exit();
    });

    connect(camera_, &SiYiCamera::ipChanged, this, [=](){
        if (camera_->isRunning()) {
            camera_->exit();
            camera_->wait();
        }

        camera_->start();
    });
#if 0
    connect(transmitter_, &SiYiCamera::ipChanged, this, [=](){
        if (transmitter_->isRunning()) {
            transmitter_->exit();
            transmitter_->wait();
        }

        transmitter_->start();
    });
#endif
#ifdef Q_OS_ANDROID
    isAndroid_ = true;
#else
    isAndroid_ = false;
#endif

    transmitter_->start();
#if 1   // 为1时，云台控制无需先连接
    camera_->start();
#endif
}

// Add helper methods to save settings when values change (like Joystick does)
void SiYi::setSiyiGimbalIp(const QString &ip)
{
    QSettings settings;
    settings.beginGroup("SiYi");
    settings.setValue("siyiGimbalIp", ip);
    settings.endGroup();
}

void SiYi::setSiyiTransmitterPort(quint16 port)
{
    QSettings settings;
    settings.beginGroup("SiYi");
    settings.setValue("siyiTransmitterPort", int(port));
    settings.endGroup();
}

void SiYi::setSiyiCameraPort(quint16 port)
{
    QSettings settings;
    settings.beginGroup("SiYi");
    settings.setValue("siyiCameraPort", int(port));
    settings.endGroup();
}

SiYi *SiYi::instance()
{
    if (!instance_) {
        instance_ = new SiYi(qApp);
    }

    Q_ASSERT_X(instance_, __FUNCTION__,
               "Can not allocate memory for SiYi instance!");
    return instance_;
}

SiYiCamera *SiYi::cameraInstance()
{
    return camera_;
}

SiYiTransmitter *SiYi::transmitterInstance()
{
    return transmitter_;
}
