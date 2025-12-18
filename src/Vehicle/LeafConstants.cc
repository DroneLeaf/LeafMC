/****************************************************************************
 *
 * (c) 2024 DroneLeaf
 *
 * Leaf constants implementation.
 *
 ****************************************************************************/

#include "LeafConstants.h"

// ========== Singleton ==========

Q_GLOBAL_STATIC(LeafConstants, s_instance)

LeafConstants* LeafConstants::instance()
{
    return s_instance();
}

LeafConstants::LeafConstants(QObject* parent)
    : QObject(parent)
{
}

// ========== Mode Strings ==========

const QString& LeafConstants::modeRCStabilized()
{
    static const QString s = QStringLiteral("RC Stabilized");
    return s;
}

const QString& LeafConstants::modeRCPosition()
{
    static const QString s = QStringLiteral("RC POSITION");
    return s;
}

const QString& LeafConstants::modeLeafSDKMission()
{
    static const QString s = QStringLiteral("LeafSDK Mission");
    return s;
}

const QString& LeafConstants::modeRollPitchLearning()
{
    static const QString s = QStringLiteral("Roll/Pitch Learning");
    return s;
}

const QString& LeafConstants::modeLearningOuter()
{
    static const QString s = QStringLiteral("LEARNING OUTER");
    return s;
}

const QString& LeafConstants::modeLearningFull()
{
    static const QString s = QStringLiteral("LEARNING FULL");
    return s;
}

const QString& LeafConstants::modeRefinedTuning()
{
    static const QString s = QStringLiteral("Refined Tuning");
    return s;
}

const QString& LeafConstants::modeRefinedTuningCollect()
{
    static const QString s = QStringLiteral("Refined Tuning - Collect Data");
    return s;
}

const QString& LeafConstants::modeRefinedTuningOuter()
{
    static const QString s = QStringLiteral("Refined Tuning Outer - Collect Data");
    return s;
}

const QString& LeafConstants::modeRefinedPrefix()
{
    static const QString s = QStringLiteral("Refined");
    return s;
}

// ========== Status Strings ==========

const QString& LeafConstants::statusReadyToLearn()
{
    static const QString s = QStringLiteral("READY TO LEARN");
    return s;
}

const QString& LeafConstants::statusLearning()
{
    static const QString s = QStringLiteral("LEARNING");
    return s;
}

const QString& LeafConstants::statusReadyToFly()
{
    static const QString s = QStringLiteral("READY TO FLY");
    return s;
}

const QString& LeafConstants::statusTakingOff()
{
    static const QString s = QStringLiteral("TAKING OFF");
    return s;
}

const QString& LeafConstants::statusFlying()
{
    static const QString s = QStringLiteral("FLYING");
    return s;
}

const QString& LeafConstants::statusLanding()
{
    static const QString s = QStringLiteral("LANDING");
    return s;
}

const QString& LeafConstants::statusLanded()
{
    static const QString s = QStringLiteral("LANDED");
    return s;
}

const QString& LeafConstants::statusArmedIdle()
{
    static const QString s = QStringLiteral("ARMED IDLE");
    return s;
}

const QString& LeafConstants::statusArmed()
{
    static const QString s = QStringLiteral("ARMED");
    return s;
}

const QString& LeafConstants::statusDisarmed()
{
    static const QString s = QStringLiteral("DISARMED");
    return s;
}

const QString& LeafConstants::statusNotReady()
{
    static const QString s = QStringLiteral("NOT READY");
    return s;
}

const QString& LeafConstants::statusMissionPaused()
{
    static const QString s = QStringLiteral("MISSION PAUSED");
    return s;
}

const QString& LeafConstants::statusReturningToBase()
{
    static const QString s = QStringLiteral("RETURNING TO BASE");
    return s;
}

// ========== Mission Status Strings ==========

const QString& LeafConstants::missionStatusPrefix()
{
    static const QString s = QStringLiteral("MISSION STATUS: ");
    return s;
}

