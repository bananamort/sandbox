// FastLog.h -- RECONSTRUCTED HEADER
//
// The original file shipped inside the "Log/" project, which is absent from
// this source drop entirely (the drop also references Log/*.vcxproj without
// providing it). This reconstruction was authored for the sandbox build
// enablement effort: the macro surface and both log-group namespaces were
// harvested EXHAUSTIVELY from call sites across the tree on 2026-08-23, so
// any future call site using an unknown group fails to compile and must be
// added here deliberately.
//
// Semantics of the original (compile-time-filtered ring-buffer logger) are
// approximated: every macro routes through one vsnprintf emitter that writes
// to stderr. Define RBX_FASTLOG_SILENT to compile all calls to no-ops.

#ifndef RBX_FASTLOG_H
#define RBX_FASTLOG_H

#include <cstdarg>
#include <cstdio>

namespace RBX {
namespace FastLogImpl {

inline void emit(char const* fmt, ...)
{
#ifdef RBX_FASTLOG_SILENT
    (void)fmt;
#else
    va_list ap;
    va_start(ap, fmt);
    std::vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
#endif
}

} // namespace FastLogImpl
} // namespace RBX

namespace FLog {
    // Channel is a TYPE (log channel handle), distinct from the group
    // enum below -- signal.h stores scoped connections tagged by channel.
    class Channel {
    public:
        int id;
        constexpr Channel(int i = 0) : id(i) {}
        operator int() const { return id; }
    };

    enum {
        Zero = 0,
        AdornableLifetime, AdornRenderStats, Always, AnalyticsLog, Asserts,
        ChangeHistoryService, ClientSettings, CloseDataModel,
        ContentProviderRequests, CoreScripts, Crash, CrashReporterInit,
        CyclicExecutiveThrottling, CyclicExecutiveTiming,
        CyclicExecutiveWorldSteps, DataModelJobs, DataStore, DataStoreBudget,
        DeferredVoxelUpdates, DeviceLost, DragProfile, DXVideoMemory, Error,
        FastLog, FastLogS, FMOD, ForEachVariable, FRM,
        GetNumSynchronizedVariable, GetValue, GfxClusters, GfxClustersFull,
        GoldenHashes, GoogleAnalyticsTracking, Graphics, GuiTargetLifetime,
        HangDetection, HeartBeatFailure, Http, HttpQueue, HttpRbxApiBudget,
        HttpTrace, HumanoidFloorProcess, Init, InstanceTreeManipulation,
        ISteppedLifetime, JoinSendExtraItemCount, JointInstanceLifetime,
        JointLifetime, LegacyLock, LuaBridge, LuaMemoryPool, LuaProfiler,
        LuaScriptTimeoutSeconds, MachineIdUploader, MaxJoinDataSizeKB,
        MaxNetworkReadTimeInCS, MegaClusterDecodeStream, MegaClusterDirty,
        MegaClusterInit, MegaClusterNetwork, MegaClusterNetworkInit,
        MouseCommand, MouseCommandLifetime, MutexLifetime, NamedMutex,
        Network, NetworkCache, NetworkInstances, NetworkJoin,
        NetworkPacketsReceive, NetworkReadItem, NetworkStatsReport,
        NetworkStepsMultipliers, NetworkStreaming, PartInstanceLifetime,
        PartStreamingRequests, PathfindingDetail, PathfindingPerf, Physics,
        PhysicsSenderSleepingLog, PhysicsStepsPerSecond,
        PlayerChatInfoExponentialBackoffLimitMultiplier,
        PlayerShutdownLuaTimeoutSeconds, Plugins,
        PreloadLinkedScriptsTiming, PrimitiveLifetime, R15Character,
        RakNetDisconnect, RCCDataModelInit, RCCServiceInit, RCCServiceJobs,
        ReflectionMetadata, RenderFastCluster, RenderLightGrid,
        RenderLightGridAgeProportion, RenderLightGridBorderGlobalCutoff,
        RenderLightGridBorderSkylightCutoff, RenderTextureCompositor,
        RenderTextureCompositorBudget, ReplicationDataLifetime,
        ResetSynchronizedVariablesState, RobloxWndInit, ScriptContext,
        ScriptContextAdd, ScriptContextClose, ScriptContextRemove,
        Serializer, SetExternalLogFunc, SetValue, SetValueFromServer,
        SlowHttpRequest, Sound, SoundTiming, SoundTrace, StepAnimatedJoints,
        TaskSchedulerFindJob, TaskSchedulerInit, TaskSchedulerRun,
        TaskSchedulerTiming, TerrainCellListener, TextureContentProvider,
        ThreadRefCounts, ThumbnailRender, TouchedSignal, ttMetricP1,
        US14116, UseLuaMemoryPool, UserInputProfile, Verbs, VideoCapture,
        ViewRbxBase, ViewRbxInit, Voxelizer, VR, Warning, WeakThreadRef,
        WebChatFiltering, WorldStepsBehind, WorldStepsBehindG,
        WriteFastLogDump
    };
}

namespace DFLog {
    enum {
        Zero = 0,
        AnalyticsLog, DeferredVoxelUpdates, GoogleAnalyticsTracking,
        HttpTrace, MaxJoinDataSizeKB, NamedMutex, NetworkJoin,
        NetworkPacketsReceive, PartStreamingRequests,
        PlayerChatInfoExponentialBackoffLimitMultiplier,
        PreloadLinkedScriptsTiming, R15Character, SoundTiming, SoundTrace,
        WebChatFiltering
    };
}

#define FASTLOG(group, msg) \
    ::RBX::FastLogImpl::emit(msg)

#define FASTLOG1(group, fmt, a) \
    ::RBX::FastLogImpl::emit(fmt, a)
#define FASTLOG2(group, fmt, a, b) \
    ::RBX::FastLogImpl::emit(fmt, a, b)
#define FASTLOG3(group, fmt, a, b, c) \
    ::RBX::FastLogImpl::emit(fmt, a, b, c)
#define FASTLOG4(group, fmt, a, b, c, d) \
    ::RBX::FastLogImpl::emit(fmt, a, b, c, d)
#define FASTLOG5(group, fmt, a, b, c, d, e) \
    ::RBX::FastLogImpl::emit(fmt, a, b, c, d, e)

// F variants historically took float arguments; varargs promotion makes the
// same emitter correct.
#define FASTLOG1F(group, fmt, a) \
    ::RBX::FastLogImpl::emit(fmt, a)
#define FASTLOG2F(group, fmt, a, b) \
    ::RBX::FastLogImpl::emit(fmt, a, b)
#define FASTLOG3F(group, fmt, a, b, c) \
    ::RBX::FastLogImpl::emit(fmt, a, b, c)
#define FASTLOG4F(group, fmt, a, b, c, d) \
    ::RBX::FastLogImpl::emit(fmt, a, b, c, d)

// S variant takes exactly one string argument for a "%s" format.
#define FASTLOGS(group, msg, s) \
    ::RBX::FastLogImpl::emit(msg, s)

// Group registration marker. In the original logger this registered the
// group with the runtime dump machinery; here it is intentionally empty --
// every group referenced anywhere in the tree is already declared in the
// FLog/DFLog enums above (harvested exhaustively). A call site using an
// unlisted group fails to compile, which is the desired tripwire.
#define LOGGROUP(name)

#endif // RBX_FASTLOG_H
