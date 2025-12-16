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
        LearningInner,          // LEAF_MODE_LEARNING_INNER
        LearningOuter,          // LEAF_MODE_LEARNING_OUTER
        LearningFull,           // LEAF_MODE_LEARNING_FULL
        RefinedTuning,          // LEAF_MODE_REFINED_TUNING_ONLINE
        RefinedTuningCollect,   // LEAF_MODE_REFINED_TUNING_OFFLINE
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
        Idle,       // LEAF_MISSION_STATUS_IDLE
        Ready,      // LEAF_MISSION_STATUS_READY
        Executing,  // LEAF_MISSION_STATUS_EXECUTING
        Paused,     // LEAF_MISSION_STATUS_PAUSED
        Canceled,   // LEAF_MISSION_STATUS_CANCELED (UI only)
        Aborted     // LEAF_MISSION_STATUS_ABORTED (UI only)
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
    static const QString& modeLearningInner();
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
    static const QString& missionStatusPrefix();      // "MISSION STATUS: "
    static const QString& missionStatusIdle();        // "MISSION STATUS: IDLE"
    static const QString& missionStatusReady();       // "MISSION STATUS: READY"
    static const QString& missionStatusExecuting();   // "MISSION STATUS: EXECUTING"
    static const QString& missionStatusPaused();      // "MISSION STATUS: PAUSED"
    static const QString& missionStatusCanceled();    // "MISSION STATUS: CANCELED"
    static const QString& missionStatusAborted();     // "MISSION STATUS: ABORTED"

    // ========== Enum-to-String Maps ==========
    static const QMap<int, QString>& modeNames();
    static const QMap<int, QString>& statusTexts();
    static const QMap<int, QString>& missionStatusTexts();

    // ========== Q_PROPERTY for QML ==========
    // Mode strings
    Q_PROPERTY(QString modeRCStabilized READ qmlModeRCStabilized CONSTANT)
    Q_PROPERTY(QString modeRCPosition READ qmlModeRCPosition CONSTANT)
    Q_PROPERTY(QString modeLeafSDKMission READ qmlModeLeafSDKMission CONSTANT)
    Q_PROPERTY(QString modeLearningInner READ qmlModeLearningInner CONSTANT)
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
    Q_PROPERTY(QString missionStatusPrefix READ qmlMissionStatusPrefix CONSTANT)
    Q_PROPERTY(QString missionStatusIdle READ qmlMissionStatusIdle CONSTANT)
    Q_PROPERTY(QString missionStatusReady READ qmlMissionStatusReady CONSTANT)
    Q_PROPERTY(QString missionStatusExecuting READ qmlMissionStatusExecuting CONSTANT)
    Q_PROPERTY(QString missionStatusPaused READ qmlMissionStatusPaused CONSTANT)
    Q_PROPERTY(QString missionStatusCanceled READ qmlMissionStatusCanceled CONSTANT)
    Q_PROPERTY(QString missionStatusAborted READ qmlMissionStatusAborted CONSTANT)

private:
    // QML property read functions
    QString qmlModeRCStabilized() const { return modeRCStabilized(); }
    QString qmlModeRCPosition() const { return modeRCPosition(); }
    QString qmlModeLeafSDKMission() const { return modeLeafSDKMission(); }
    QString qmlModeLearningInner() const { return modeLearningInner(); }
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
    QString qmlMissionStatusPrefix() const { return missionStatusPrefix(); }
    QString qmlMissionStatusIdle() const { return missionStatusIdle(); }
    QString qmlMissionStatusReady() const { return missionStatusReady(); }
    QString qmlMissionStatusExecuting() const { return missionStatusExecuting(); }
    QString qmlMissionStatusPaused() const { return missionStatusPaused(); }
    QString qmlMissionStatusCanceled() const { return missionStatusCanceled(); }
    QString qmlMissionStatusAborted() const { return missionStatusAborted(); }
};