const QString& LeafConstants::missionStatusIdle()
{
    static const QString s = QStringLiteral("MISSION STATUS: IDLE");
    return s;
}

const QString& LeafConstants::missionStatusReady()
{
    static const QString s = QStringLiteral("MISSION STATUS: READY");
    return s;
}

const QString& LeafConstants::missionStatusExecuting()
{
    static const QString s = QStringLiteral("MISSION STATUS: EXECUTING");
    return s;
}

const QString& LeafConstants::missionStatusPaused()
{
    static const QString s = QStringLiteral("MISSION STATUS: PAUSED");
    return s;
}

const QString& LeafConstants::missionStatusCanceled()
{
    static const QString s = QStringLiteral("MISSION STATUS: CANCELED");
    return s;
}

const QString& LeafConstants::missionStatusAborted()
{
    static const QString s = QStringLiteral("MISSION STATUS: ABORTED");
    return s;
}

// ========== Enum-to-String Maps ==========

const QMap<int, QString>& LeafConstants::modeNames()
{
    static const QMap<int, QString> map = {
        { static_cast<int>(LeafMode::RCStabilized),        modeRCStabilized() },
        { static_cast<int>(LeafMode::RCPosition),          modeRCPosition() },
        { static_cast<int>(LeafMode::LeafSDKMission),      modeLeafSDKMission() },
        { static_cast<int>(LeafMode::RollPitchLearning),   modeRollPitchLearning() },
        { static_cast<int>(LeafMode::LearningOuter),       modeLearningOuter() },
        { static_cast<int>(LeafMode::LearningFull),        modeLearningFull() },
        { static_cast<int>(LeafMode::RefinedTuning),       modeRefinedTuning() },
        { static_cast<int>(LeafMode::RefinedTuningCollect),modeRefinedTuningCollect() },
        { static_cast<int>(LeafMode::RefinedTuningOuter),  modeRefinedTuningOuter() }
    };
    return map;
}

const QMap<int, QString>& LeafConstants::statusTexts()
{
    static const QMap<int, QString> map = {
        { static_cast<int>(LeafStatus::ReadyToLearn),    statusReadyToLearn() },
        { static_cast<int>(LeafStatus::Learning),        statusLearning() },
        { static_cast<int>(LeafStatus::ReadyToFly),      statusReadyToFly() },
        { static_cast<int>(LeafStatus::TakingOff),       statusTakingOff() },
        { static_cast<int>(LeafStatus::Flying),          statusFlying() },
        { static_cast<int>(LeafStatus::Landing),         statusLanding() },
        { static_cast<int>(LeafStatus::Landed),          statusLanded() },
        { static_cast<int>(LeafStatus::ArmedIdle),       statusArmedIdle() },
        { static_cast<int>(LeafStatus::Armed),           statusArmed() },
        { static_cast<int>(LeafStatus::Disarmed),        statusDisarmed() },
        { static_cast<int>(LeafStatus::NotReady),        statusNotReady() },
        { static_cast<int>(LeafStatus::MissionPaused),   statusMissionPaused() },
        { static_cast<int>(LeafStatus::ReturningToBase), statusReturningToBase() }
    };
    return map;
}

const QMap<int, QString>& LeafConstants::missionStatusTexts()
{
    static const QMap<int, QString> map = {
        { static_cast<int>(MissionStatus::Idle),      missionStatusIdle() },
        { static_cast<int>(MissionStatus::Ready),     missionStatusReady() },
        { static_cast<int>(MissionStatus::Executing), missionStatusExecuting() },
        { static_cast<int>(MissionStatus::Paused),    missionStatusPaused() },
        { static_cast<int>(MissionStatus::Canceled),  missionStatusCanceled() },
        { static_cast<int>(MissionStatus::Aborted),   missionStatusAborted() }
    };
    return map;
}
