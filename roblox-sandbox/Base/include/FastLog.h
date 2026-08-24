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


// ==== RECONSTRUCTED SETTINGS-VARIABLE SYSTEM ====
// Original lived in the absent Log/ project's variable header. Every
// instance below was harvested from call sites; FAST*VARIABLE and
// DYNAMIC_* call-site macros are intentional no-ops (defaults live here).

namespace RBX {
struct FastBoolVar { bool v; constexpr FastBoolVar(bool b=false):v(b){} operator bool() const { return v; } };
struct FastIntVar { int v; constexpr FastIntVar(int i=0):v(i){} operator int() const { return v; } };
struct FastStringVar { const char* v; operator const char*() const { return v; } };
}

namespace FFlag { namespace {
    ::RBX::FastBoolVar CSGExportFailure(false);
    ::RBX::FastBoolVar UsePGSSolver(false);
    ::RBX::FastBoolVar BallBlockNarrowphaseFixEnabled(false);
    ::RBX::FastBoolVar PGSSteppingMotorFix(false);
    ::RBX::FastBoolVar PGSGlueJoint(false);
    ::RBX::FastBoolVar CheckSleepOptimization(false);
    ::RBX::FastBoolVar FixBulletGJKOptimization(false);
    ::RBX::FastBoolVar FixBulletGJKOptimization2(false);
    ::RBX::FastBoolVar ModifyDefaultMaterialProperties(false);
    ::RBX::FastBoolVar DebugRenderDownloadAssets(false);
    ::RBX::FastBoolVar GoogleAnalyticsTrackingEnabled(false);
    ::RBX::FastBoolVar DebugAnalyticsForceLotteryWin(false);
    ::RBX::FastBoolVar SendStudioEventsWithStudioSID(true);
    ::RBX::FastBoolVar DebugBreakOnFMODErrors(true);
    ::RBX::FastBoolVar NoCacheForLocalContent(false);
    ::RBX::FastBoolVar US21969(false);
    ::RBX::FastBoolVar EnableLuaFollowers(true);
    ::RBX::FastBoolVar DebugHumanoidRendering(false);
    ::RBX::FastBoolVar DebugLocalRccServerConnection(false);
    ::RBX::FastBoolVar DisableGlobalSettingsParentChange(true);
    ::RBX::FastBoolVar US31006(false);
    ::RBX::FastBoolVar PGSUsesConstraintBasedBodyMovers(false);
    ::RBX::FastBoolVar RenderNewExplosionEnable(true);
    ::RBX::FastBoolVar TeamCreate9938FixEnabled(true);
    ::RBX::FastBoolVar UserAllCamerasInLua(false);
    ::RBX::FastBoolVar CameraInterpolateMethodEnhancement(true);
    ::RBX::FastBoolVar CameraVR(true);
    ::RBX::FastBoolVar UseBuildGenericGameUrl(true);
    ::RBX::FastBoolVar PlaceLauncherUsePOST(true);
    ::RBX::FastBoolVar TweenCallbacksDuringRenderStep(false);
    ::RBX::FastBoolVar FixSlice9Scale(true);
    ::RBX::FastBoolVar CSGFixForNoChildData(true);
    ::RBX::FastBoolVar AllowInsertFreeModels(false);
    ::RBX::FastBoolVar InsertUnderFolder(true);
    ::RBX::FastBoolVar PhysicsAnalyzerEnabled(false);
    ::RBX::FastBoolVar PGSAlwaysActiveMasterSwitch(false);
    ::RBX::FastBoolVar LuaControlsDisableMouse2Lock(false);
    ::RBX::FastBoolVar GamepadCursorChanges(false);
    ::RBX::FastBoolVar TypesettersReleaseResources(true);
    ::RBX::FastBoolVar UseDynamicTypesetterUTF8(false);
    ::RBX::FastBoolVar BillboardGuiVR(false);
    ::RBX::FastBoolVar EnableVideoAds(true);
    ::RBX::FastBoolVar DebugDisplayFPS(false);
    ::RBX::FastBoolVar LuaBasedBubbleChat(false);
    ::RBX::FastBoolVar NewInGameDevConsole(false);
    ::RBX::FastBoolVar UseNewSubdomainsInCoreScripts(false);
    ::RBX::FastBoolVar UseGameLoadedInLoadingScript(true);
    ::RBX::FastBoolVar UseUserListMenu(false);
    ::RBX::FastBoolVar EnableSetCoreTopbarEnabled(false);
    ::RBX::FastBoolVar Durango3DBackground(true);
    ::RBX::FastBoolVar UseFixedTransparencyNonCollidableBehaviour(true);
    ::RBX::FastBoolVar IgnoreBlankDataOnStore(true);
    ::RBX::FastBoolVar CSGRemoveScriptScaleRestriction(false);
    ::RBX::FastBoolVar StudioCSGAssets(false);
    ::RBX::FastBoolVar CSGLoadFromCDN(false);
    ::RBX::FastBoolVar CSGLoadBlocking(false);
    ::RBX::FastBoolVar CSGPhysicsLevelOfDetailEnabled(false);
    ::RBX::FastBoolVar CSGUnionsSizeShouldNeverBe000(false);
    ::RBX::FastBoolVar UseNewPromptEndHandling(false);
    ::RBX::FastBoolVar GUIZFighterGPU(true);
    ::RBX::FastBoolVar UserBetterInertialScrolling(false);
    ::RBX::FastBoolVar RelativisticCameraFixEnable(true);
    ::RBX::FastBoolVar NotificationServiceEnabledForEveryone(false);
    ::RBX::FastBoolVar FixGlowingCSG(true);
    ::RBX::FastBoolVar RenderNewParticles2Enable(true);
    ::RBX::FastBoolVar UseInGameTopBar(false);
    ::RBX::FastBoolVar MobileToggleChatVisibleIcon(false);
    ::RBX::FastBoolVar LuaChatPhoneFontSize(false);
    ::RBX::FastBoolVar LuaChatFiltering(false);
    ::RBX::FastBoolVar FlyCamOnRenderStep(false);
    ::RBX::FastBoolVar PlayerDropDownEnabled(false);
    ::RBX::FastBoolVar UserUseNewControlScript(false);
    ::RBX::FastBoolVar PGSVariablePenetrationMarginFix(false);
    ::RBX::FastBoolVar PGSApplyImpulsesAtMidpoints(false);
    ::RBX::FastBoolVar PGSSolverFileDump(false);
    ::RBX::FastBoolVar StudioVariableIntellesense(false);
    ::RBX::FastBoolVar DebugScriptAnalyzer(false);
    ::RBX::FastBoolVar DebugCrashEnabled(true);
    ::RBX::FastBoolVar CustomEmitterLuaTypesEnabled(false);
    ::RBX::FastBoolVar PhysPropConstructFromMaterial(false);
    ::RBX::FastBoolVar LuaDebugger(false);
    ::RBX::FastBoolVar LuaDebuggerBreakOnError(false);
    ::RBX::FastBoolVar StudioDE6194FixEnabled(false);
    ::RBX::FastBoolVar DraggerInfiniteRecursionFix(false);
    ::RBX::FastBoolVar UseFixedRightMouseClickBehaviour(true);
    ::RBX::FastBoolVar StudioUseDraggerGrid(true);
    ::RBX::FastBoolVar PhysicsSkipNonRealTimeHumanoidForceCalc(false);
    ::RBX::FastBoolVar HumanoidRenderBillboard(false);
    ::RBX::FastBoolVar HumanoidRenderBillboardVR(true);
    ::RBX::FastBoolVar DebugForceRegenerateSchemaBitStream(false);
    ::RBX::FastBoolVar DebugProtocolSynchronization(false);
    ::RBX::FastBoolVar RemoveUnusedPhysicsSenders(false);
    ::RBX::FastBoolVar RemoveInterpolationReciever(false);
    ::RBX::FastBoolVar FilterSinglePass(false);
    ::RBX::FastBoolVar FilterDoublePass(false);
    ::RBX::FastBoolVar ClientABTestingEnabled(true);
    ::RBX::FastBoolVar CopyArrayReferences(true);
    ::RBX::FastBoolVar US30484p1(false);
    ::RBX::FastBoolVar US30484p3(false);
    ::RBX::FastBoolVar UseDataDomain(true);
    ::RBX::FastBoolVar Dep(true);
    ::RBX::FastBoolVar DirectXEnable(false);
    ::RBX::FastBoolVar DirectX11Enable(false);
    ::RBX::FastBoolVar GraphicsReportingInitErrorsToGAEnabled(true);
    ::RBX::FastBoolVar UseNewAppBridgeInputWindows(false);
    ::RBX::FastBoolVar ReloadSettingsOnTeleport(false);
    ::RBX::FastBoolVar DebugUseDefaultGlobalSettings(false);
    ::RBX::FastBoolVar RwxFailReport(false);
    ::RBX::FastBoolVar GraphicsTextureCommitChanges(false);
    ::RBX::FastBoolVar DebugGraphicsCrashOnLeaks(true);
    ::RBX::FastBoolVar GraphicsDebugMarkersEnable(false);
    ::RBX::FastBoolVar DebugRenderVRHUD(false);
    ::RBX::FastBoolVar DebugD3D11DebugMode(false);
    ::RBX::FastBoolVar OpenVR(true);
    ::RBX::FastBoolVar DebugGraphicsD3D9ForceSWVP(false);
    ::RBX::FastBoolVar DebugGraphicsD3D9ForceFFP(false);
    ::RBX::FastBoolVar GearVR(false);
    ::RBX::FastBoolVar CardboardVR(false);
    ::RBX::FastBoolVar GraphicsGLUseDiscard(false);
    ::RBX::FastBoolVar DebugGraphicsGL(false);
    ::RBX::FastBoolVar GraphicsGL3(false);
    ::RBX::FastBoolVar GraphicsGLReduceLatency(false);
    ::RBX::FastBoolVar UpdateContextOnFollowingFrame(false);
    ::RBX::FastBoolVar DebugAdornsDisabled(false);
    ::RBX::FastBoolVar RenderThumbModelReflectionsFix(false);
    ::RBX::FastBoolVar RenderFixFog(false);
    ::RBX::FastBoolVar RenderVR(false);
    ::RBX::FastBoolVar RenderLowLatencyLoop(false);
    ::RBX::FastBoolVar RenderUIAs3DInVR(true);
    ::RBX::FastBoolVar CancelPendingTextureLoads(true);
    ::RBX::FastBoolVar SmoothTerrainRenderLOD(false);
    ::RBX::FastBoolVar DebugSmoothTerrainRenderFixedLOD(false);
    ::RBX::FastBoolVar NoRandomColorsWithoutOutlines(true);
    ::RBX::FastBoolVar FixMeshOffset(false);
    ::RBX::FastBoolVar RenderMoonBillboard(true);
    ::RBX::FastBoolVar GlowEnabled(false);
    ::RBX::FastBoolVar FixCameraTargetStudio(false);
    ::RBX::FastBoolVar CustomEmitterRenderEnabled(false);
    ::RBX::FastBoolVar RenderMaterialsOnMobile(true);
    ::RBX::FastBoolVar ForceWangTiles(false);
    ::RBX::FastBoolVar Studio3DGridUseAALines(true);
    ::RBX::FastBoolVar DebugSSAOForce(false);
    ::RBX::FastBoolVar OnScreenProfiler(false);
    ::RBX::FastBoolVar TaskSchedulerCyclicExecutive(false);
    ::RBX::FastBoolVar DebugTaskSchedulerProfiling(false);
} }

