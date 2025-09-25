#include <QCoreApplication>

#include "SiYi.h"
#include <QSettings>
#include <QFile>
#include <QStandardPaths>

SiYi *SiYi::instance_ = Q_NULLPTR;
SiYi::SiYi(QObject *parent)
    : QObject{parent}
{
    // Load siyi.conf (INI) and provide values to transmitter and camera
    const QString cfgFile = QStringLiteral("siyi.conf");
    const QString defaultIp = QStringLiteral("192.168.144.25");
    const quint16 defaultTransmitterPort = 5864;
    const quint16 defaultCameraPort = 37256; // per requirements

    QString ip = defaultIp;
    quint16 txPort = defaultTransmitterPort;
    quint16 camPort = defaultCameraPort;

    if (!QFile::exists(cfgFile)) {
        QSettings initSettings(cfgFile, QSettings::IniFormat);
        initSettings.beginGroup(QStringLiteral("SiYi"));
        initSettings.setValue(QStringLiteral("ip"), defaultIp);
        initSettings.setValue(QStringLiteral("port"), QVariant::fromValue<int>(int(defaultTransmitterPort)));
        initSettings.setValue(QStringLiteral("cameraPort"), QVariant::fromValue<int>(int(defaultCameraPort)));
        initSettings.endGroup();
        initSettings.sync();
    } else {
        QSettings cfgSettings(cfgFile, QSettings::IniFormat);
        if (cfgSettings.contains(QStringLiteral("SiYi/ip"))) {
            ip = cfgSettings.value(QStringLiteral("SiYi/ip")).toString();
        }
        if (cfgSettings.contains(QStringLiteral("SiYi/port"))) {
            bool ok = false;
            int v = cfgSettings.value(QStringLiteral("SiYi/port")).toInt(&ok);
            if (ok && v > 0 && v <= 0xffff) {
                txPort = quint16(v);
            }
        }
        if (cfgSettings.contains(QStringLiteral("SiYi/cameraPort"))) {
            bool ok = false;
            int v = cfgSettings.value(QStringLiteral("SiYi/cameraPort")).toInt(&ok);
            if (ok && v > 0 && v <= 0xffff) {
                camPort = quint16(v);
            }
        }
    }

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
