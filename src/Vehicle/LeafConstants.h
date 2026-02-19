/****************************************************************************
 *
 * (c) 2024 DroneLeaf
 *
 * Leaf constants for use in C++ and QML.
 *
 ****************************************************************************/

#pragma once

#include <QObject>
#include <QString>
#include <QMap>

class LeafConstants : public QObject
{
    Q_OBJECT

public:
    // ========== LeafMode Enum ==========
    // Maps to MAVLink LEAF_MODE enum (ready for future direct mapping)
    enum class LeafMode {
        RCStabilized,           // LEAF_MODE_RC_Stabilized
        RCPosition,             // LEAF_MODE_RC_POSITION
        LeafSDKMission,         // LEAF_MODE_MISSION
        RollPitchLearning,      // LEAF_MODE_ROLL_PITCH_LEARNING
        LearningOuter,          // LEAF_MODE_SELECTIVE_X_Y_ALTITUDE_LEARNING
        LearningFull,           // LEAF_MODE_FULL_LEARNING
        RefinedTuning,          // LEAF_MODE_RC_STABILIZE_HOVER_THRUST_ID
        RefinedTuningCollect,   // LEAF_MODE_REFINED_TUNING_COLLECT_DATA
        RefinedTuningOuter      // LEAF_MODE_REFINED_TUNING_OUTER
    };
    Q_ENUM(LeafMode)

    // ========== LeafStatus Enum ==========
    // Maps to MAVLink LEAF_STATUS enum (ready for future direct mapping)
    enum class LeafStatus {
        ReadyToLearn,       // LEAF_STATUS_READY_TO_LEARN
        Learning,           // LEAF_STATUS_LEARNING
        ReadyToFly,         // LEAF_STATUS_READY_TO_FLY
        TakingOff,          // LEAF_STATUS_TAKING_OFF
        Flying,             // LEAF_STATUS_FLYING
        Landing,            // LEAF_STATUS_LANDING
        Landed,             // LEAF_STATUS_LANDED
        ArmedIdle,          // LEAF_STATUS_ARMED_IDLE
        Armed,              // LEAF_STATUS_ARMED
        Disarmed,           // LEAF_STATUS_DISARMED
        NotReady,           // LEAF_STATUS_NOT_READY
        MissionPaused,      // LEAF_STATUS_MISSION_PAUSED
        ReturningToBase     // LEAF_STATUS_RETURNING_TO_BASE
    };
    Q_ENUM(LeafStatus)

    // ========== MissionStatus Enum ==========
    // Maps to MAVLink LEAF_MISSION_STATUS enum (ready for future direct mapping)
    enum class MissionStatus {
        Idle,               // LEAF_MISSION_STATE_IDLE
        Ready,              // LEAF_MISSION_STATE_READY
        Running,            // LEAF_MISSION_STATE_RUNNING
        ScheduledPause,     // LEAF_MISSION_STATE_SCHEDULED_PAUSE
        PausedMidStep,      // LEAF_MISSION_STATE_PAUSED_MID_STEP
        PausedBetweenSteps, // LEAF_MISSION_STATE_PAUSED_BETWEEN_STEPS
        Completed,          // LEAF_MISSION_STATE_COMPLETED
        Failed,             // LEAF_MISSION_STATE_FAILED
        Cancelled,          // LEAF_MISSION_STATE_CANCELLED
        Safety              // LEAF_MISSION_STATE_SAFETY
    };
    Q_ENUM(MissionStatus)

    // ========== Singleton Access ==========
    static LeafConstants* instance();

    // Constructor (public for Q_GLOBAL_STATIC)
    explicit LeafConstants(QObject* parent = nullptr);

    // ========== String Constants ==========
    // Mode strings
    static const QString& modeRCStabilized();
    static const QString& modeRCPosition();
    static const QString& modeLeafSDKMission();
    static const QString& modeRollPitchLearning();
    static const QString& modeLearningOuter();
    static const QString& modeLearningFull();
    static const QString& modeRefinedTuning();
    static const QString& modeRefinedTuningCollect();
    static const QString& modeRefinedTuningOuter();
    static const QString& modeRefinedPrefix();  // "Refined" prefix for group matching

    // Status strings
    static const QString& statusReadyToLearn();
    static const QString& statusLearning();
    static const QString& statusReadyToFly();
    static const QString& statusTakingOff();
    static const QString& statusFlying();
    static const QString& statusLanding();
    static const QString& statusLanded();
    static const QString& statusArmedIdle();
    static const QString& statusArmed();
    static const QString& statusDisarmed();
    static const QString& statusNotReady();
    static const QString& statusMissionPaused();
    static const QString& statusReturningToBase();