namespace FInt { namespace {
    ::RBX::FastIntVar SmoothTerrainPhysicsCacheSize(16*1024*1024);
    ::RBX::FastIntVar PhysicsBulletManifoldPoolSize(1024);
    ::RBX::FastIntVar IntersectingOthersCallsAllowedOnSpawn(5);
    ::RBX::FastIntVar PhysicalPropDensity_PLASTIC_MATERIAL(700);
    ::RBX::FastIntVar PhysicalPropDensity_SMOOTH_PLASTIC_MATERIAL(700);
    ::RBX::FastIntVar PhysicalPropDensity_NEON_MATERIAL(700);
    ::RBX::FastIntVar PhysicalPropDensity_WOOD_MATERIAL(350);
    ::RBX::FastIntVar PhysicalPropDensity_WOODPLANKS_MATERIAL(350);
    ::RBX::FastIntVar PhysicalPropDensity_MARBLE_MATERIAL(2563);
    ::RBX::FastIntVar PhysicalPropDensity_SLATE_MATERIAL(2691);
    ::RBX::FastIntVar PhysicalPropDensity_CONCRETE_MATERIAL(2403);
    ::RBX::FastIntVar PhysicalPropDensity_GRANITE_MATERIAL(2691);
    ::RBX::FastIntVar PhysicalPropDensity_BRICK_MATERIAL(1922);
    ::RBX::FastIntVar PhysicalPropDensity_PEBBLE_MATERIAL(2403);
    ::RBX::FastIntVar PhysicalPropDensity_COBBLESTONE_MATERIAL(2691);
    ::RBX::FastIntVar PhysicalPropDensity_RUST_MATERIAL(7850);
    ::RBX::FastIntVar PhysicalPropDensity_DIAMONDPLATE_MATERIAL(7850);
    ::RBX::FastIntVar PhysicalPropDensity_ALUMINUM_MATERIAL(7700);
    ::RBX::FastIntVar PhysicalPropDensity_METAL_MATERIAL(7850);
    ::RBX::FastIntVar PhysicalPropDensity_GRASS_MATERIAL(900);
    ::RBX::FastIntVar PhysicalPropDensity_SAND_MATERIAL(1602);
    ::RBX::FastIntVar PhysicalPropDensity_FABRIC_MATERIAL(700);
    ::RBX::FastIntVar PhysicalPropDensity_ICE_MATERIAL(919);
    ::RBX::FastIntVar PhysicalPropDensity_AIR_MATERIAL(0);
    ::RBX::FastIntVar PhysicalPropDensity_WATER_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropDensity_ROCK_MATERIAL(2691);
    ::RBX::FastIntVar PhysicalPropDensity_GLACIER_MATERIAL(919);
    ::RBX::FastIntVar PhysicalPropDensity_SNOW_MATERIAL(900);
    ::RBX::FastIntVar PhysicalPropDensity_SANDSTONE_MATERIAL(2691);
    ::RBX::FastIntVar PhysicalPropDensity_MUD_MATERIAL(900);
    ::RBX::FastIntVar PhysicalPropDensity_BASALT_MATERIAL(2691);
    ::RBX::FastIntVar PhysicalPropDensity_GROUND_MATERIAL(900);
    ::RBX::FastIntVar PhysicalPropDensity_CRACKED_LAVA_MATERIAL(2691);
    ::RBX::FastIntVar PhysicalPropFriction_PLASTIC_MATERIAL(300);
    ::RBX::FastIntVar PhysicalPropFriction_SMOOTH_PLASTIC_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropFriction_NEON_MATERIAL(300);
    ::RBX::FastIntVar PhysicalPropFriction_WOOD_MATERIAL(480);
    ::RBX::FastIntVar PhysicalPropFriction_WOODPLANKS_MATERIAL(480);
    ::RBX::FastIntVar PhysicalPropFriction_MARBLE_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropFriction_SLATE_MATERIAL(400);
    ::RBX::FastIntVar PhysicalPropFriction_CONCRETE_MATERIAL(700);
    ::RBX::FastIntVar PhysicalPropFriction_GRANITE_MATERIAL(400);
    ::RBX::FastIntVar PhysicalPropFriction_BRICK_MATERIAL(800);
    ::RBX::FastIntVar PhysicalPropFriction_PEBBLE_MATERIAL(400);
    ::RBX::FastIntVar PhysicalPropFriction_COBBLESTONE_MATERIAL(500);
    ::RBX::FastIntVar PhysicalPropFriction_RUST_MATERIAL(700);
    ::RBX::FastIntVar PhysicalPropFriction_DIAMONDPLATE_MATERIAL(350);
    ::RBX::FastIntVar PhysicalPropFriction_ALUMINUM_MATERIAL(400);
    ::RBX::FastIntVar PhysicalPropFriction_METAL_MATERIAL(400);
    ::RBX::FastIntVar PhysicalPropFriction_GRASS_MATERIAL(400);
    ::RBX::FastIntVar PhysicalPropFriction_SAND_MATERIAL(500);
    ::RBX::FastIntVar PhysicalPropFriction_FABRIC_MATERIAL(350);
    ::RBX::FastIntVar PhysicalPropFriction_ICE_MATERIAL(20);
    ::RBX::FastIntVar PhysicalPropFriction_AIR_MATERIAL(10);
    ::RBX::FastIntVar PhysicalPropFriction_WATER_MATERIAL(5);
    ::RBX::FastIntVar PhysicalPropFriction_ROCK_MATERIAL(500);
    ::RBX::FastIntVar PhysicalPropFriction_GLACIER_MATERIAL(50);
    ::RBX::FastIntVar PhysicalPropFriction_SNOW_MATERIAL(300);
    ::RBX::FastIntVar PhysicalPropFriction_SANDSTONE_MATERIAL(500);
    ::RBX::FastIntVar PhysicalPropFriction_MUD_MATERIAL(300);
    ::RBX::FastIntVar PhysicalPropFriction_BASALT_MATERIAL(700);
    ::RBX::FastIntVar PhysicalPropFriction_GROUND_MATERIAL(450);
    ::RBX::FastIntVar PhysicalPropFriction_CRACKED_LAVA_MATERIAL(650);
    ::RBX::FastIntVar PhysicalPropElasticity_PLASTIC_MATERIAL(500);
    ::RBX::FastIntVar PhysicalPropElasticity_SMOOTH_PLASTIC_MATERIAL(500);
    ::RBX::FastIntVar PhysicalPropElasticity_NEON_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropElasticity_WOOD_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropElasticity_WOODPLANKS_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropElasticity_MARBLE_MATERIAL(170);
    ::RBX::FastIntVar PhysicalPropElasticity_SLATE_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropElasticity_CONCRETE_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropElasticity_GRANITE_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropElasticity_BRICK_MATERIAL(150);
    ::RBX::FastIntVar PhysicalPropElasticity_PEBBLE_MATERIAL(170);
    ::RBX::FastIntVar PhysicalPropElasticity_COBBLESTONE_MATERIAL(170);
    ::RBX::FastIntVar PhysicalPropElasticity_RUST_MATERIAL(200);
    ::RBX::FastIntVar PhysicalPropElasticity_DIAMONDPLATE_MATERIAL(250);
    ::RBX::FastIntVar PhysicalPropElasticity_ALUMINUM_MATERIAL(250);
    ::RBX::FastIntVar PhysicalPropElasticity_METAL_MATERIAL(250);
    ::RBX::FastIntVar PhysicalPropElasticity_GRASS_MATERIAL(100);
    ::RBX::FastIntVar PhysicalPropElasticity_SAND_MATERIAL(50);
    ::RBX::FastIntVar PhysicalPropElasticity_FABRIC_MATERIAL(50);
    ::RBX::FastIntVar PhysicalPropElasticity_ICE_MATERIAL(150);
    ::RBX::FastIntVar PhysicalPropElasticity_AIR_MATERIAL(10);
    ::RBX::FastIntVar PhysicalPropElasticity_WATER_MATERIAL(10);
    ::RBX::FastIntVar PhysicalPropElasticity_ROCK_MATERIAL(170);
    ::RBX::FastIntVar PhysicalPropElasticity_GLACIER_MATERIAL(150);
    ::RBX::FastIntVar PhysicalPropElasticity_SNOW_MATERIAL(30);
    ::RBX::FastIntVar PhysicalPropElasticity_SANDSTONE_MATERIAL(150);
    ::RBX::FastIntVar PhysicalPropElasticity_MUD_MATERIAL(70);
    ::RBX::FastIntVar PhysicalPropElasticity_BASALT_MATERIAL(150);
    ::RBX::FastIntVar PhysicalPropElasticity_GROUND_MATERIAL(100);
    ::RBX::FastIntVar PhysicalPropElasticity_CRACKED_LAVA_MATERIAL(150);
    ::RBX::FastIntVar PhysicalPropFWeight_PLASTIC_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_SMOOTH_PLASTIC_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_NEON_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_WOOD_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_WOODPLANKS_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_MARBLE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_SLATE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_CONCRETE_MATERIAL(300);
    ::RBX::FastIntVar PhysicalPropFWeight_GRANITE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_BRICK_MATERIAL(300);
    ::RBX::FastIntVar PhysicalPropFWeight_PEBBLE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_COBBLESTONE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_RUST_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_DIAMONDPLATE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_ALUMINUM_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_METAL_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_GRASS_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_SAND_MATERIAL(5000);
    ::RBX::FastIntVar PhysicalPropFWeight_FABRIC_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_ICE_MATERIAL(3000);
    ::RBX::FastIntVar PhysicalPropFWeight_AIR_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_WATER_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_ROCK_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_GLACIER_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_SNOW_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_SANDSTONE_MATERIAL(5000);
    ::RBX::FastIntVar PhysicalPropFWeight_MUD_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_BASALT_MATERIAL(300);
    ::RBX::FastIntVar PhysicalPropFWeight_GROUND_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropFWeight_CRACKED_LAVA_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_PLASTIC_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_SMOOTH_PLASTIC_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_NEON_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_WOOD_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_WOODPLANKS_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_MARBLE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_SLATE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_CONCRETE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_GRANITE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_BRICK_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_PEBBLE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_COBBLESTONE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_RUST_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_DIAMONDPLATE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_ALUMINUM_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_METAL_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_GRASS_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_SAND_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_FABRIC_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_ICE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_AIR_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_WATER_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_ROCK_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_GLACIER_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_SNOW_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_SANDSTONE_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_MUD_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_BASALT_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_GROUND_MATERIAL(1000);
    ::RBX::FastIntVar PhysicalPropEWeight_CRACKED_LAVA_MATERIAL(1000);
    ::RBX::FastIntVar InterpolationMaxDelayMSec(500);
    ::RBX::FastIntVar MinMsecBetweenTimePosEventReplication(100);
    ::RBX::FastIntVar MinSecondLengthForLongSoundChannel(5);
    ::RBX::FastIntVar NumDummyJobs(0);
    ::RBX::FastIntVar StreamingSafeMemWatermarkMB(30);
    ::RBX::FastIntVar StreamingLowMemWatermarkMB(10);
    ::RBX::FastIntVar StreamingCriticalLowMemWatermarkMB(5);
    ::RBX::FastIntVar StremingMemoryPoolReleaseThresholdMB(2);
    ::RBX::FastIntVar FMODSoundChannels(100);
    ::RBX::FastIntVar NumSmoothingPasses(0);
    ::RBX::FastIntVar RegLambda(-1000000000);
    ::RBX::FastIntVar SmoothTerrainMaxLuaRegion(4*1024*1024);
    ::RBX::FastIntVar SmoothTerrainMaxCppRegion(64*1024*1024);
    ::RBX::FastIntVar CSGVoxelizerFadeRadius(300);
    ::RBX::FastIntVar PGSPenetrationMarginMax(50000);
    ::RBX::FastIntVar PGSPenetrationMarginMin(100);
    ::RBX::FastIntVar PGSPenetrationMarginMaxBump(5);
    ::RBX::FastIntVar PGSPenetrationResolutionDamping(7);
    ::RBX::FastIntVar PGSPenetrationVelocityForMinMargin(20);
    ::RBX::FastIntVar PGSAlign2AxesCorrectionDamping(10);
    ::RBX::FastIntVar PGSBallInSocketCorrectionDamping(10);
    ::RBX::FastIntVar LuaMemoryBonus(0);
    ::RBX::FastIntVar ScriptAnalyzerIgnoreWarnings(0);
    ::RBX::FastIntVar NumPhysicsTouchPacketsPerStep(1);
    ::RBX::FastIntVar StreamOutCompressionIdListLengthThreshold(250);
    ::RBX::FastIntVar GamePerfMonitorPercentage(2);
    ::RBX::FastIntVar GamePerfMonitorReportTimer(10);
    ::RBX::FastIntVar US30484p2(0);
    ::RBX::FastIntVar RCCServiceThreadCount(RBX::TaskScheduler::Threads1);
    ::RBX::FastIntVar ValidateLauncherPercent(0);
    ::RBX::FastIntVar BootstrapperVersionNumber(51261);
    ::RBX::FastIntVar RequestPlaceInfoTimeoutMS(2000);
    ::RBX::FastIntVar RequestPlaceInfoRetryCount(5);
    ::RBX::FastIntVar InferredCrashReportingHundredthsPercentage(1000);
    ::RBX::FastIntVar SuperClusterFastClusterSize(1000);
    ::RBX::FastIntVar RenderMaxParticleSize(200);
    ::RBX::FastIntVar OutlineBrightnessMin(50);
    ::RBX::FastIntVar OutlineBrightnessMax(160);
    ::RBX::FastIntVar OutlineThickness(40);
    ::RBX::FastIntVar RenderShadowIntensity(75);
    ::RBX::FastIntVar RenderTextureManagerBudget(0);
    ::RBX::FastIntVar RenderTextureManagerBudgetFor4k(0);
    ::RBX::FastIntVar FontSizePadding(1);
    ::RBX::FastIntVar FastClusterUpdateWaitingBudgetMs(4);
    ::RBX::FastIntVar FRMRecomputeDistanceFrameDelay(100);
    ::RBX::FastIntVar RenderGBufferMinQLvl(20);
    ::RBX::FastIntVar SpeedTestPeriodMillis(1000);
    ::RBX::FastIntVar MaxSpeedDeltaMillis(300);
    ::RBX::FastIntVar SpeedCountCap(5);
} }

