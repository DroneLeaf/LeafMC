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
    static const QString s = QStringLiteral("Selective X/Y/Altitude Learning");
    return s;
}

const QString& LeafConstants::modeLearningFull()
{
    static const QString s = QStringLiteral("Full Learning");
    return s;
}

const QString& LeafConstants::modeRefinedTuning()
{
    static const QString s = QStringLiteral("RC Stabilize Hover Thrust ID");
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

const QString& LeafConstants::missionStatusIdle()
{
    static const QString s = QStringLiteral("IDLE");
    return s;
}

const QString& LeafConstants::missionStatusReady()
{
    static const QString s = QStringLiteral("READY");
    return s;
}

const QString& LeafConstants::missionStatusExecuting()
{
    static const QString s = QStringLiteral("EXECUTING");
    return s;
}

const QString& LeafConstants::missionStatusFailed()
{
    static const QString s = QStringLiteral("FAILED");
    return s;
}

const QString& LeafConstants::missionStatusCanceled()
{
    static const QString s = QStringLiteral("CANCELLED");
    return s;
}

const QString& LeafConstants::missionStatusScheduledPause()
{
    static const QString s = QStringLiteral("SCHEDULED PAUSE");
    return s;
}

const QString& LeafConstants::missionStatusPausedMidStep()
{
    static const QString s = QStringLiteral("PAUSED MID STEP");
    return s;
}

const QString& LeafConstants::missionStatusPausedBetweenSteps()
{
    static const QString s = QStringLiteral("PAUSED BETWEEN STEPS");
    return s;
}

const QString& LeafConstants::missionStatusCompleted()
{
    static const QString s = QStringLiteral("COMPLETED");
    return s;
}

const QString& LeafConstants::missionStatusSafety()
{
    static const QString s = QStringLiteral("SAFETY");
    return s;
}

// ========== Joystick Mode Strings ==========

const QString& LeafConstants::joystickModeDisabled()
{
    static const QString s = QStringLiteral("DISABLED");
    return s;
}

const QString& LeafConstants::joystickModeEnabledAlways()
{
    static const QString s = QStringLiteral("ENABLED ALWAYS");
    return s;
}

const QString& LeafConstants::joystickModeEnabledOnPause()
{
    static const QString s = QStringLiteral("ENABLED ON PAUSE");
    return s;
}

// ========== Mission Step Type Strings ==========

const QString& LeafConstants::stepTypeIdle()
{
    static const QString s = QStringLiteral("IDLE");
    return s;
}

const QString& LeafConstants::stepTypeGotoGps()
{
    static const QString s = QStringLiteral("GOTO GPS");
    return s;
}

const QString& LeafConstants::stepTypeGotoAbsolute()
{
    static const QString s = QStringLiteral("GOTO ABSOLUTE");
    return s;
}

const QString& LeafConstants::stepTypeGotoRelative()
{
    static const QString s = QStringLiteral("GOTO RELATIVE");
    return s;
}

const QString& LeafConstants::stepTypeYawAbsolute()
{
    static const QString s = QStringLiteral("YAW ABSOLUTE");
    return s;
}

const QString& LeafConstants::stepTypeYawRelative()
{
    static const QString s = QStringLiteral("YAW RELATIVE");
    return s;
}

const QString& LeafConstants::stepTypeTakeoff()
{
    static const QString s = QStringLiteral("TAKEOFF");
    return s;
}

const QString& LeafConstants::stepTypeWait()
{
    static const QString s = QStringLiteral("WAIT");
    return s;
}

const QString& LeafConstants::stepTypeLand()
{
    static const QString s = QStringLiteral("LAND");
    return s;
}

const QString& LeafConstants::stepTypeRtl()
{
    static const QString s = QStringLiteral("RTL");
    return s;
}

// ========== Predefined Action Status Strings ==========

const QString& LeafConstants::actionStatusNotStarted()
{
    static const QString s = QStringLiteral("NOT STARTED");
    return s;
}

const QString& LeafConstants::actionStatusTakingOff()
{
    static const QString s = QStringLiteral("TAKING OFF");
    return s;
}

const QString& LeafConstants::actionStatusLanding()
{
    static const QString s = QStringLiteral("LANDING");
    return s;
}

const QString& LeafConstants::actionStatusReturningToLaunch()
{
    static const QString s = QStringLiteral("RTL");
    return s;
}

const QString& LeafConstants::actionStatusGotoXyz()
{
    static const QString s = QStringLiteral("GOTO XYZ");
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
        { static_cast<int>(MissionStatus::Idle),               missionStatusIdle() },
        { static_cast<int>(MissionStatus::Ready),              missionStatusReady() },
        { static_cast<int>(MissionStatus::Running),            missionStatusExecuting() },
        { static_cast<int>(MissionStatus::ScheduledPause),     missionStatusScheduledPause() },
        { static_cast<int>(MissionStatus::PausedMidStep),      missionStatusPausedMidStep() },
        { static_cast<int>(MissionStatus::PausedBetweenSteps), missionStatusPausedBetweenSteps() },
        { static_cast<int>(MissionStatus::Completed),          missionStatusCompleted() },
        { static_cast<int>(MissionStatus::Failed),             missionStatusFailed() },
        { static_cast<int>(MissionStatus::Cancelled),          missionStatusCanceled() },
        { static_cast<int>(MissionStatus::Safety),             missionStatusSafety() }
    };
    return map;
}