    // Mission status strings
    static const QString& missionStatusIdle();        // "IDLE"
    static const QString& missionStatusReady();       // "READY"
    static const QString& missionStatusExecuting();   // "EXECUTING" (Maps to RUNNING)
    static const QString& missionStatusFailed();      // "FAILED"
    static const QString& missionStatusCanceled();    // "CANCELLED"
    static const QString& missionStatusScheduledPause();       // "SCHEDULED PAUSE"
    static const QString& missionStatusPausedMidStep();        // "PAUSED MID STEP"
    static const QString& missionStatusPausedBetweenSteps();   // "PAUSED BETWEEN STEPS"
    static const QString& missionStatusCompleted();            // "COMPLETED"
    static const QString& missionStatusSafety();               // "SAFETY"

    // Joystick mode strings
    static const QString& joystickModeDisabled();              // "DISABLED"
    static const QString& joystickModeEnabledAlways();         // "ENABLED ALWAYS"
    static const QString& joystickModeEnabledOnPause();        // "ENABLED ON PAUSE"

    // Mission step type strings
    static const QString& stepTypeIdle();                      // "IDLE"
    static const QString& stepTypeGotoGps();                   // "GOTO GPS"
    static const QString& stepTypeGotoAbsolute();              // "GOTO ABSOLUTE"
    static const QString& stepTypeGotoRelative();              // "GOTO RELATIVE"
    static const QString& stepTypeYawAbsolute();               // "YAW ABSOLUTE"
    static const QString& stepTypeYawRelative();               // "YAW RELATIVE"
    static const QString& stepTypeTakeoff();                   // "TAKEOFF"
    static const QString& stepTypeWait();                      // "WAIT"
    static const QString& stepTypeLand();                      // "LAND"
    static const QString& stepTypeRtl();                       // "RTL"

    // Predefined action status strings
    static const QString& actionStatusNotStarted();            // "NOT STARTED"
    static const QString& actionStatusTakingOff();             // "TAKING OFF"
    static const QString& actionStatusLanding();               // "LANDING"
    static const QString& actionStatusReturningToLaunch();      // "RETURNING TO LAUNCH"
    static const QString& actionStatusGotoXyz();               // "GOTO XYZ"

    // ========== Enum-to-String Maps ==========
    static const QMap<int, QString>& modeNames();
    static const QMap<int, QString>& statusTexts();
    static const QMap<int, QString>& missionStatusTexts();

    // ========== Q_PROPERTY for QML ==========
    // Mode strings
    Q_PROPERTY(QString modeRCStabilized READ qmlModeRCStabilized CONSTANT)
    Q_PROPERTY(QString modeRCPosition READ qmlModeRCPosition CONSTANT)
    Q_PROPERTY(QString modeLeafSDKMission READ qmlModeLeafSDKMission CONSTANT)
    Q_PROPERTY(QString modeRollPitchLearning READ qmlModeRollPitchLearning CONSTANT)
    Q_PROPERTY(QString modeLearningOuter READ qmlModeLearningOuter CONSTANT)
    Q_PROPERTY(QString modeLearningFull READ qmlModeLearningFull CONSTANT)
    Q_PROPERTY(QString modeRefinedTuning READ qmlModeRefinedTuning CONSTANT)
    Q_PROPERTY(QString modeRefinedTuningCollect READ qmlModeRefinedTuningCollect CONSTANT)
    Q_PROPERTY(QString modeRefinedTuningOuter READ qmlModeRefinedTuningOuter CONSTANT)
    Q_PROPERTY(QString modeRefinedPrefix READ qmlModeRefinedPrefix CONSTANT)

    // Status strings
    Q_PROPERTY(QString statusFlying READ qmlStatusFlying CONSTANT)
    Q_PROPERTY(QString statusArmedIdle READ qmlStatusArmedIdle CONSTANT)
    Q_PROPERTY(QString statusArmed READ qmlStatusArmed CONSTANT)
    Q_PROPERTY(QString statusReadyToFly READ qmlStatusReadyToFly CONSTANT)
    Q_PROPERTY(QString statusNotReady READ qmlStatusNotReady CONSTANT)

    // Mission status strings
    Q_PROPERTY(QString missionStatusIdle READ qmlMissionStatusIdle CONSTANT)
    Q_PROPERTY(QString missionStatusReady READ qmlMissionStatusReady CONSTANT)
    Q_PROPERTY(QString missionStatusExecuting READ qmlMissionStatusExecuting CONSTANT)
    Q_PROPERTY(QString missionStatusFailed READ qmlMissionStatusFailed CONSTANT)
    Q_PROPERTY(QString missionStatusCanceled READ qmlMissionStatusCanceled CONSTANT)
    Q_PROPERTY(QString missionStatusScheduledPause READ qmlMissionStatusScheduledPause CONSTANT)
    Q_PROPERTY(QString missionStatusPausedMidStep READ qmlMissionStatusPausedMidStep CONSTANT)
    Q_PROPERTY(QString missionStatusPausedBetweenSteps READ qmlMissionStatusPausedBetweenSteps CONSTANT)
    Q_PROPERTY(QString missionStatusCompleted READ qmlMissionStatusCompleted CONSTANT)
    Q_PROPERTY(QString missionStatusSafety READ qmlMissionStatusSafety CONSTANT)