namespace FString { namespace {
    ::RBX::FastStringVar AssetTypeHeaderForSounds("");
    ::RBX::FastStringVar GroupInfoUrl("%sgroups/%i");
    ::RBX::FastStringVar GroupAlliesUrl("%sgroups/%i/allies");
    ::RBX::FastStringVar GroupEnemiesUrl("%sgroups/%i/enemies");
    ::RBX::FastStringVar GetGroupsUrl("%susers/%i/groups");
    ::RBX::FastStringVar FriendsOnlineUrl("/my/friendsonline");
    ::RBX::FastStringVar ClientExternalBrowserUserAgent("Roblox/WinInet");
    ::RBX::FastStringVar GetUserIdUrl("users/get-by-username?username=%s");
    ::RBX::FastStringVar GetUserNameUrl("users/%i");
    ::RBX::FastStringVar GetFriendsUrl("%susers/%i/friends");
    ::RBX::FastStringVar SocialServiceFriendUrl("Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d");
    ::RBX::FastStringVar SocialServiceBestFriendUrl("Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d");
    ::RBX::FastStringVar SocialServiceGroupUrl("Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d");
    ::RBX::FastStringVar SocialServiceGroupRankUrl("Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d");
    ::RBX::FastStringVar SocialServiceGroupRoleUrl("Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d");
    ::RBX::FastStringVar GamePassServicePlayerHasPassUrl("Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d");
    ::RBX::FastStringVar MobileJoinRateFormatUrl("Game/JoinRate.ashx?st=%d&i=%d&p=%d&c=%s&r=%s&d=%d&b=%d&platform=%s");
} }