    // Joystick mode strings
    Q_PROPERTY(QString joystickModeDisabled READ qmlJoystickModeDisabled CONSTANT)
    Q_PROPERTY(QString joystickModeEnabledAlways READ qmlJoystickModeEnabledAlways CONSTANT)
    Q_PROPERTY(QString joystickModeEnabledOnPause READ qmlJoystickModeEnabledOnPause CONSTANT)

    // Mission step type strings
    Q_PROPERTY(QString stepTypeIdle READ qmlStepTypeIdle CONSTANT)
    Q_PROPERTY(QString stepTypeGotoGps READ qmlStepTypeGotoGps CONSTANT)
    Q_PROPERTY(QString stepTypeGotoAbsolute READ qmlStepTypeGotoAbsolute CONSTANT)
    Q_PROPERTY(QString stepTypeGotoRelative READ qmlStepTypeGotoRelative CONSTANT)
    Q_PROPERTY(QString stepTypeYawAbsolute READ qmlStepTypeYawAbsolute CONSTANT)
    Q_PROPERTY(QString stepTypeYawRelative READ qmlStepTypeYawRelative CONSTANT)
    Q_PROPERTY(QString stepTypeTakeoff READ qmlStepTypeTakeoff CONSTANT)
    Q_PROPERTY(QString stepTypeWait READ qmlStepTypeWait CONSTANT)
    Q_PROPERTY(QString stepTypeLand READ qmlStepTypeLand CONSTANT)
    Q_PROPERTY(QString stepTypeRtl READ qmlStepTypeRtl CONSTANT)

private:
    // QML property read functions
    QString qmlModeRCStabilized() const { return modeRCStabilized(); }
    QString qmlModeRCPosition() const { return modeRCPosition(); }
    QString qmlModeLeafSDKMission() const { return modeLeafSDKMission(); }
    QString qmlModeRollPitchLearning() const { return modeRollPitchLearning(); }
    QString qmlModeLearningOuter() const { return modeLearningOuter(); }
    QString qmlModeLearningFull() const { return modeLearningFull(); }
    QString qmlModeRefinedTuning() const { return modeRefinedTuning(); }
    QString qmlModeRefinedTuningCollect() const { return modeRefinedTuningCollect(); }
    QString qmlModeRefinedTuningOuter() const { return modeRefinedTuningOuter(); }
    QString qmlModeRefinedPrefix() const { return modeRefinedPrefix(); }
    QString qmlStatusFlying() const { return statusFlying(); }
    QString qmlStatusArmedIdle() const { return statusArmedIdle(); }
    QString qmlStatusArmed() const { return statusArmed(); }
    QString qmlStatusReadyToFly() const { return statusReadyToFly(); }
    QString qmlStatusNotReady() const { return statusNotReady(); }
    QString qmlMissionStatusIdle() const { return missionStatusIdle(); }
    QString qmlMissionStatusReady() const { return missionStatusReady(); }
    QString qmlMissionStatusExecuting() const { return missionStatusExecuting(); }
    QString qmlMissionStatusFailed() const { return missionStatusFailed(); }
    QString qmlMissionStatusCanceled() const { return missionStatusCanceled(); }
    QString qmlMissionStatusScheduledPause() const { return missionStatusScheduledPause(); }
    QString qmlMissionStatusPausedMidStep() const { return missionStatusPausedMidStep(); }
    QString qmlMissionStatusPausedBetweenSteps() const { return missionStatusPausedBetweenSteps(); }
    QString qmlMissionStatusCompleted() const { return missionStatusCompleted(); }
    QString qmlMissionStatusSafety() const { return missionStatusSafety(); }

    QString qmlJoystickModeDisabled() const { return joystickModeDisabled(); }
    QString qmlJoystickModeEnabledAlways() const { return joystickModeEnabledAlways(); }
    QString qmlJoystickModeEnabledOnPause() const { return joystickModeEnabledOnPause(); }

    QString qmlStepTypeIdle() const { return stepTypeIdle(); }
    QString qmlStepTypeGotoGps() const { return stepTypeGotoGps(); }
    QString qmlStepTypeGotoAbsolute() const { return stepTypeGotoAbsolute(); }
    QString qmlStepTypeGotoRelative() const { return stepTypeGotoRelative(); }
    QString qmlStepTypeYawAbsolute() const { return stepTypeYawAbsolute(); }
    QString qmlStepTypeYawRelative() const { return stepTypeYawRelative(); }
    QString qmlStepTypeTakeoff() const { return stepTypeTakeoff(); }
    QString qmlStepTypeWait() const { return stepTypeWait(); }
    QString qmlStepTypeLand() const { return stepTypeLand(); }
    QString qmlStepTypeRtl() const { return stepTypeRtl(); }
};