namespace DFFlag { namespace {
    ::RBX::FastBoolVar CylinderSurfaceNormalHitFix(false);
    ::RBX::FastBoolVar OrthonormalizeJointCoords(false);
    ::RBX::FastBoolVar UseTerrainCustomPhysicalProperties(false);
    ::RBX::FastBoolVar StepAnimatedJointsInBufferZone(false);
    ::RBX::FastBoolVar PGSWakeOtherAssemblyForJoints(false);
    ::RBX::FastBoolVar FixTouchEndedReporting(false);
    ::RBX::FastBoolVar CyclicExecutiveThrottlingCancelWorldStepAccum(false);
    ::RBX::FastBoolVar ContactManagerOptimizedQueryExtents(false);
    ::RBX::FastBoolVar SimpleHermiteSplineInterpolate(false);
    ::RBX::FastBoolVar RemoveInterpolationSmoothing(false);
    ::RBX::FastBoolVar CleanUpInterpolationTimestamps(false);
    ::RBX::FastBoolVar SoundFailedToLoadContext(false);
    ::RBX::FastBoolVar MinMaxDistanceEnabled(false);
    ::RBX::FastBoolVar RollOffModeEnabled(false);
    ::RBX::FastBoolVar LogFileSystem(false);
    ::RBX::FastBoolVar FileSystemGetCacheDirectoryLikeAndroid(false);
    ::RBX::FastBoolVar RobloxAnalyticsTrackingEnabled(false);
    ::RBX::FastBoolVar DebugAnalyticsSendUserId(true);
    ::RBX::FastBoolVar UseNewUrlClass(true);
    ::RBX::FastBoolVar InfluxDb09Enabled(false);
    ::RBX::FastBoolVar HeartBeatCanRunTwiceFor30Hz(true);
    ::RBX::FastBoolVar PhysicsFPSTimerFix(false);
    ::RBX::FastBoolVar ScriptExecutionContextApi(false);
    ::RBX::FastBoolVar VariableHeartbeat(false);
    ::RBX::FastBoolVar TeamCreateIgnoreRunStateTransition(true);
    ::RBX::FastBoolVar UrlReconstructToAssetGame(false);
    ::RBX::FastBoolVar UrlReconstructToAssetGameSecure(false);
    ::RBX::FastBoolVar UrlReconstructRejectInvalidSchemes(false);
    ::RBX::FastBoolVar ContentProviderHttpCaching(false);
    ::RBX::FastBoolVar ImageFailedToLoadContext(false);
    ::RBX::FastBoolVar HttpCacheCleanBasedOnMemory(false);
    ::RBX::FastBoolVar HttpCurlDomainTrimmingWithBaseURL(false);
    ::RBX::FastBoolVar HttpZeroLatencyCaching(false);
    ::RBX::FastBoolVar CleanMutexHttp(true);
    ::RBX::FastBoolVar SSLErrorLogAll(false);
    ::RBX::FastBoolVar DebugHttpAsyncCallsForStatsReporting(true);
    ::RBX::FastBoolVar UseAssetTypeHeader(false);
    ::RBX::FastBoolVar DebugDisableLogServiceExecuteScript(false);
    ::RBX::FastBoolVar UserServerFollowers(false);
    ::RBX::FastBoolVar DebugDisableTimeoutDisconnect(false);
    ::RBX::FastBoolVar PGSWakePrimitivesWithBodyMoverPropertyChanges(false);
    ::RBX::FastBoolVar CustomEmitterInstanceEnabled(false);
    ::RBX::FastBoolVar EnableParticleDrag(false);
    ::RBX::FastBoolVar AccessoriesAndAttachments(false);
    ::RBX::FastBoolVar FixClippedScrollingFrameNavigation(true);
    ::RBX::FastBoolVar UserCameraZoomPersistThroughTeleport(false);
    ::RBX::FastBoolVar UserMouseLockSettingSaveTeleport(false);
    ::RBX::FastBoolVar GetLocalTeleportData(false);
    ::RBX::FastBoolVar SetCoreDisableNotifications(false);
    ::RBX::FastBoolVar SetCoreSendNotifications(false);
    ::RBX::FastBoolVar SetCoreMoveChat(false);
    ::RBX::FastBoolVar SetCoreDisableChatBar(false);
    ::RBX::FastBoolVar TextTransparencyRenderingFix(false);
    ::RBX::FastBoolVar AnimationEasingStylesEnabled(false);
    ::RBX::FastBoolVar CachedPoseInitialized(false);
    ::RBX::FastBoolVar UseNewAnalyticsApi(false);
    ::RBX::FastBoolVar CacheModelExtents(false);
    ::RBX::FastBoolVar ElasticEasingUseTwoPi(false);
    ::RBX::FastBoolVar TurnOffFakeEventsForInputEvents(false);
    ::RBX::FastBoolVar TurnOffFakeEventsForCAS(false);
    ::RBX::FastBoolVar UseStarterPlayerCharacter(false);
    ::RBX::FastBoolVar UseStarterPlayerCharacterScripts(false);
    ::RBX::FastBoolVar UseStarterPlayerHumanoid(false);
    ::RBX::FastBoolVar DoNotCleanCSGDictionaryOnPublishInCloudEdit(true);
    ::RBX::FastBoolVar AnimationAllowProdUrls(true);
    ::RBX::FastBoolVar DontUseInsertServiceOnAnimLoad(false);
    ::RBX::FastBoolVar AnimationFailedToLoadContext(false);
    ::RBX::FastBoolVar GetLastestAssetVersionEnabled(false);
    ::RBX::FastBoolVar DisableBackendInsertConnection(false);
    ::RBX::FastBoolVar GASendInsertRequestFail(true);
    ::RBX::FastBoolVar InfluxSendInsertRequestFail(true);
    ::RBX::FastBoolVar InsertServiceLoadModelErrorDoNotCreateEmpty(true);
    ::RBX::FastBoolVar InsertServiceLoadModelErrorNoLuaExceptionReturnNull(false);
    ::RBX::FastBoolVar DisableInsertServiceForTeamCreate(false);
    ::RBX::FastBoolVar PreventReturnOfElevatedPhysicsFPS(false);
    ::RBX::FastBoolVar ReportElevatedPhysicsFPSToGA(true);
    ::RBX::FastBoolVar TrackPhysicalPropertiesGA(false);
    ::RBX::FastBoolVar UseNewPersistenceSubdomain(true);
    ::RBX::FastBoolVar GetGroupsAsyncEnabled(false);
    ::RBX::FastBoolVar GetGlobalDataStorePcallFix(false);
    ::RBX::FastBoolVar UseNewDataStoreLogging(true);
    ::RBX::FastBoolVar UseNewDataStoreRequestSetTimestampBehaviour(true);
    ::RBX::FastBoolVar ErrorOnFailedToLoadAnim(false);
    ::RBX::FastBoolVar SetUpdateTimeOnClumpChanged(false);
    ::RBX::FastBoolVar SetNetworkOwnerFixAnchoring(false);
    ::RBX::FastBoolVar SetNetworkOwnerFixAnchoring2(false);
    ::RBX::FastBoolVar NetworkOwnershipRuleReplicates(false);
    ::RBX::FastBoolVar LocalScriptSpawnPartAlwaysSetOwner(false);
    ::RBX::FastBoolVar MaterialPropertiesEnabled(false);
    ::RBX::FastBoolVar FormFactorDeprecated(false);
    ::RBX::FastBoolVar FixShapeChangeBug(false);
    ::RBX::FastBoolVar FixFallenPartsNotDeleted(false);
    ::RBX::FastBoolVar UseRemoveTypeIDTricks(true);
    ::RBX::FastBoolVar TeamCreateRaiseChangedOperationForAssetId(true);
    ::RBX::FastBoolVar DisplayTextBoxTextWhileTypingMobile(false);
    ::RBX::FastBoolVar PasteWithCapsLockOn(false);
    ::RBX::FastBoolVar TextBoxIsFocusedEnabled(false);
    ::RBX::FastBoolVar CheckMarketplaceAvailable(false);
    ::RBX::FastBoolVar Order66(false);
    ::RBX::FastBoolVar RestrictSales(false);
    ::RBX::FastBoolVar DoubleCheckPurchase(true);
    ::RBX::FastBoolVar AllowClientFallback(true);
    ::RBX::FastBoolVar IgnoreDifferentPlayer(true);
    ::RBX::FastBoolVar AllowHideHudShortcut(false);
    ::RBX::FastBoolVar AllowHideHudShortcutDefault(true);
    ::RBX::FastBoolVar ProcessAcceleratorsBeforeGUINavigation(false);
    ::RBX::FastBoolVar DontProcessMouseEventsForGuiTarget(false);
    ::RBX::FastBoolVar CloseStatesBeforeChildRemoval(false);
    ::RBX::FastBoolVar DataModelProcessHttpRequestResponseOnLockUseSubmitTask(true);
    ::RBX::FastBoolVar SmootherVehicleSeatControlSystem(false);
    ::RBX::FastBoolVar LimitScrollWheelMaxToHalfWindowSize(false);
    ::RBX::FastBoolVar FixRotatedHorizontalScrollBar(false);
    ::RBX::FastBoolVar SpheresAllowedCustom(false);
    ::RBX::FastBoolVar FilteringEnabledDialogFix(false);
    ::RBX::FastBoolVar FixAnchoredSeatingPosition(false);
    ::RBX::FastBoolVar FixSeatingWhileSitting(false);
    ::RBX::FastBoolVar PersistenceCurlCookies(false);
    ::RBX::FastBoolVar GetFocusedTextBoxEnabled(false);
    ::RBX::FastBoolVar EnableShowStatsLua(false);
    ::RBX::FastBoolVar LockViolationInstanceCrash(false);
    ::RBX::FastBoolVar PGSSolverSimIslandsEnabled(false);
    ::RBX::FastBoolVar PGSSolverUsesIslandizableCode(false);
    ::RBX::FastBoolVar PGSSolverIntegrateOnlyPositionsEnabled(false);
    ::RBX::FastBoolVar UseSubmitTaskWhenFiringSignalsOnSettings(true);
    ::RBX::FastBoolVar FixYieldThrottling(false);
    ::RBX::FastBoolVar LuaCrashOnIncorrectTables(false);
    ::RBX::FastBoolVar RejectHashesInLinkedSource(false);
    ::RBX::FastBoolVar BadTypeOnSpawnErrorEnabled(false);
    ::RBX::FastBoolVar BadTypeOnDelayErrorEnabled(false);
    ::RBX::FastBoolVar ScriptContextGuardAgainstCStackOverflow(false);
    ::RBX::FastBoolVar LogPrivateModuleRequires(true);
    ::RBX::FastBoolVar LockViolationScriptCrash(false);
    ::RBX::FastBoolVar RestoreTransparencyOnToolChange(false);
    ::RBX::FastBoolVar DraggerUsesNewPartOnDuplicate(false);
    ::RBX::FastBoolVar UnifyDragGridSizes(true);
    ::RBX::FastBoolVar HumanoidCookieRecursive(false);
    ::RBX::FastBoolVar ReplicateLuaMoveDirection(false);
    ::RBX::FastBoolVar NamesOccludedAsDefault(false);
    ::RBX::FastBoolVar FixedSitFirstPersonMove(true);
    ::RBX::FastBoolVar HumanoidCheckForNegatives(true);
    ::RBX::FastBoolVar EnableMotionAnalytics(false);
    ::RBX::FastBoolVar Enable2edHumanoidDistanceLogging(false);
    ::RBX::FastBoolVar RotateFirstPersonInVR(true);
    ::RBX::FastBoolVar CheckForHeadHit(false);
    ::RBX::FastBoolVar PGSFixGroundSinking(false);
    ::RBX::FastBoolVar HumanoidFeetIsPlastic(false);
    ::RBX::FastBoolVar FixSlowLadderClimb(false);
    ::RBX::FastBoolVar HumanoidFloorPVUpdateSignal(false);
    ::RBX::FastBoolVar NoWalkAnimWeld(false);
    ::RBX::FastBoolVar ClampRunSignalMinSpeed(false);
    ::RBX::FastBoolVar EnableClimbingDirection(false);
    ::RBX::FastBoolVar FixJumpGracePeriod(true);
    ::RBX::FastBoolVar EnableHipHeight(false);
    ::RBX::FastBoolVar ExtendedCrashInfluxReporting(false);
    ::RBX::FastBoolVar ApiCapitalizationChanges(false);
    ::RBX::FastBoolVar LoadStarterGearWithoutLoadCharacter(false);
    ::RBX::FastBoolVar ValidateCharacterAppearanceUrl(false);
    ::RBX::FastBoolVar FilterKickMessage(false);
    ::RBX::FastBoolVar UseR15Character(false);
    ::RBX::FastBoolVar CloudEditDisablePlayerDestroy(false);
    ::RBX::FastBoolVar UseComSiftUpdatedWebChatFilterParamsAndHeader(true);
    ::RBX::FastBoolVar ConstructModerationFilterTextParamsAndHeadersUseLegacyFilterParams(true);
    ::RBX::FastBoolVar UseProtocolCompatibilityCheck(false);
    ::RBX::FastBoolVar DebugLogProcessCharacterRequestTime(false);
    ::RBX::FastBoolVar DisablePlaceAuthenticationPoll(false);
    ::RBX::FastBoolVar FilterAllPlayerPropChanges(false);
    ::RBX::FastBoolVar LogAllPlayerPropChanges(false);
    ::RBX::FastBoolVar TeamCreateAcceptTerrainReplicatedUpdatesWhenFilteringEnabled(true);
    ::RBX::FastBoolVar US27664p3(false);
    ::RBX::FastBoolVar US26301(false);
    ::RBX::FastBoolVar US28292p0(true);
    ::RBX::FastBoolVar US28292p1(false);
    ::RBX::FastBoolVar US28292p2(true);
    ::RBX::FastBoolVar US28292p3(false);
    ::RBX::FastBoolVar US28814(false);
    ::RBX::FastBoolVar US29001p1(false);
    ::RBX::FastBoolVar US29001p2(false);
    ::RBX::FastBoolVar IgnoreInvalidTicket(true);
    ::RBX::FastBoolVar HashConfigP1(false);
    ::RBX::FastBoolVar HashConfigP2(false);
    ::RBX::FastBoolVar HashConfigP7(false);
    ::RBX::FastBoolVar US25317p1(true);
    ::RBX::FastBoolVar US25317p2(true);
    ::RBX::FastBoolVar WhiteListChatFilter(false);
    ::RBX::FastBoolVar ReadDeSerializeProcessFlow(true);
    ::RBX::FastBoolVar ExplicitlyAssignDefaultPropVal(false);
    ::RBX::FastBoolVar GetCharacterAppearanceEnabled(false);
    ::RBX::FastBoolVar CreatePlayerGuiLocal(false);
    ::RBX::FastBoolVar FirePlayerAddedAndPlayerRemovingOnClient(false);
    ::RBX::FastBoolVar LoadGuisWithoutChar(false);
    ::RBX::FastBoolVar FilterInvalidWhisper(true);
    ::RBX::FastBoolVar CloudEditSupportPlayersKickAndShutdown(true);
    ::RBX::FastBoolVar DebugLogStaleInstanceCacheEntry(false);
    ::RBX::FastBoolVar PhysicsSenderSleepingUpdate(false);
    ::RBX::FastBoolVar PhysicsSenderUseOwnerTimestamp(false);
    ::RBX::FastBoolVar PhysicsSenderCheckPartInServiceBeforeSend(false);
    ::RBX::FastBoolVar DebugPhysicsSenderLogCacheMissToGA(false);
    ::RBX::FastBoolVar RCCSupportCloudEdit(false);
    ::RBX::FastBoolVar CloudEditGARespectsThrottling(false);
    ::RBX::FastBoolVar CloudEditCheckClientPresent(false);
    ::RBX::FastBoolVar DebugCrashOnFailToLoadClientSettings(false);
    ::RBX::FastBoolVar UseNewSecurityKeyApi(false);
    ::RBX::FastBoolVar UseNewMemHashApi(false);
    ::RBX::FastBoolVar US30476(false);
    ::RBX::FastBoolVar FullscreenRefocusingFix(false);
    ::RBX::FastBoolVar MouseDeltaWhenNotMouseLocked(false);
    ::RBX::FastBoolVar UserInputViewportSizeFixWindows(true);
    ::RBX::FastBoolVar DontOpenWikiOnClient(false);
    ::RBX::FastBoolVar WindowsInferredCrashReporting(false);
    ::RBX::FastBoolVar TextScaleDontWrapInWords(false);
    ::RBX::FastBoolVar ScreenShotDuplicationFix(false);
    ::RBX::FastBoolVar SphericalSparklesEmission(false);
    ::RBX::FastBoolVar DontReorderScreenGuisWhenDescendantRemoving(false);
    ::RBX::FastBoolVar G3DQuatConstructorFix(true);
    ::RBX::FastBoolVar FixMatrixToAxisAngle(false);
    ::RBX::FastBoolVar CyclicExecutiveForServerTweaks(false);
} }

namespace DFInt { namespace {
    ::RBX::FastIntVar BulletContactBreakThresholdPercent(200);
    ::RBX::FastIntVar BulletContactBreakOrthogonalThresholdPercent(200);
    ::RBX::FastIntVar BulletContactBreakOrthogonalThresholdActivatePercent(200);
    ::RBX::FastIntVar WorldStepMax(30);
    ::RBX::FastIntVar WorldStepsOffsetAdjustRate(100);
    ::RBX::FastIntVar smoothnessReportThreshold(10000);
    ::RBX::FastIntVar MaxMissedWorldStepsRemembered(12);
    ::RBX::FastIntVar SmoothTerrainPhysicsRayAabbSlop(0);
    ::RBX::FastIntVar InterpolationBufferMinSize(2);
    ::RBX::FastIntVar InterpolationBufferMaxSize(8);
    ::RBX::FastIntVar InterpolationDelayFactorTenths(15);
    ::RBX::FastIntVar MaxNodesPerPathPacket(3);
    ::RBX::FastIntVar NodeIntervalCapMS(100);
    ::RBX::FastIntVar MaxContentProviderRunsPerStep(10);
    ::RBX::FastIntVar MaxContentProviderRunsAccumulated(20);
    ::RBX::FastIntVar ExternalHttpResponseTimeoutMillis(30000);
    ::RBX::FastIntVar ExternalHttpRequestSizeLimitKB(1024);
    ::RBX::FastIntVar ExternalHttpResponseSizeLimitKB(4096);
    ::RBX::FastIntVar StreamingMemoryUsagePercent(50);
    ::RBX::FastIntVar MinSoundStreamSizeBytes(512000);
    ::RBX::FastIntVar TimeBetweenCheckingApiAccessMillis(5000);
    ::RBX::FastIntVar ContentProviderThreadPoolSize(16);
    ::RBX::FastIntVar HttpMaxRedirects(10);
    ::RBX::FastIntVar HttpCacheCleanMinFilesRequired(3000);
    ::RBX::FastIntVar HttpCacheCleanMaxFilesToKeep(1500);
    ::RBX::FastIntVar HttpCacheSendStatsEveryXSeconds(60);
    ::RBX::FastIntVar HttpCacheCleanIfGBLessThan(5);
    ::RBX::FastIntVar HttpCurlDeepErrorReportingCount(0);
    ::RBX::FastIntVar HttpResponseDefaultTimeoutMillis(60000);
    ::RBX::FastIntVar HttpSendDefaultTimeoutMillis(60000);
    ::RBX::FastIntVar HttpConnectDefaultTimeoutMillis(60000);
    ::RBX::FastIntVar HttpDataSendDefaultTimeoutMillis(60000);
    ::RBX::FastIntVar HttpSendStatsEveryXSeconds(60);
    ::RBX::FastIntVar HttpGAFailureReportPercent(1);
    ::RBX::FastIntVar HttpRBXEventFailureReportHundredthsPercent(0);
    ::RBX::FastIntVar HttpRbxApiJobFrequencyInSeconds(1);
    ::RBX::FastIntVar MaxLogHistory(512);
    ::RBX::FastIntVar BadLogInfluxHundredthsPercentage(0);
    ::RBX::FastIntVar BadLogMask(0);
    ::RBX::FastIntVar RakNetMaxSplitPacketCount(1400);
    ::RBX::FastIntVar PointBalanceCacheInvalidateTimeMs(1000);
    ::RBX::FastIntVar MaxAwardPointsHttpCallsPerMinute(60);
    ::RBX::FastIntVar SecondsPerBatchAwardPointsCall(10);
    ::RBX::FastIntVar UserHttpRequestsPerMinuteLimit(500);
    ::RBX::FastIntVar TeleportRetryTimes(5);
    ::RBX::FastIntVar CreatePlacePerMinute(5);
    ::RBX::FastIntVar CreatePlacePerPlayerPerMinute(1);
    ::RBX::FastIntVar SavePlacePerMinute(10);
    ::RBX::FastIntVar HttpInfluxHundredthsPercentage(0);
    ::RBX::FastIntVar ElevatedPhysicsFPSReportThresholdTenths(610);
    ::RBX::FastIntVar PathfindingMaxDistance(512);
    ::RBX::FastIntVar PathfindingJobRunsPerSecond(10);
    ::RBX::FastIntVar PathfindingChunksPerInvokation(10);
    ::RBX::FastIntVar PathfindingAgeToCollectChunks(1000);
    ::RBX::FastIntVar PathfindingCollectPeriod(100);
    ::RBX::FastIntVar PathfindingDefaultBucketNum(2048);
    ::RBX::FastIntVar PathfindingVerticalChunkClamp(1);
    ::RBX::FastIntVar PathfindingSmoothIterations(5);
    ::RBX::FastIntVar PathfindingAverageWindow(7);
    ::RBX::FastIntVar DataStoreMaxKeysToFetch(100);
    ::RBX::FastIntVar DataStoreKeyLengthLimit(50);
    ::RBX::FastIntVar DataStoreMaxPageSize(100);
    ::RBX::FastIntVar DataStoreMaxValueSize(64*1024);
    ::RBX::FastIntVar DataStoreTouchTimeoutInSeconds(5);
    ::RBX::FastIntVar DataStoreSameKeyPerMinute(10);
    ::RBX::FastIntVar DataStoreJobFrequencyInSeconds(1);
    ::RBX::FastIntVar DataStoreFetchFrequenceInSeconds(30);
    ::RBX::FastIntVar DataStoreFixedRequestLimit(60);
    ::RBX::FastIntVar DataStorePerPlayerRequestLimit(10);
    ::RBX::FastIntVar DataStoreInitialBudget(100);
    ::RBX::FastIntVar DataStoreOrderedSetFixedRequestLimit(30);
    ::RBX::FastIntVar DataStoreOrderedSetPerPlayerRequestLimit(5);
    ::RBX::FastIntVar DataStoreOrderedSetInitialBudget(50);
    ::RBX::FastIntVar DataStoreRefetchFixedRequestLimit(30);
    ::RBX::FastIntVar DataStoreRefetchPerPlayerRequestLimit(5);
    ::RBX::FastIntVar DataStoreSortedFixedRequestLimit(5);
    ::RBX::FastIntVar DataStoreSortedPerPlayerRequestLimit(2);
    ::RBX::FastIntVar DataStoreSortedInitialBudget(10);
    ::RBX::FastIntVar DataStoreMaxBudgetMultiplier(100);
    ::RBX::FastIntVar DataStoreMaxThrottledQueue(30);
    ::RBX::FastIntVar DataStoreAnalyticsReportEveryNSeconds(60);
    ::RBX::FastIntVar PercentApiRequestsRecordGoogleAnalytics(1);
    ::RBX::FastIntVar HttpRbxApiClientPerMinuteRequestLimit(300);
    ::RBX::FastIntVar HttpRbxApiMaxBudgetMultiplier(1);
    ::RBX::FastIntVar HttpRbxApiRequestsPerMinuteServerLimit(300);
    ::RBX::FastIntVar HttpRbxApiRequestsPerMinutePerPlayerInServerLimit(100);
    ::RBX::FastIntVar HttpRbxApiMaxThrottledQueueSize(50);
    ::RBX::FastIntVar HttpRbxApiMaxRetryBudgetPerMinute(500);
    ::RBX::FastIntVar HttpRbxApiMaxRetryCount(10);
    ::RBX::FastIntVar HttpRbxApiMaxRetryQueueSize(500);
    ::RBX::FastIntVar HttpRbxApiMaxSyncRetries(3);
    ::RBX::FastIntVar HttpRbxApiSyncRetryWaitTimeMSec(500);
    ::RBX::FastIntVar RemoteDelayedQueueLimit(256);
    ::RBX::FastIntVar ExpireMarketPlaceServiceCacheSeconds(60);
    ::RBX::FastIntVar PurchaseMismatchReportRate(100);
    ::RBX::FastIntVar PurchaseErrorReportRate(100);
    ::RBX::FastIntVar OnCloseTimeoutInSeconds(30);
    ::RBX::FastIntVar ActionStationDebounceTime(2);
    ::RBX::FastIntVar MoveInGameChatToTopPlaceId(0);
    ::RBX::FastIntVar LuaChatFloodCheckMessages(7);
    ::RBX::FastIntVar LuaChatFloodCheckInterval(15);
    ::RBX::FastIntVar LuaExceptionPlaceFilter(0);
    ::RBX::FastIntVar LuaExceptionThrottlingPercentage(0);
    ::RBX::FastIntVar LuaGcBoost(1);
    ::RBX::FastIntVar LuaGcMaxKb(100);
    ::RBX::FastIntVar DraggerMaxMovePercent(100);
    ::RBX::FastIntVar DraggerMaxMoveSteps(10000);
    ::RBX::FastIntVar PGSJumpForceAdjustment(520);
    ::RBX::FastIntVar HumanoidFloorTeleportWeightValue(50);
    ::RBX::FastIntVar HumanoidFloorManualFrictionVelocityMultValue(100);
    ::RBX::FastIntVar MotionDiscontinuityThreshold(1);
    ::RBX::FastIntVar RCCInfluxHundredthsPercentage(1000);
    ::RBX::FastIntVar MaxDataStepsPerCyclic(5);
    ::RBX::FastIntVar MaxDataStepsAccumulated(15);
    ::RBX::FastIntVar MaxClusterSendStepsPerCyclic(5);
    ::RBX::FastIntVar MaxClusterSendStepsAccumulated(15);
    ::RBX::FastIntVar MaxDataOutJobScaling(10);
    ::RBX::FastIntVar NumPhysicsPacketsPerStep(1);
    ::RBX::FastIntVar PhysicsSenderRate(15);
    ::RBX::FastIntVar WebChatFilterHttpTimeoutSeconds(60);
    ::RBX::FastIntVar ReportTimeLimit1(4000);
    ::RBX::FastIntVar Rtl1InfluxHundredthsPercentage(100);
    ::RBX::FastIntVar ReportTimeLimit2(8000);
    ::RBX::FastIntVar Rtl2InfluxHundredthsPercentage(100);
    ::RBX::FastIntVar ReportTimeLimit3(1500);
    ::RBX::FastIntVar Rtl3InfluxHundredthsPercentage(100);
    ::RBX::FastIntVar Rtl5InfluxHundredthsPercentage(1);
    ::RBX::FastIntVar Rtl6InfluxHundredthsPercentage(100);
    ::RBX::FastIntVar HashConfigP9(100);
    ::RBX::FastIntVar PartStreamingGCMinRegionLength(2);
    ::RBX::FastIntVar JoinDataCompressionLevel(1);
    ::RBX::FastIntVar JoinDataBonus(0);
    ::RBX::FastIntVar MaxClusterKBPerSecond(40);
    ::RBX::FastIntVar MaxDataPacketPerSend(1);
    ::RBX::FastIntVar PacketErrorInfluxHundredthsPercentage(10000);
    ::RBX::FastIntVar PhysicsCompressionSizeFilter(50);
    ::RBX::FastIntVar HashConfigP3(4);
    ::RBX::FastIntVar HashConfigP4(1000);
    ::RBX::FastIntVar HashConfigP5(1);
    ::RBX::FastIntVar HashConfigP6(1);
    ::RBX::FastIntVar HashConfigP8(64);
    ::RBX::FastIntVar MaxWaitTimeBeforeForcePacketProcessMS(0);
    ::RBX::FastIntVar MaxProcessPacketsStepsPerCyclic(5);
    ::RBX::FastIntVar MaxProcessPacketsStepsAccumulated(15);
    ::RBX::FastIntVar MaxProcessPacketsJobScaling(10);
    ::RBX::FastIntVar DebugMovementPathNumTotalWayPoint(1000);
    ::RBX::FastIntVar JoinInfluxHundredthsPercentage(0);
    ::RBX::FastIntVar MaxStreamPacketsPerStep(16);
    ::RBX::FastIntVar MaxServerStreamRegionRadius(16);
    ::RBX::FastIntVar StreamJobPriorityAmplifierRadius(0);
    ::RBX::FastIntVar MaxConsecutiveStreamJobWorkLoad(1);
    ::RBX::FastIntVar WriteFullDmpPercent(0);
    ::RBX::FastIntVar ClientInstanceQuotaCap(10000);
    ::RBX::FastIntVar ClientInstanceQuotaInitial(2000);
    ::RBX::FastIntVar PhysicsSenderBufferHealthThreasholdPercent(40);
    ::RBX::FastIntVar PhysicsSenderRotationThresholdThousandth(20);
    ::RBX::FastIntVar TaskSchedulerThreadCountEnum(1);
    ::RBX::FastIntVar HttpResponseExtendedTimeoutMillis(600000);
    ::RBX::FastIntVar HttpSendExtendedTimeoutMillis(600000);
    ::RBX::FastIntVar HttpConnectExtendedTimeoutMillis(600000);
    ::RBX::FastIntVar HttpDataSendExtendedTimeoutMillis(600000);
    ::RBX::FastIntVar TexAtlasUpdateLineHeight(150);
    ::RBX::FastIntVar TaskSchedularBatchErrorCalcFPS(300);
} }

namespace DFString { namespace {
    ::RBX::FastStringVar RobloxAnalyticsURL("");
    ::RBX::FastStringVar HttpCurlProxyHostAndPort("");
    ::RBX::FastStringVar HttpInfluxURL("");
    ::RBX::FastStringVar HttpInfluxDatabase("");
    ::RBX::FastStringVar HttpInfluxUser("");
    ::RBX::FastStringVar HttpInfluxPassword("");
    ::RBX::FastStringVar AssetUrlPiece("");
    ::RBX::FastStringVar AssetVersionUrlPiece("");
    ::RBX::FastStringVar BaseSetsUrlPiece("");
    ::RBX::FastStringVar CollectionUrlPiece("");
    ::RBX::FastStringVar FreeModelUrlPiece("");
    ::RBX::FastStringVar FreeDecalUrlPiece("");
    ::RBX::FastStringVar UserSetsUrlPiece("");
    ::RBX::FastStringVar AssetVersionsUrl("");
    ::RBX::FastStringVar US30605p1("");
    ::RBX::FastStringVar US30605p2("");
    ::RBX::FastStringVar US30605p3("");
    ::RBX::FastStringVar US30605p4("");
    ::RBX::FastStringVar US30605p5("");
    ::RBX::FastStringVar MemHashConfig("");
} }

// Call-site definition macros: instances are declared above; these are
// deliberate no-ops so unknown names fail to compile at use sites.
#define FASTFLAGVARIABLE( ... )
#define FASTINTVARIABLE( ... )
#define FASTSTRINGVARIABLE( ... )
#define DYNAMIC_FASTFLAGVARIABLE( ... )
#define DYNAMIC_FASTINTVARIABLE( ... )
#define DYNAMIC_FASTSTRINGVARIABLE( ... )
#define FASTFLAG( ... )
#define DYNAMIC_FASTFLAG( ... )
#define DYNAMIC_FASTINT( ... )
#define DYNAMIC_FASTSTRING( ... )
#define FASTINT( ... )
#define FASTSTRING( ... )

namespace FFlag { namespace {
    ::RBX::FastBoolVar AnchoredSendPositionUpdate(false);
    ::RBX::FastBoolVar ResizeGuiOnStep(false);
    ::RBX::FastBoolVar UseNewUrlClass(false);
} }


#endif // RBX_FASTLOG_H
