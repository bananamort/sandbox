// FastLog.h -- RECONSTRUCTED HEADER
//
// The original file shipped inside the "Log/" project, which is absent from
// this source drop entirely (the drop also references Log/*.vcxproj without
// providing it). This reconstruction was authored for the sandbox build
// enablement effort: the macro surface, both log-group namespaces, and every
// settings-variable instance below were harvested EXHAUSTIVELY from call
// sites across the tree on 2026-08-23/24.
//
// Semantics of the original (compile-time-filtered ring-buffer logger +
// process-wide FastVar settings registry) are approximated:
//   * FASTLOG* emitters format to stderr, keep a bounded history for
//     FLog::WriteFastLogDump, and forward to any sink registered through
//     FLog::SetExternalLogFunc (Win LogManager).
//   * Settings variables are real process-wide singletons
//     (__declspec(selectany) folds the per-TU definitions), registered at
//     static-init into a name-keyed registry so FLog::GetValue / SetValue /
//     SetValueFromServer / ForEachVariable / GetNumSynchronizedVariable
//     operate on the same objects the call sites read directly.
//   * FASTVARTYPE_SYNC is its own kind: it tags exactly the
//     SYNCHRONIZED_FASTFLAG(VARIABLE) family (SFFlag::get* accessors),
//     which is the set ServerReplicator::serializeSFFlags replicates and
//     ClientReplicator::deserializeSFFlags applies via SetValueFromServer.
// Define RBX_FASTLOG_SILENT to compile all emitter calls to no-ops.

#ifndef RBX_FASTLOG_H
#define RBX_FASTLOG_H

#include <cstdarg>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <deque>
#include <map>
#include <mutex>
#include <ostream>
#include <string>
#include <utility>
#include <vector>

// Settings-variable kind taxonomy. Values are reconstruction-internal (they
// are never serialized); SYNC is the server-replicated SFFlag family.
enum FastVarType {
    FASTVARTYPE_STATIC  = 0,
    FASTVARTYPE_DYNAMIC = 1,
    FASTVARTYPE_AB_NEWUSERS       = 2,
    FASTVARTYPE_AB_NEWSTUDIOUSERS = 3,
    FASTVARTYPE_AB_ALLUSERS       = 4,
    FASTVARTYPE_ANY     = 5,
    // The SYNCHRONIZED_FASTFLAG(VARIABLE) family (SFFlag::get* accessors):
    // the genuinely server-replicated flag set consumed by
    // ServerReplicator::serializeSFFlags / ClientReplicator::deserializeSFFlags.
    FASTVARTYPE_SYNC    = 6
};

namespace FLog {
    // Channel is a TYPE (log channel handle) -- signal.h stores scoped
    // connections tagged by channel, and Test.cpp snapshots group levels
    // through it. The group CATALOG follows further down as mutable
    // FastVars::GroupVar objects (runtime log levels).
    class Channel {
    public:
        int id;
        constexpr Channel(int i = 0) : id(i) {}
        operator int() const { return id; }
        // Assign from a raw level so a Channel can snapshot a GroupVar in ONE
        // user conversion (Test.cpp "oldSettings.wasLogAsserts = FLog::Asserts"
        // would otherwise need GroupVar->int->Channel, two conversions).
        Channel& operator=(int i) { id = i; return *this; }
    };
}

namespace RBX {
namespace FastLogImpl {

typedef void (*SinkFn)(FLog::Channel id, const char* message);
inline SinkFn& sink() { static SinkFn f = 0; return f; }
inline std::deque<std::string>& history() { static std::deque<std::string> h; return h; }
inline std::mutex& historyMutex() { static std::mutex m; return m; }

inline void vemit(int group, char const* fmt, va_list ap)
{
    char buf[2048];
    vsnprintf(buf, sizeof(buf), fmt, ap);
    buf[sizeof(buf)-1] = 0;
#ifndef RBX_FASTLOG_SILENT
    std::fputs(buf, stderr);
    std::fputc('\n', stderr);
#endif
    {
        std::lock_guard<std::mutex> lock(historyMutex());
        history().push_back(buf);
        while (history().size() > 4096)
            history().pop_front();
    }
    SinkFn s = sink();
    if (s) s(FLog::Channel(group), buf);
}

inline void emitG(int group, char const* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vemit(group, fmt, ap);
    va_end(ap);
}

} // namespace FastLogImpl

// ==== SETTINGS-VARIABLE REGISTRY ====
namespace FastVars {

// Forward declarations: VarBase's constructor registers each instance.
struct VarBase;
inline void registerVar(VarBase* v);

struct VarBase {
    const char* const name;
    const int type;
    std::string defaultValue;
    VarBase(const char* n, int t, const std::string& def)
        : name(n), type(t), defaultValue(def) { registerVar(this); }
    virtual ~VarBase() {}
    virtual std::string toString() const = 0;
    virtual void fromString(const std::string& s) = 0;
private:
    VarBase(const VarBase&);
    VarBase& operator=(const VarBase&);
};

typedef std::map<std::string, VarBase*> VarMap;
inline VarMap& varMap() { static VarMap m; return m; }
inline std::mutex& varMutex() { static std::mutex m; return m; }

// __declspec(selectany) folds the per-TU definitions into ONE instance per
// name, so exactly one constructor registration ever happens per variable.
inline void registerVar(VarBase* v)
{
    std::lock_guard<std::mutex> lock(varMutex());
    VarMap& m = varMap();
    if (m.find(v->name) == m.end())
        m[v->name] = v;
}

inline bool matches(FastVarType requested, int actual)
{
    return requested == FASTVARTYPE_ANY || (int)requested == actual;
}

// Metadata for FInt/DFInt variables. The variables themselves are NATIVE
// ints (__declspec(selectany), folded to one instance): engine code takes
// their addresses as int* (e.g. ThrottlingHelper "Designed to pass FInt",
// Base/include/rbx/RunningAverage.h), which a wrapper class cannot provide.
// The per-TU registration object below only feeds the name-keyed registry;
// every copy points at the same folded int, so first-registration dedup is
// immaterial.
struct IntVar : VarBase {
    int* p;
    IntVar(const char* n, int t, int* ptr)
        : VarBase(n, t, ""), p(ptr) { defaultValue = toString(); }
    std::string toString() const
    {
        char b[16];
        snprintf(b, sizeof(b), "%d", *p);
        return std::string(b);
    }
    void fromString(const std::string& s) { *p = atoi(s.c_str()); }
};

// Log-group variable. In the original logger each group declared through
// LOGGROUP/DYNAMIC_LOGGROUP was an int ENUMERATOR, and call sites use it
// everywhere an int would go: RBXASSERT expands to "FLog::Asserts && (expr)"
// and "ReleaseAssert(FLog::Asserts, msg)" (rbx/Debug.h:111-113), DeviceCaps
// passes groups as dumpToFLog(int), Test.cpp compares/ternaries them. The
// group catalog therefore holds selectany GroupVar objects with ENUM-LIKE
// semantics -- mutable runtime level plus implicit conversion to int:
//   * implicit GroupVar -> int (the single object conversion; exactly what
//     the original enumerator provided),
//   * assignments from int and from FLog::Channel are member operators,
//   * FLog::FastLog/FastLogS keep exact-match GroupVar overloads and the
//     emitters read the id through groupId(), so no conversion is forced on
//     hot paths.
struct GroupVar {
    int v;
    constexpr GroupVar(int x = 0) : v(x) {}
    GroupVar& operator=(int x) { v = x; return *this; }
    GroupVar& operator=(const FLog::Channel& c) { v = c.id; return *this; }
    operator int() const { return v; }
};

} // namespace FastVars

struct FastBoolVar : FastVars::VarBase {
    bool v;
    FastBoolVar(bool b, const char* n = "", int t = 0)
        : FastVars::VarBase(n, t, b ? "true" : "false"), v(b) {}
    operator bool() const { return v; }
    FastBoolVar& operator=(bool b) { v = b; return *this; }
    std::string toString() const { return v ? "true" : "false"; }
    void fromString(const std::string& s)
    {
        std::string low(s);
        for (size_t i = 0; i < low.size(); ++i)
            low[i] = (char)tolower((unsigned char)low[i]);
        v = !(low == "false" || low == "0" || low.empty());
    }
};

struct FastStringVar : FastVars::VarBase {
    std::string v;
    FastStringVar(const char* s, const char* n = "", int t = 0)
        : FastVars::VarBase(n, t, s ? s : ""), v(s ? s : "") {}
    operator const std::string&() const { return v; }
    FastStringVar& operator=(const char* s) { v = s ? s : ""; return *this; }
    FastStringVar& operator=(const std::string& s) { v = s; return *this; }
    const char* c_str() const { return v.c_str(); }
    const char* data() const { return v.data(); }
    bool empty() const { return v.empty(); }
    size_t size() const { return v.size(); }
    std::string toString() const { return v; }
    void fromString(const std::string& s) { v = s; }
};

// Concatenation: exact-match free operators so string + FastStringVar (and
// the mirrored forms) never depend on conversion-operator participation in
// overload resolution. operator<< is likewise exact-match: the stream
// templates cannot deduce basic_string through a user conversion.
inline std::string operator+(const std::string& lhs, const FastStringVar& rhs) { return lhs + rhs.v; }
inline std::string operator+(const FastStringVar& lhs, const std::string& rhs) { return lhs.v + rhs; }
inline std::string operator+(const FastStringVar& lhs, const char* rhs) { return lhs.v + rhs; }
inline std::string operator+(const char* lhs, const FastStringVar& rhs) { return lhs + rhs.v; }
inline std::ostream& operator<<(std::ostream& os, const FastStringVar& s) { return os << s.v; }

} // namespace RBX

// Log-group variables: mutable runtime levels (see FastVars::GroupVar).
#define RBX_LOGGROUP_VAR(name, init) \
    __declspec(selectany) ::RBX::FastVars::GroupVar name(init)

namespace FLog {
    typedef void (*ExternalLogFunc)(Channel id, const char* message);
    typedef double (*NowSecondsFn)();

    inline NowSecondsFn& nowSecondsSource() { static NowSecondsFn f = 0; return f; }

    inline void SetExternalLogFunc(ExternalLogFunc f)
    {
        RBX::FastLogImpl::sink() = f;
    }

    // Runtime entry points (harvested: Time.cpp "FLog::Init(nowFastSec)",
    // Debug.cpp ReleaseAssert "FLog::FastLog(channel, msg, 0)",
    // ScriptContext.cpp "FLog::FastLogS(FLog::LuaProfiler, str, NULL)").
    inline void Init(double (*getNowSeconds)())
    {
        // Original call site: Time.cpp "FLog::Init(nowFastSec)" passes the
        // engine's fast-clock function; store it as the log time source.
        nowSecondsSource() = getNowSeconds;
    }

    inline void FastLog(int channel, const char* msg, int level)
    {
        (void)level;
        RBX::FastLogImpl::emitG(channel, "%s", msg ? msg : "");
    }

    // GroupVar overloads: pass groups without forcing an extra conversion
    // step (GroupVar has no operator int -- see FastVars::GroupVar).
    inline void FastLog(const RBX::FastVars::GroupVar& channel, const char* msg, int level)
    {
        FastLog(channel.v, msg, level);
    }

    inline void FastLogS(int channel, const char* msg, const char* detail)
    {
        (void)detail;
        RBX::FastLogImpl::emitG(channel, "%s", msg ? msg : "");
    }

    inline void FastLogS(const RBX::FastVars::GroupVar& channel, const char* msg, const char* detail)
    {
        FastLogS(channel.v, msg, detail);
    }

    inline void WriteFastLogDump(const char* filepath, int maxLines)
    {
        FILE* f = fopen(filepath, "w");
        if (!f)
            return;
        std::lock_guard<std::mutex> lock(RBX::FastLogImpl::historyMutex());
        std::deque<std::string>& h = RBX::FastLogImpl::history();
        int skip = (int)h.size() > maxLines ? (int)h.size() - maxLines : 0;
        for (std::deque<std::string>::const_iterator it = h.begin(); it != h.end(); ++it)
        {
            if (skip > 0) { --skip; continue; }
            std::fprintf(f, "%s\n", it->c_str());
        }
        fclose(f);
    }

    // ---- FastVar settings API ----
    inline bool GetValue(const char* name, std::string& out)
    {
        std::lock_guard<std::mutex> lock(RBX::FastVars::varMutex());
        RBX::FastVars::VarMap& m = RBX::FastVars::varMap();
        RBX::FastVars::VarMap::iterator it = m.find(name ? name : "");
        if (it == m.end())
            return false;
        out = it->second->toString();
        return true;
    }

    inline bool GetValue(const char* name, std::string& out, bool includeDefaultIfUnset)
    {
        (void)includeDefaultIfUnset;
        return GetValue(name, out);
    }

    inline bool SetValue(const std::string& name, const std::string& value, FastVarType type)
    {
        std::lock_guard<std::mutex> lock(RBX::FastVars::varMutex());
        RBX::FastVars::VarMap& m = RBX::FastVars::varMap();
        RBX::FastVars::VarMap::iterator it = m.find(name);
        if (it == m.end())
            return false;
        if (!RBX::FastVars::matches(type, it->second->type))
            return false;
        it->second->fromString(value);
        return true;
    }

    // Delegates to the 3-arg form, which must be declared first.
    inline bool SetValue(const std::string& name, const std::string& value)
    {
        return SetValue(name, value, FASTVARTYPE_ANY);
    }

    inline bool SetValue(const std::string& name, const std::string& value, FastVarType type, bool fromServer)
    {
        (void)fromServer;
        return SetValue(name, value, type);
    }

    inline void SetValueFromServer(const std::string& name, const std::string& value)
    {
        std::lock_guard<std::mutex> lock(RBX::FastVars::varMutex());
        RBX::FastVars::VarMap& m = RBX::FastVars::varMap();
        RBX::FastVars::VarMap::iterator it = m.find(name);
        if (it != m.end())
            it->second->fromString(value);
    }

    inline unsigned short GetNumSynchronizedVariable()
    {
        std::lock_guard<std::mutex> lock(RBX::FastVars::varMutex());
        RBX::FastVars::VarMap& m = RBX::FastVars::varMap();
        unsigned short n = 0;
        for (RBX::FastVars::VarMap::iterator it = m.begin(); it != m.end(); ++it)
            if (it->second->type == FASTVARTYPE_SYNC)
                ++n;
        return n;
    }

    typedef void (*VisitVariablesFn)(const std::string& name, const std::string& value, void* context);

    inline void ForEachVariable(VisitVariablesFn visitor, void* context, FastVarType type)
    {
        // Snapshot first so visitors may call back into the API.
        std::vector<std::pair<std::string, std::string> > snapshot;
        {
            std::lock_guard<std::mutex> lock(RBX::FastVars::varMutex());
            RBX::FastVars::VarMap& m = RBX::FastVars::varMap();
            for (RBX::FastVars::VarMap::iterator it = m.begin(); it != m.end(); ++it)
                if (RBX::FastVars::matches(type, it->second->type))
                    snapshot.push_back(std::make_pair(it->first, it->second->toString()));
        }
        for (size_t i = 0; i < snapshot.size(); ++i)
            visitor(snapshot[i].first, snapshot[i].second, context);
    }

    inline void ResetSynchronizedVariablesState()
    {
        std::lock_guard<std::mutex> lock(RBX::FastVars::varMutex());
        RBX::FastVars::VarMap& m = RBX::FastVars::varMap();
        for (RBX::FastVars::VarMap::iterator it = m.begin(); it != m.end(); ++it)
            if (it->second->type == FASTVARTYPE_SYNC)
                it->second->fromString(it->second->defaultValue);
    }

    RBX_LOGGROUP_VAR(Zero, 0);
    RBX_LOGGROUP_VAR(AdornableLifetime, 0);
    RBX_LOGGROUP_VAR(AdornRenderStats, 0);
    RBX_LOGGROUP_VAR(Always, 0);
    RBX_LOGGROUP_VAR(AnalyticsLog, 0);
    RBX_LOGGROUP_VAR(Asserts, 0);
    RBX_LOGGROUP_VAR(ChangeHistoryService, 0);
    RBX_LOGGROUP_VAR(ClientSettings, 0);
    RBX_LOGGROUP_VAR(CloseDataModel, 0);
    RBX_LOGGROUP_VAR(ContentProviderRequests, 0);
    RBX_LOGGROUP_VAR(CoreScripts, 0);
    RBX_LOGGROUP_VAR(Crash, 0);
    RBX_LOGGROUP_VAR(CrashReporterInit, 0);
    RBX_LOGGROUP_VAR(CyclicExecutiveThrottling, 0);
    RBX_LOGGROUP_VAR(CyclicExecutiveTiming, 0);
    RBX_LOGGROUP_VAR(CyclicExecutiveWorldSteps, 0);
    RBX_LOGGROUP_VAR(DataModelJobs, 0);
    RBX_LOGGROUP_VAR(DataStore, 0);
    RBX_LOGGROUP_VAR(DataStoreBudget, 0);
    RBX_LOGGROUP_VAR(DeferredVoxelUpdates, 0);
    RBX_LOGGROUP_VAR(DeviceLost, 0);
    RBX_LOGGROUP_VAR(DragProfile, 0);
    RBX_LOGGROUP_VAR(DXVideoMemory, 0);
    RBX_LOGGROUP_VAR(Error, 0);
    RBX_LOGGROUP_VAR(FMOD, 0);
    RBX_LOGGROUP_VAR(FRM, 0);
    RBX_LOGGROUP_VAR(GfxClusters, 0);
    RBX_LOGGROUP_VAR(GfxClustersFull, 0);
    RBX_LOGGROUP_VAR(GoldenHashes, 0);
    RBX_LOGGROUP_VAR(GoogleAnalyticsTracking, 0);
    RBX_LOGGROUP_VAR(Graphics, 0);
    RBX_LOGGROUP_VAR(GuiTargetLifetime, 0);
    RBX_LOGGROUP_VAR(HangDetection, 0);
    RBX_LOGGROUP_VAR(HeartBeatFailure, 0);
    RBX_LOGGROUP_VAR(Http, 0);
    RBX_LOGGROUP_VAR(HttpQueue, 0);
    RBX_LOGGROUP_VAR(HttpRbxApiBudget, 0);
    RBX_LOGGROUP_VAR(HttpTrace, 0);
    RBX_LOGGROUP_VAR(HumanoidFloorProcess, 0);
    RBX_LOGGROUP_VAR(InstanceTreeManipulation, 0);
    RBX_LOGGROUP_VAR(ISteppedLifetime, 0);
    RBX_LOGGROUP_VAR(JoinSendExtraItemCount, 0);
    RBX_LOGGROUP_VAR(JointInstanceLifetime, 0);
    RBX_LOGGROUP_VAR(JointLifetime, 0);
    RBX_LOGGROUP_VAR(LegacyLock, 0);
    RBX_LOGGROUP_VAR(LuaBridge, 0);
    RBX_LOGGROUP_VAR(LuaMemoryPool, 0);
    RBX_LOGGROUP_VAR(LuaProfiler, 0);
    RBX_LOGGROUP_VAR(LuaScriptTimeoutSeconds, 0);
    RBX_LOGGROUP_VAR(MachineIdUploader, 0);
    RBX_LOGGROUP_VAR(MaxJoinDataSizeKB, 0);
    RBX_LOGGROUP_VAR(MaxNetworkReadTimeInCS, 0);
    RBX_LOGGROUP_VAR(MegaClusterDecodeStream, 0);
    RBX_LOGGROUP_VAR(MegaClusterDirty, 0);
    RBX_LOGGROUP_VAR(MegaClusterInit, 0);
    RBX_LOGGROUP_VAR(MegaClusterNetwork, 0);
    RBX_LOGGROUP_VAR(MegaClusterNetworkInit, 0);
    RBX_LOGGROUP_VAR(MouseCommand, 0);
    RBX_LOGGROUP_VAR(MouseCommandLifetime, 0);
    RBX_LOGGROUP_VAR(MutexLifetime, 0);
    RBX_LOGGROUP_VAR(NamedMutex, 0);
    RBX_LOGGROUP_VAR(Network, 0);
    RBX_LOGGROUP_VAR(NetworkCache, 0);
    RBX_LOGGROUP_VAR(NetworkInstances, 0);
    RBX_LOGGROUP_VAR(NetworkJoin, 0);
    RBX_LOGGROUP_VAR(NetworkPacketsReceive, 0);
    RBX_LOGGROUP_VAR(NetworkReadItem, 0);
    RBX_LOGGROUP_VAR(NetworkStatsReport, 0);
    RBX_LOGGROUP_VAR(NetworkStepsMultipliers, 0);
    RBX_LOGGROUP_VAR(NetworkStreaming, 0);
    RBX_LOGGROUP_VAR(PartInstanceLifetime, 0);
    RBX_LOGGROUP_VAR(PartStreamingRequests, 0);
    RBX_LOGGROUP_VAR(PathfindingDetail, 0);
    RBX_LOGGROUP_VAR(PathfindingPerf, 0);
    RBX_LOGGROUP_VAR(Physics, 0);
    RBX_LOGGROUP_VAR(PhysicsSenderSleepingLog, 0);
    RBX_LOGGROUP_VAR(PhysicsStepsPerSecond, 0);
    RBX_LOGGROUP_VAR(PlayerChatInfoExponentialBackoffLimitMultiplier, 0);
    RBX_LOGGROUP_VAR(PlayerShutdownLuaTimeoutSeconds, 0);
    RBX_LOGGROUP_VAR(Plugins, 0);
    RBX_LOGGROUP_VAR(PreloadLinkedScriptsTiming, 0);
    RBX_LOGGROUP_VAR(PrimitiveLifetime, 0);
    RBX_LOGGROUP_VAR(R15Character, 0);
    RBX_LOGGROUP_VAR(RakNetDisconnect, 0);
    RBX_LOGGROUP_VAR(RCCDataModelInit, 0);
    RBX_LOGGROUP_VAR(RCCServiceInit, 0);
    RBX_LOGGROUP_VAR(RCCServiceJobs, 0);
    RBX_LOGGROUP_VAR(ReflectionMetadata, 0);
    RBX_LOGGROUP_VAR(RenderFastCluster, 0);
    RBX_LOGGROUP_VAR(RenderLightGrid, 0);
    RBX_LOGGROUP_VAR(RenderLightGridAgeProportion, 0);
    RBX_LOGGROUP_VAR(RenderLightGridBorderGlobalCutoff, 0);
    RBX_LOGGROUP_VAR(RenderLightGridBorderSkylightCutoff, 0);
    RBX_LOGGROUP_VAR(RenderTextureCompositor, 0);
    RBX_LOGGROUP_VAR(RenderTextureCompositorBudget, 0);
    RBX_LOGGROUP_VAR(ReplicationDataLifetime, 0);
    RBX_LOGGROUP_VAR(RobloxWndInit, 0);
    RBX_LOGGROUP_VAR(ScriptContext, 0);
    RBX_LOGGROUP_VAR(ScriptContextAdd, 0);
    RBX_LOGGROUP_VAR(ScriptContextClose, 0);
    RBX_LOGGROUP_VAR(ScriptContextRemove, 0);
    RBX_LOGGROUP_VAR(Serializer, 0);
    RBX_LOGGROUP_VAR(SlowHttpRequest, 0);
    RBX_LOGGROUP_VAR(Sound, 0);
    RBX_LOGGROUP_VAR(SoundTiming, 0);
    RBX_LOGGROUP_VAR(SoundTrace, 0);
    RBX_LOGGROUP_VAR(StepAnimatedJoints, 0);
    RBX_LOGGROUP_VAR(TaskSchedulerFindJob, 0);
    RBX_LOGGROUP_VAR(TaskSchedulerInit, 0);
    RBX_LOGGROUP_VAR(TaskSchedulerRun, 0);
    RBX_LOGGROUP_VAR(TaskSchedulerTiming, 0);
    RBX_LOGGROUP_VAR(TerrainCellListener, 0);
    RBX_LOGGROUP_VAR(TextureContentProvider, 0);
    RBX_LOGGROUP_VAR(ThreadRefCounts, 0);
    RBX_LOGGROUP_VAR(ThumbnailRender, 0);
    RBX_LOGGROUP_VAR(TouchedSignal, 0);
    RBX_LOGGROUP_VAR(ttMetricP1, 0);
    RBX_LOGGROUP_VAR(US14116, 0);
    RBX_LOGGROUP_VAR(UseLuaMemoryPool, 0);
    RBX_LOGGROUP_VAR(UserInputProfile, 0);
    RBX_LOGGROUP_VAR(Verbs, 0);
    RBX_LOGGROUP_VAR(VideoCapture, 0);
    RBX_LOGGROUP_VAR(ViewRbxBase, 0);
    RBX_LOGGROUP_VAR(ViewRbxInit, 0);
    RBX_LOGGROUP_VAR(Voxelizer, 0);
    RBX_LOGGROUP_VAR(VR, 0);
    RBX_LOGGROUP_VAR(Warning, 0);
    RBX_LOGGROUP_VAR(WeakThreadRef, 0);
    RBX_LOGGROUP_VAR(WebChatFiltering, 0);
    RBX_LOGGROUP_VAR(WorldStepsBehind, 0);
    RBX_LOGGROUP_VAR(WorldStepsBehindG, 0);
}

namespace DFLog {
    RBX_LOGGROUP_VAR(Zero, 0);
    RBX_LOGGROUP_VAR(AnalyticsLog, 0);
    RBX_LOGGROUP_VAR(DeferredVoxelUpdates, 0);
    RBX_LOGGROUP_VAR(GoogleAnalyticsTracking, 0);
    RBX_LOGGROUP_VAR(HttpTrace, 0);
    RBX_LOGGROUP_VAR(MaxJoinDataSizeKB, 0);
    RBX_LOGGROUP_VAR(NamedMutex, 0);
    RBX_LOGGROUP_VAR(NetworkJoin, 0);
    RBX_LOGGROUP_VAR(NetworkPacketsReceive, 0);
    RBX_LOGGROUP_VAR(PartStreamingRequests, 0);
    RBX_LOGGROUP_VAR(PlayerChatInfoExponentialBackoffLimitMultiplier, 0);
    RBX_LOGGROUP_VAR(PreloadLinkedScriptsTiming, 0);
    RBX_LOGGROUP_VAR(R15Character, 0);
    RBX_LOGGROUP_VAR(SoundTiming, 0);
    RBX_LOGGROUP_VAR(SoundTrace, 0);
    RBX_LOGGROUP_VAR(WebChatFiltering, 0);
}

// Numeric id of a log group: GroupVar objects carry their level; plain
// integers (raw constants at a few call sites) pass through.
template <typename T>
inline int groupId(T group) { return (int)group; }
inline int groupId(const ::RBX::FastVars::GroupVar& g) { return g.v; }

#define FASTLOG(group, msg) \
    ::RBX::FastLogImpl::emitG(groupId(group), msg)

#define FASTLOG1(group, fmt, a) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a)
#define FASTLOG2(group, fmt, a, b) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a, b)
#define FASTLOG3(group, fmt, a, b, c) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a, b, c)
#define FASTLOG4(group, fmt, a, b, c, d) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a, b, c, d)
#define FASTLOG5(group, fmt, a, b, c, d, e) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a, b, c, d, e)

// F variants historically took float arguments; varargs promotion makes the
// same emitter correct.
#define FASTLOG1F(group, fmt, a) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a)
#define FASTLOG2F(group, fmt, a, b) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a, b)
#define FASTLOG3F(group, fmt, a, b, c) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a, b, c)
#define FASTLOG4F(group, fmt, a, b, c, d) \
    ::RBX::FastLogImpl::emitG(groupId(group), fmt, a, b, c, d)

// S variant takes exactly one string argument for a "%s" format.
#define FASTLOGS(group, msg, s) \
    ::RBX::FastLogImpl::emitG(groupId(group), msg, s)

// Group registration marker. In the original logger this registered the
// group with the runtime dump machinery; here it is intentionally empty --
// every group referenced anywhere in the tree is already declared in the
// FLog/DFLog enums above (harvested exhaustively). A call site using an
// unlisted group fails to compile, which is the desired tripwire.
#define LOGGROUP(name)

// Runtime log-level variable declarations (harvested: 140 LOGVARIABLE and
// 15 DYNAMIC_LOGVARIABLE sites, all file-scope; 24 DYNAMIC_LOGGROUP
// registrations). Level variables are declared but inert because the
// emitters are unfiltered. The anonymous-namespace wrapper needs no
// trailing semicolon, matching call sites that omit one.
#define LOGVARIABLE(group, defaultLevel) \
    namespace { static int rbx_log_level_##group = (defaultLevel); }
#define DYNAMIC_LOGVARIABLE(group, defaultLevel) \
    namespace { static int rbx_log_level_##group = (defaultLevel); }
#define DYNAMIC_LOGGROUP(group)


// ==== RECONSTRUCTED SETTINGS-VARIABLE SYSTEM ====
// Instances below were harvested verbatim from call sites. The macros give
// each variable its own name string and kind tag, define it as a
// __declspec(selectany) singleton (one process-wide object despite living
// in a header included everywhere), and register it into the FastVars
// registry at static initialization.

#define RBX_FASTFLAG(name, init) \
    __declspec(selectany) ::RBX::FastBoolVar name((init), #name, FASTVARTYPE_STATIC)
#define RBX_FASTINT(name, init) \
    __declspec(selectany) int name = (init); namespace { ::RBX::FastVars::IntVar rbx_fastvar_meta_##name(#name, FASTVARTYPE_STATIC, &name); }
#define RBX_FASTSTRING(name, init) \
    __declspec(selectany) ::RBX::FastStringVar name(init, #name, FASTVARTYPE_STATIC)
#define RBX_DFFLAG(name, init) \
    __declspec(selectany) ::RBX::FastBoolVar name((init), #name, FASTVARTYPE_DYNAMIC)
#define RBX_DFINT(name, init) \
    __declspec(selectany) int name = (init); namespace { ::RBX::FastVars::IntVar rbx_fastvar_meta_##name(#name, FASTVARTYPE_DYNAMIC, &name); }
#define RBX_DFSTRING(name, init) \
    __declspec(selectany) ::RBX::FastStringVar name(init, #name, FASTVARTYPE_DYNAMIC)

// ---- Synchronized flags (SFFlag) ----
// Harvested surface:
//   SYNCHRONIZED_FASTFLAGVARIABLE(Name, default) -- definition sites
//     (PathInterpolatedCFrame.cpp, PartInstance.cpp x2, Streaming.cpp x2,
//      Replicator.JoinDataItem.cpp)
//   SYNCHRONIZED_FASTFLAG(Name)                  -- extern-use sites
//     (World.cpp x2, DirectPhysicsReceiver/RoundRobin/TopNErrorsPhysicsSender)
//   Access is via SFFlag::get<Name>() function-style getters.
// All sites are file scope. The variable is one process-wide selectany
// object; every TU that runs either macro also defines the identical
// inline accessor (ODR-safe), so use sites link without seeing the
// defining TU. Registered as FASTVARTYPE_SYNC: this family is exactly the
// set ServerReplicator::serializeSFFlags replicates and
// ClientReplicator::deserializeSFFlags applies through SetValueFromServer.
#define SYNCHRONIZED_FASTFLAGVARIABLE(name, init) \
    __declspec(selectany) ::RBX::FastBoolVar name((init), #name, FASTVARTYPE_SYNC); \
    namespace SFFlag { inline bool get##name() { return ::name.v != 0; } }
#define SYNCHRONIZED_FASTFLAG(name) \
    extern ::RBX::FastBoolVar name; \
    namespace SFFlag { inline bool get##name() { return ::name.v != 0; } }

// ---- AB-experiment flags (harvested: Statistics.cpp DummyTest via
// ABTEST_NEWSTUDIOUSERS_VARIABLE, RenderView.cpp FrameRateThrottling via
// ABTEST_NEWUSERS_VARIABLE). Pure registrations for the AB scan performed
// by FLog::ForEachVariable(..., FASTVARTYPE_AB_*); never read directly.
// Internal-linkage per-TU objects: registry dedup keeps the first.
#define ABTEST_NEWUSERS_VARIABLE(name) \
    namespace { ::RBX::FastBoolVar rbx_abtest_##name(false, #name, FASTVARTYPE_AB_NEWUSERS); }
#define ABTEST_NEWSTUDIOUSERS_VARIABLE(name) \
    namespace { ::RBX::FastBoolVar rbx_abtest_##name(false, #name, FASTVARTYPE_AB_NEWSTUDIOUSERS); }

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

namespace FFlag {
    RBX_FASTFLAG(CSGExportFailure, false);
    RBX_FASTFLAG(UsePGSSolver, false);
    RBX_FASTFLAG(BallBlockNarrowphaseFixEnabled, false);
    RBX_FASTFLAG(PGSSteppingMotorFix, false);
    RBX_FASTFLAG(PGSGlueJoint, false);
    RBX_FASTFLAG(CheckSleepOptimization, false);
    RBX_FASTFLAG(FixBulletGJKOptimization, false);
    RBX_FASTFLAG(FixBulletGJKOptimization2, false);
    RBX_FASTFLAG(ModifyDefaultMaterialProperties, false);
    RBX_FASTFLAG(DebugRenderDownloadAssets, false);
    RBX_FASTFLAG(GoogleAnalyticsTrackingEnabled, false);
    RBX_FASTFLAG(DebugAnalyticsForceLotteryWin, false);
    RBX_FASTFLAG(SendStudioEventsWithStudioSID, true);
    RBX_FASTFLAG(DebugBreakOnFMODErrors, true);
    RBX_FASTFLAG(NoCacheForLocalContent, false);
    RBX_FASTFLAG(US21969, false);
    RBX_FASTFLAG(EnableLuaFollowers, true);
    RBX_FASTFLAG(DebugHumanoidRendering, false);
    RBX_FASTFLAG(DebugLocalRccServerConnection, false);
    RBX_FASTFLAG(DisableGlobalSettingsParentChange, true);
    RBX_FASTFLAG(US31006, false);
    RBX_FASTFLAG(PGSUsesConstraintBasedBodyMovers, false);
    RBX_FASTFLAG(RenderNewExplosionEnable, true);
    RBX_FASTFLAG(TeamCreate9938FixEnabled, true);
    RBX_FASTFLAG(UserAllCamerasInLua, false);
    RBX_FASTFLAG(CameraInterpolateMethodEnhancement, true);
    RBX_FASTFLAG(CameraVR, true);
    RBX_FASTFLAG(UseBuildGenericGameUrl, true);
    RBX_FASTFLAG(PlaceLauncherUsePOST, true);
    RBX_FASTFLAG(TweenCallbacksDuringRenderStep, false);
    RBX_FASTFLAG(FixSlice9Scale, true);
    RBX_FASTFLAG(CSGFixForNoChildData, true);
    RBX_FASTFLAG(AllowInsertFreeModels, false);
    RBX_FASTFLAG(InsertUnderFolder, true);
    RBX_FASTFLAG(PhysicsAnalyzerEnabled, false);
    RBX_FASTFLAG(PGSAlwaysActiveMasterSwitch, false);
    RBX_FASTFLAG(LuaControlsDisableMouse2Lock, false);
    RBX_FASTFLAG(GamepadCursorChanges, false);
    RBX_FASTFLAG(TypesettersReleaseResources, true);
    RBX_FASTFLAG(UseDynamicTypesetterUTF8, false);
    RBX_FASTFLAG(BillboardGuiVR, false);
    RBX_FASTFLAG(EnableVideoAds, true);
    RBX_FASTFLAG(DebugDisplayFPS, false);
    RBX_FASTFLAG(LuaBasedBubbleChat, false);
    RBX_FASTFLAG(NewInGameDevConsole, false);
    RBX_FASTFLAG(UseNewSubdomainsInCoreScripts, false);
    RBX_FASTFLAG(UseGameLoadedInLoadingScript, true);
    RBX_FASTFLAG(UseUserListMenu, false);
    RBX_FASTFLAG(EnableSetCoreTopbarEnabled, false);
    RBX_FASTFLAG(Durango3DBackground, true);
    RBX_FASTFLAG(UseFixedTransparencyNonCollidableBehaviour, true);
    RBX_FASTFLAG(IgnoreBlankDataOnStore, true);
    RBX_FASTFLAG(CSGRemoveScriptScaleRestriction, false);
    RBX_FASTFLAG(StudioCSGAssets, false);
    RBX_FASTFLAG(CSGLoadFromCDN, false);
    RBX_FASTFLAG(CSGLoadBlocking, false);
    RBX_FASTFLAG(CSGPhysicsLevelOfDetailEnabled, false);
    RBX_FASTFLAG(CSGUnionsSizeShouldNeverBe000, false);
    RBX_FASTFLAG(UseNewPromptEndHandling, false);
    RBX_FASTFLAG(GUIZFighterGPU, true);
    RBX_FASTFLAG(UserBetterInertialScrolling, false);
    RBX_FASTFLAG(RelativisticCameraFixEnable, true);
    RBX_FASTFLAG(NotificationServiceEnabledForEveryone, false);
    RBX_FASTFLAG(FixGlowingCSG, true);
    RBX_FASTFLAG(RenderNewParticles2Enable, true);
    RBX_FASTFLAG(UseInGameTopBar, false);
    RBX_FASTFLAG(MobileToggleChatVisibleIcon, false);
    RBX_FASTFLAG(LuaChatPhoneFontSize, false);
    RBX_FASTFLAG(LuaChatFiltering, false);
    RBX_FASTFLAG(FlyCamOnRenderStep, false);
    RBX_FASTFLAG(PlayerDropDownEnabled, false);
    RBX_FASTFLAG(UserUseNewControlScript, false);
    RBX_FASTFLAG(PGSVariablePenetrationMarginFix, false);
    RBX_FASTFLAG(PGSApplyImpulsesAtMidpoints, false);
    RBX_FASTFLAG(PGSSolverFileDump, false);
    RBX_FASTFLAG(StudioVariableIntellesense, false);
    RBX_FASTFLAG(DebugScriptAnalyzer, false);
    RBX_FASTFLAG(DebugCrashEnabled, true);
    RBX_FASTFLAG(CustomEmitterLuaTypesEnabled, false);
    RBX_FASTFLAG(PhysPropConstructFromMaterial, false);
    RBX_FASTFLAG(LuaDebugger, false);
    RBX_FASTFLAG(LuaDebuggerBreakOnError, false);
    RBX_FASTFLAG(StudioDE6194FixEnabled, false);
    RBX_FASTFLAG(DraggerInfiniteRecursionFix, false);
    RBX_FASTFLAG(UseFixedRightMouseClickBehaviour, true);
    RBX_FASTFLAG(StudioUseDraggerGrid, true);
    RBX_FASTFLAG(PhysicsSkipNonRealTimeHumanoidForceCalc, false);
    RBX_FASTFLAG(HumanoidRenderBillboard, false);
    RBX_FASTFLAG(HumanoidRenderBillboardVR, true);
    RBX_FASTFLAG(DebugForceRegenerateSchemaBitStream, false);
    RBX_FASTFLAG(DebugProtocolSynchronization, false);
    RBX_FASTFLAG(RemoveUnusedPhysicsSenders, false);
    RBX_FASTFLAG(RemoveInterpolationReciever, false);
    RBX_FASTFLAG(FilterSinglePass, false);
    RBX_FASTFLAG(FilterDoublePass, false);
    RBX_FASTFLAG(ClientABTestingEnabled, true);
    RBX_FASTFLAG(CopyArrayReferences, true);
    RBX_FASTFLAG(US30484p1, false);
    RBX_FASTFLAG(US30484p3, false);
    RBX_FASTFLAG(UseDataDomain, true);
    RBX_FASTFLAG(Dep, true);
    RBX_FASTFLAG(DirectXEnable, false);
    RBX_FASTFLAG(DirectX11Enable, false);
    RBX_FASTFLAG(GraphicsReportingInitErrorsToGAEnabled, true);
    RBX_FASTFLAG(UseNewAppBridgeInputWindows, false);
    RBX_FASTFLAG(ReloadSettingsOnTeleport, false);
    RBX_FASTFLAG(DebugUseDefaultGlobalSettings, false);
    RBX_FASTFLAG(RwxFailReport, false);
    RBX_FASTFLAG(GraphicsTextureCommitChanges, false);
    RBX_FASTFLAG(DebugGraphicsCrashOnLeaks, true);
    RBX_FASTFLAG(GraphicsDebugMarkersEnable, false);
    RBX_FASTFLAG(DebugRenderVRHUD, false);
    RBX_FASTFLAG(DebugD3D11DebugMode, false);
    RBX_FASTFLAG(OpenVR, true);
    RBX_FASTFLAG(DebugGraphicsD3D9ForceSWVP, false);
    RBX_FASTFLAG(DebugGraphicsD3D9ForceFFP, false);
    RBX_FASTFLAG(GearVR, false);
    RBX_FASTFLAG(CardboardVR, false);
    RBX_FASTFLAG(GraphicsGLUseDiscard, false);
    RBX_FASTFLAG(DebugGraphicsGL, false);
    RBX_FASTFLAG(GraphicsGL3, false);
    RBX_FASTFLAG(GraphicsGLReduceLatency, false);
    RBX_FASTFLAG(UpdateContextOnFollowingFrame, false);
    RBX_FASTFLAG(DebugAdornsDisabled, false);
    RBX_FASTFLAG(RenderThumbModelReflectionsFix, false);
    RBX_FASTFLAG(RenderFixFog, false);
    RBX_FASTFLAG(RenderVR, false);
    RBX_FASTFLAG(RenderLowLatencyLoop, false);
    RBX_FASTFLAG(RenderUIAs3DInVR, true);
    RBX_FASTFLAG(CancelPendingTextureLoads, true);
    RBX_FASTFLAG(SmoothTerrainRenderLOD, false);
    RBX_FASTFLAG(DebugSmoothTerrainRenderFixedLOD, false);
    RBX_FASTFLAG(NoRandomColorsWithoutOutlines, true);
    RBX_FASTFLAG(FixMeshOffset, false);
    RBX_FASTFLAG(RenderMoonBillboard, true);
    RBX_FASTFLAG(GlowEnabled, false);
    RBX_FASTFLAG(FixCameraTargetStudio, false);
    RBX_FASTFLAG(CustomEmitterRenderEnabled, false);
    RBX_FASTFLAG(RenderMaterialsOnMobile, true);
    RBX_FASTFLAG(ForceWangTiles, false);
    RBX_FASTFLAG(Studio3DGridUseAALines, true);
    RBX_FASTFLAG(DebugSSAOForce, false);
    RBX_FASTFLAG(OnScreenProfiler, false);
    RBX_FASTFLAG(TaskSchedulerCyclicExecutive, false);
    RBX_FASTFLAG(DebugTaskSchedulerProfiling, false);
    RBX_FASTFLAG(AnchoredSendPositionUpdate, false);
    RBX_FASTFLAG(ResizeGuiOnStep, false);
    RBX_FASTFLAG(UseNewUrlClass, false);
}

namespace FInt {
    RBX_FASTINT(SmoothTerrainPhysicsCacheSize, 16*1024*1024);
    RBX_FASTINT(PhysicsBulletManifoldPoolSize, 1024);
    RBX_FASTINT(IntersectingOthersCallsAllowedOnSpawn, 5);
    RBX_FASTINT(PhysicalPropDensity_PLASTIC_MATERIAL, 700);
    RBX_FASTINT(PhysicalPropDensity_SMOOTH_PLASTIC_MATERIAL, 700);
    RBX_FASTINT(PhysicalPropDensity_NEON_MATERIAL, 700);
    RBX_FASTINT(PhysicalPropDensity_WOOD_MATERIAL, 350);
    RBX_FASTINT(PhysicalPropDensity_WOODPLANKS_MATERIAL, 350);
    RBX_FASTINT(PhysicalPropDensity_MARBLE_MATERIAL, 2563);
    RBX_FASTINT(PhysicalPropDensity_SLATE_MATERIAL, 2691);
    RBX_FASTINT(PhysicalPropDensity_CONCRETE_MATERIAL, 2403);
    RBX_FASTINT(PhysicalPropDensity_GRANITE_MATERIAL, 2691);
    RBX_FASTINT(PhysicalPropDensity_BRICK_MATERIAL, 1922);
    RBX_FASTINT(PhysicalPropDensity_PEBBLE_MATERIAL, 2403);
    RBX_FASTINT(PhysicalPropDensity_COBBLESTONE_MATERIAL, 2691);
    RBX_FASTINT(PhysicalPropDensity_RUST_MATERIAL, 7850);
    RBX_FASTINT(PhysicalPropDensity_DIAMONDPLATE_MATERIAL, 7850);
    RBX_FASTINT(PhysicalPropDensity_ALUMINUM_MATERIAL, 7700);
    RBX_FASTINT(PhysicalPropDensity_METAL_MATERIAL, 7850);
    RBX_FASTINT(PhysicalPropDensity_GRASS_MATERIAL, 900);
    RBX_FASTINT(PhysicalPropDensity_SAND_MATERIAL, 1602);
    RBX_FASTINT(PhysicalPropDensity_FABRIC_MATERIAL, 700);
    RBX_FASTINT(PhysicalPropDensity_ICE_MATERIAL, 919);
    RBX_FASTINT(PhysicalPropDensity_AIR_MATERIAL, 0);
    RBX_FASTINT(PhysicalPropDensity_WATER_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropDensity_ROCK_MATERIAL, 2691);
    RBX_FASTINT(PhysicalPropDensity_GLACIER_MATERIAL, 919);
    RBX_FASTINT(PhysicalPropDensity_SNOW_MATERIAL, 900);
    RBX_FASTINT(PhysicalPropDensity_SANDSTONE_MATERIAL, 2691);
    RBX_FASTINT(PhysicalPropDensity_MUD_MATERIAL, 900);
    RBX_FASTINT(PhysicalPropDensity_BASALT_MATERIAL, 2691);
    RBX_FASTINT(PhysicalPropDensity_GROUND_MATERIAL, 900);
    RBX_FASTINT(PhysicalPropDensity_CRACKED_LAVA_MATERIAL, 2691);
    RBX_FASTINT(PhysicalPropFriction_PLASTIC_MATERIAL, 300);
    RBX_FASTINT(PhysicalPropFriction_SMOOTH_PLASTIC_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropFriction_NEON_MATERIAL, 300);
    RBX_FASTINT(PhysicalPropFriction_WOOD_MATERIAL, 480);
    RBX_FASTINT(PhysicalPropFriction_WOODPLANKS_MATERIAL, 480);
    RBX_FASTINT(PhysicalPropFriction_MARBLE_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropFriction_SLATE_MATERIAL, 400);
    RBX_FASTINT(PhysicalPropFriction_CONCRETE_MATERIAL, 700);
    RBX_FASTINT(PhysicalPropFriction_GRANITE_MATERIAL, 400);
    RBX_FASTINT(PhysicalPropFriction_BRICK_MATERIAL, 800);
    RBX_FASTINT(PhysicalPropFriction_PEBBLE_MATERIAL, 400);
    RBX_FASTINT(PhysicalPropFriction_COBBLESTONE_MATERIAL, 500);
    RBX_FASTINT(PhysicalPropFriction_RUST_MATERIAL, 700);
    RBX_FASTINT(PhysicalPropFriction_DIAMONDPLATE_MATERIAL, 350);
    RBX_FASTINT(PhysicalPropFriction_ALUMINUM_MATERIAL, 400);
    RBX_FASTINT(PhysicalPropFriction_METAL_MATERIAL, 400);
    RBX_FASTINT(PhysicalPropFriction_GRASS_MATERIAL, 400);
    RBX_FASTINT(PhysicalPropFriction_SAND_MATERIAL, 500);
    RBX_FASTINT(PhysicalPropFriction_FABRIC_MATERIAL, 350);
    RBX_FASTINT(PhysicalPropFriction_ICE_MATERIAL, 20);
    RBX_FASTINT(PhysicalPropFriction_AIR_MATERIAL, 10);
    RBX_FASTINT(PhysicalPropFriction_WATER_MATERIAL, 5);
    RBX_FASTINT(PhysicalPropFriction_ROCK_MATERIAL, 500);
    RBX_FASTINT(PhysicalPropFriction_GLACIER_MATERIAL, 50);
    RBX_FASTINT(PhysicalPropFriction_SNOW_MATERIAL, 300);
    RBX_FASTINT(PhysicalPropFriction_SANDSTONE_MATERIAL, 500);
    RBX_FASTINT(PhysicalPropFriction_MUD_MATERIAL, 300);
    RBX_FASTINT(PhysicalPropFriction_BASALT_MATERIAL, 700);
    RBX_FASTINT(PhysicalPropFriction_GROUND_MATERIAL, 450);
    RBX_FASTINT(PhysicalPropFriction_CRACKED_LAVA_MATERIAL, 650);
    RBX_FASTINT(PhysicalPropElasticity_PLASTIC_MATERIAL, 500);
    RBX_FASTINT(PhysicalPropElasticity_SMOOTH_PLASTIC_MATERIAL, 500);
    RBX_FASTINT(PhysicalPropElasticity_NEON_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropElasticity_WOOD_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropElasticity_WOODPLANKS_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropElasticity_MARBLE_MATERIAL, 170);
    RBX_FASTINT(PhysicalPropElasticity_SLATE_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropElasticity_CONCRETE_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropElasticity_GRANITE_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropElasticity_BRICK_MATERIAL, 150);
    RBX_FASTINT(PhysicalPropElasticity_PEBBLE_MATERIAL, 170);
    RBX_FASTINT(PhysicalPropElasticity_COBBLESTONE_MATERIAL, 170);
    RBX_FASTINT(PhysicalPropElasticity_RUST_MATERIAL, 200);
    RBX_FASTINT(PhysicalPropElasticity_DIAMONDPLATE_MATERIAL, 250);
    RBX_FASTINT(PhysicalPropElasticity_ALUMINUM_MATERIAL, 250);
    RBX_FASTINT(PhysicalPropElasticity_METAL_MATERIAL, 250);
    RBX_FASTINT(PhysicalPropElasticity_GRASS_MATERIAL, 100);
    RBX_FASTINT(PhysicalPropElasticity_SAND_MATERIAL, 50);
    RBX_FASTINT(PhysicalPropElasticity_FABRIC_MATERIAL, 50);
    RBX_FASTINT(PhysicalPropElasticity_ICE_MATERIAL, 150);
    RBX_FASTINT(PhysicalPropElasticity_AIR_MATERIAL, 10);
    RBX_FASTINT(PhysicalPropElasticity_WATER_MATERIAL, 10);
    RBX_FASTINT(PhysicalPropElasticity_ROCK_MATERIAL, 170);
    RBX_FASTINT(PhysicalPropElasticity_GLACIER_MATERIAL, 150);
    RBX_FASTINT(PhysicalPropElasticity_SNOW_MATERIAL, 30);
    RBX_FASTINT(PhysicalPropElasticity_SANDSTONE_MATERIAL, 150);
    RBX_FASTINT(PhysicalPropElasticity_MUD_MATERIAL, 70);
    RBX_FASTINT(PhysicalPropElasticity_BASALT_MATERIAL, 150);
    RBX_FASTINT(PhysicalPropElasticity_GROUND_MATERIAL, 100);
    RBX_FASTINT(PhysicalPropElasticity_CRACKED_LAVA_MATERIAL, 150);
    RBX_FASTINT(PhysicalPropFWeight_PLASTIC_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_SMOOTH_PLASTIC_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_NEON_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_WOOD_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_WOODPLANKS_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_MARBLE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_SLATE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_CONCRETE_MATERIAL, 300);
    RBX_FASTINT(PhysicalPropFWeight_GRANITE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_BRICK_MATERIAL, 300);
    RBX_FASTINT(PhysicalPropFWeight_PEBBLE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_COBBLESTONE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_RUST_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_DIAMONDPLATE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_ALUMINUM_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_METAL_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_GRASS_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_SAND_MATERIAL, 5000);
    RBX_FASTINT(PhysicalPropFWeight_FABRIC_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_ICE_MATERIAL, 3000);
    RBX_FASTINT(PhysicalPropFWeight_AIR_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_WATER_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_ROCK_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_GLACIER_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_SNOW_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_SANDSTONE_MATERIAL, 5000);
    RBX_FASTINT(PhysicalPropFWeight_MUD_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_BASALT_MATERIAL, 300);
    RBX_FASTINT(PhysicalPropFWeight_GROUND_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropFWeight_CRACKED_LAVA_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_PLASTIC_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_SMOOTH_PLASTIC_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_NEON_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_WOOD_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_WOODPLANKS_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_MARBLE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_SLATE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_CONCRETE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_GRANITE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_BRICK_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_PEBBLE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_COBBLESTONE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_RUST_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_DIAMONDPLATE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_ALUMINUM_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_METAL_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_GRASS_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_SAND_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_FABRIC_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_ICE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_AIR_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_WATER_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_ROCK_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_GLACIER_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_SNOW_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_SANDSTONE_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_MUD_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_BASALT_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_GROUND_MATERIAL, 1000);
    RBX_FASTINT(PhysicalPropEWeight_CRACKED_LAVA_MATERIAL, 1000);
    RBX_FASTINT(InterpolationMaxDelayMSec, 500);
    RBX_FASTINT(MinMsecBetweenTimePosEventReplication, 100);
    RBX_FASTINT(MinSecondLengthForLongSoundChannel, 5);
    RBX_FASTINT(NumDummyJobs, 0);
    RBX_FASTINT(StreamingSafeMemWatermarkMB, 30);
    RBX_FASTINT(StreamingLowMemWatermarkMB, 10);
    RBX_FASTINT(StreamingCriticalLowMemWatermarkMB, 5);
    RBX_FASTINT(StremingMemoryPoolReleaseThresholdMB, 2);
    RBX_FASTINT(FMODSoundChannels, 100);
    RBX_FASTINT(NumSmoothingPasses, 0);
    RBX_FASTINT(RegLambda, -1000000000);
    RBX_FASTINT(SmoothTerrainMaxLuaRegion, 4*1024*1024);
    RBX_FASTINT(SmoothTerrainMaxCppRegion, 64*1024*1024);
    RBX_FASTINT(CSGVoxelizerFadeRadius, 300);
    RBX_FASTINT(PGSPenetrationMarginMax, 50000);
    RBX_FASTINT(PGSPenetrationMarginMin, 100);
    RBX_FASTINT(PGSPenetrationMarginMaxBump, 5);
    RBX_FASTINT(PGSPenetrationResolutionDamping, 7);
    RBX_FASTINT(PGSPenetrationVelocityForMinMargin, 20);
    RBX_FASTINT(PGSAlign2AxesCorrectionDamping, 10);
    RBX_FASTINT(PGSBallInSocketCorrectionDamping, 10);
    RBX_FASTINT(LuaMemoryBonus, 0);
    RBX_FASTINT(ScriptAnalyzerIgnoreWarnings, 0);
    RBX_FASTINT(NumPhysicsTouchPacketsPerStep, 1);
    RBX_FASTINT(StreamOutCompressionIdListLengthThreshold, 250);
    RBX_FASTINT(GamePerfMonitorPercentage, 2);
    RBX_FASTINT(GamePerfMonitorReportTimer, 10);
    RBX_FASTINT(US30484p2, 0);
    // Default mirrors RBX::TaskScheduler::ThreadPoolConfig::Threads1 == 1
    // (Base/include/rbx/TaskScheduler.h:80). Written as the literal because
    // including TaskScheduler.h here would create a header cycle through
    // rbx/Debug.h -> FastLog.h.
    RBX_FASTINT(RCCServiceThreadCount, 1);
    RBX_FASTINT(ValidateLauncherPercent, 0);
    RBX_FASTINT(BootstrapperVersionNumber, 51261);
    RBX_FASTINT(RequestPlaceInfoTimeoutMS, 2000);
    RBX_FASTINT(RequestPlaceInfoRetryCount, 5);
    RBX_FASTINT(InferredCrashReportingHundredthsPercentage, 1000);
    RBX_FASTINT(SuperClusterFastClusterSize, 1000);
    RBX_FASTINT(RenderMaxParticleSize, 200);
    RBX_FASTINT(OutlineBrightnessMin, 50);
    RBX_FASTINT(OutlineBrightnessMax, 160);
    RBX_FASTINT(OutlineThickness, 40);
    RBX_FASTINT(RenderShadowIntensity, 75);
    RBX_FASTINT(RenderTextureManagerBudget, 0);
    RBX_FASTINT(RenderTextureManagerBudgetFor4k, 0);
    RBX_FASTINT(FontSizePadding, 1);
    RBX_FASTINT(FastClusterUpdateWaitingBudgetMs, 4);
    RBX_FASTINT(FRMRecomputeDistanceFrameDelay, 100);
    RBX_FASTINT(RenderGBufferMinQLvl, 20);
    RBX_FASTINT(SpeedTestPeriodMillis, 1000);
    RBX_FASTINT(MaxSpeedDeltaMillis, 300);
    RBX_FASTINT(SpeedCountCap, 5);
}

namespace FString {
    RBX_FASTSTRING(AssetTypeHeaderForSounds, "");
    RBX_FASTSTRING(GroupInfoUrl, "%sgroups/%i");
    RBX_FASTSTRING(GroupAlliesUrl, "%sgroups/%i/allies");
    RBX_FASTSTRING(GroupEnemiesUrl, "%sgroups/%i/enemies");
    RBX_FASTSTRING(GetGroupsUrl, "%susers/%i/groups");
    RBX_FASTSTRING(FriendsOnlineUrl, "/my/friendsonline");
    RBX_FASTSTRING(ClientExternalBrowserUserAgent, "Roblox/WinInet");
    RBX_FASTSTRING(GetUserIdUrl, "users/get-by-username?username=%s");
    RBX_FASTSTRING(GetUserNameUrl, "users/%i");
    RBX_FASTSTRING(GetFriendsUrl, "%susers/%i/friends");
    RBX_FASTSTRING(SocialServiceFriendUrl, "Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d");
    RBX_FASTSTRING(SocialServiceBestFriendUrl, "Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d");
    RBX_FASTSTRING(SocialServiceGroupUrl, "Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d");
    RBX_FASTSTRING(SocialServiceGroupRankUrl, "Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d");
    RBX_FASTSTRING(SocialServiceGroupRoleUrl, "Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d");
    RBX_FASTSTRING(GamePassServicePlayerHasPassUrl, "Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d");
    RBX_FASTSTRING(MobileJoinRateFormatUrl, "Game/JoinRate.ashx?st=%d&i=%d&p=%d&c=%s&r=%s&d=%d&b=%d&platform=%s");
}

namespace DFFlag {
    RBX_DFFLAG(CylinderSurfaceNormalHitFix, false);
    RBX_DFFLAG(OrthonormalizeJointCoords, false);
    RBX_DFFLAG(UseTerrainCustomPhysicalProperties, false);
    RBX_DFFLAG(StepAnimatedJointsInBufferZone, false);
    RBX_DFFLAG(PGSWakeOtherAssemblyForJoints, false);
    RBX_DFFLAG(FixTouchEndedReporting, false);
    RBX_DFFLAG(CyclicExecutiveThrottlingCancelWorldStepAccum, false);
    RBX_DFFLAG(ContactManagerOptimizedQueryExtents, false);
    RBX_DFFLAG(SimpleHermiteSplineInterpolate, false);
    RBX_DFFLAG(RemoveInterpolationSmoothing, false);
    RBX_DFFLAG(CleanUpInterpolationTimestamps, false);
    RBX_DFFLAG(SoundFailedToLoadContext, false);
    RBX_DFFLAG(MinMaxDistanceEnabled, false);
    RBX_DFFLAG(RollOffModeEnabled, false);
    RBX_DFFLAG(LogFileSystem, false);
    RBX_DFFLAG(FileSystemGetCacheDirectoryLikeAndroid, false);
    RBX_DFFLAG(RobloxAnalyticsTrackingEnabled, false);
    RBX_DFFLAG(DebugAnalyticsSendUserId, true);
    RBX_DFFLAG(UseNewUrlClass, true);
    RBX_DFFLAG(InfluxDb09Enabled, false);
    RBX_DFFLAG(HeartBeatCanRunTwiceFor30Hz, true);
    RBX_DFFLAG(PhysicsFPSTimerFix, false);
    RBX_DFFLAG(ScriptExecutionContextApi, false);
    RBX_DFFLAG(VariableHeartbeat, false);
    RBX_DFFLAG(TeamCreateIgnoreRunStateTransition, true);
    RBX_DFFLAG(UrlReconstructToAssetGame, false);
    RBX_DFFLAG(UrlReconstructToAssetGameSecure, false);
    RBX_DFFLAG(UrlReconstructRejectInvalidSchemes, false);
    RBX_DFFLAG(ContentProviderHttpCaching, false);
    RBX_DFFLAG(ImageFailedToLoadContext, false);
    RBX_DFFLAG(HttpCacheCleanBasedOnMemory, false);
    RBX_DFFLAG(HttpCurlDomainTrimmingWithBaseURL, false);
    RBX_DFFLAG(HttpZeroLatencyCaching, false);
    RBX_DFFLAG(CleanMutexHttp, true);
    RBX_DFFLAG(SSLErrorLogAll, false);
    RBX_DFFLAG(DebugHttpAsyncCallsForStatsReporting, true);
    RBX_DFFLAG(UseAssetTypeHeader, false);
    RBX_DFFLAG(DebugDisableLogServiceExecuteScript, false);
    RBX_DFFLAG(UserServerFollowers, false);
    RBX_DFFLAG(DebugDisableTimeoutDisconnect, false);
    RBX_DFFLAG(PGSWakePrimitivesWithBodyMoverPropertyChanges, false);
    RBX_DFFLAG(CustomEmitterInstanceEnabled, false);
    RBX_DFFLAG(EnableParticleDrag, false);
    RBX_DFFLAG(AccessoriesAndAttachments, false);
    RBX_DFFLAG(FixClippedScrollingFrameNavigation, true);
    RBX_DFFLAG(UserCameraZoomPersistThroughTeleport, false);
    RBX_DFFLAG(UserMouseLockSettingSaveTeleport, false);
    RBX_DFFLAG(GetLocalTeleportData, false);
    RBX_DFFLAG(SetCoreDisableNotifications, false);
    RBX_DFFLAG(SetCoreSendNotifications, false);
    RBX_DFFLAG(SetCoreMoveChat, false);
    RBX_DFFLAG(SetCoreDisableChatBar, false);
    RBX_DFFLAG(TextTransparencyRenderingFix, false);
    RBX_DFFLAG(AnimationEasingStylesEnabled, false);
    RBX_DFFLAG(CachedPoseInitialized, false);
    RBX_DFFLAG(UseNewAnalyticsApi, false);
    RBX_DFFLAG(CacheModelExtents, false);
    RBX_DFFLAG(ElasticEasingUseTwoPi, false);
    RBX_DFFLAG(TurnOffFakeEventsForInputEvents, false);
    RBX_DFFLAG(TurnOffFakeEventsForCAS, false);
    RBX_DFFLAG(UseStarterPlayerCharacter, false);
    RBX_DFFLAG(UseStarterPlayerCharacterScripts, false);
    RBX_DFFLAG(UseStarterPlayerHumanoid, false);
    RBX_DFFLAG(DoNotCleanCSGDictionaryOnPublishInCloudEdit, true);
    RBX_DFFLAG(AnimationAllowProdUrls, true);
    RBX_DFFLAG(DontUseInsertServiceOnAnimLoad, false);
    RBX_DFFLAG(AnimationFailedToLoadContext, false);
    RBX_DFFLAG(GetLastestAssetVersionEnabled, false);
    RBX_DFFLAG(DisableBackendInsertConnection, false);
    RBX_DFFLAG(GASendInsertRequestFail, true);
    RBX_DFFLAG(InfluxSendInsertRequestFail, true);
    RBX_DFFLAG(InsertServiceLoadModelErrorDoNotCreateEmpty, true);
    RBX_DFFLAG(InsertServiceLoadModelErrorNoLuaExceptionReturnNull, false);
    RBX_DFFLAG(DisableInsertServiceForTeamCreate, false);
    RBX_DFFLAG(PreventReturnOfElevatedPhysicsFPS, false);
    RBX_DFFLAG(ReportElevatedPhysicsFPSToGA, true);
    RBX_DFFLAG(TrackPhysicalPropertiesGA, false);
    RBX_DFFLAG(UseNewPersistenceSubdomain, true);
    RBX_DFFLAG(GetGroupsAsyncEnabled, false);
    RBX_DFFLAG(GetGlobalDataStorePcallFix, false);
    RBX_DFFLAG(UseNewDataStoreLogging, true);
    RBX_DFFLAG(UseNewDataStoreRequestSetTimestampBehaviour, true);
    RBX_DFFLAG(ErrorOnFailedToLoadAnim, false);
    RBX_DFFLAG(SetUpdateTimeOnClumpChanged, false);
    RBX_DFFLAG(SetNetworkOwnerFixAnchoring, false);
    RBX_DFFLAG(SetNetworkOwnerFixAnchoring2, false);
    RBX_DFFLAG(NetworkOwnershipRuleReplicates, false);
    RBX_DFFLAG(LocalScriptSpawnPartAlwaysSetOwner, false);
    RBX_DFFLAG(MaterialPropertiesEnabled, false);
    RBX_DFFLAG(FormFactorDeprecated, false);
    RBX_DFFLAG(FixShapeChangeBug, false);
    RBX_DFFLAG(FixFallenPartsNotDeleted, false);
    RBX_DFFLAG(UseRemoveTypeIDTricks, true);
    RBX_DFFLAG(TeamCreateRaiseChangedOperationForAssetId, true);
    RBX_DFFLAG(DisplayTextBoxTextWhileTypingMobile, false);
    RBX_DFFLAG(PasteWithCapsLockOn, false);
    RBX_DFFLAG(TextBoxIsFocusedEnabled, false);
    RBX_DFFLAG(CheckMarketplaceAvailable, false);
    RBX_DFFLAG(Order66, false);
    RBX_DFFLAG(RestrictSales, false);
    RBX_DFFLAG(DoubleCheckPurchase, true);
    RBX_DFFLAG(AllowClientFallback, true);
    RBX_DFFLAG(IgnoreDifferentPlayer, true);
    RBX_DFFLAG(AllowHideHudShortcut, false);
    RBX_DFFLAG(AllowHideHudShortcutDefault, true);
    RBX_DFFLAG(ProcessAcceleratorsBeforeGUINavigation, false);
    RBX_DFFLAG(DontProcessMouseEventsForGuiTarget, false);
    RBX_DFFLAG(CloseStatesBeforeChildRemoval, false);
    RBX_DFFLAG(DataModelProcessHttpRequestResponseOnLockUseSubmitTask, true);
    RBX_DFFLAG(SmootherVehicleSeatControlSystem, false);
    RBX_DFFLAG(LimitScrollWheelMaxToHalfWindowSize, false);
    RBX_DFFLAG(FixRotatedHorizontalScrollBar, false);
    RBX_DFFLAG(SpheresAllowedCustom, false);
    RBX_DFFLAG(FilteringEnabledDialogFix, false);
    RBX_DFFLAG(FixAnchoredSeatingPosition, false);
    RBX_DFFLAG(FixSeatingWhileSitting, false);
    RBX_DFFLAG(PersistenceCurlCookies, false);
    RBX_DFFLAG(GetFocusedTextBoxEnabled, false);
    RBX_DFFLAG(EnableShowStatsLua, false);
    RBX_DFFLAG(LockViolationInstanceCrash, false);
    RBX_DFFLAG(PGSSolverSimIslandsEnabled, false);
    RBX_DFFLAG(PGSSolverUsesIslandizableCode, false);
    RBX_DFFLAG(PGSSolverIntegrateOnlyPositionsEnabled, false);
    RBX_DFFLAG(UseSubmitTaskWhenFiringSignalsOnSettings, true);
    RBX_DFFLAG(FixYieldThrottling, false);
    RBX_DFFLAG(LuaCrashOnIncorrectTables, false);
    RBX_DFFLAG(RejectHashesInLinkedSource, false);
    RBX_DFFLAG(BadTypeOnSpawnErrorEnabled, false);
    RBX_DFFLAG(BadTypeOnDelayErrorEnabled, false);
    RBX_DFFLAG(ScriptContextGuardAgainstCStackOverflow, false);
    RBX_DFFLAG(LogPrivateModuleRequires, true);
    // Defined at App/Lua-5.1.4/src/lstrlib.c:366 -- the one settings variable
    // whose DYNAMIC_FASTFLAGVARIABLE lives in a .c file (Roblox pattern-match
    // depth guard); harvested here like every other instance.
    RBX_DFFLAG(LuaStrlibLimitMatchDepth, true);
    RBX_DFFLAG(LockViolationScriptCrash, false);
    RBX_DFFLAG(RestoreTransparencyOnToolChange, false);
    RBX_DFFLAG(DraggerUsesNewPartOnDuplicate, false);
    RBX_DFFLAG(UnifyDragGridSizes, true);
    RBX_DFFLAG(HumanoidCookieRecursive, false);
    RBX_DFFLAG(ReplicateLuaMoveDirection, false);
    RBX_DFFLAG(NamesOccludedAsDefault, false);
    RBX_DFFLAG(FixedSitFirstPersonMove, true);
    RBX_DFFLAG(HumanoidCheckForNegatives, true);
    RBX_DFFLAG(EnableMotionAnalytics, false);
    RBX_DFFLAG(Enable2edHumanoidDistanceLogging, false);
    RBX_DFFLAG(RotateFirstPersonInVR, true);
    RBX_DFFLAG(CheckForHeadHit, false);
    RBX_DFFLAG(PGSFixGroundSinking, false);
    RBX_DFFLAG(HumanoidFeetIsPlastic, false);
    RBX_DFFLAG(FixSlowLadderClimb, false);
    RBX_DFFLAG(HumanoidFloorPVUpdateSignal, false);
    RBX_DFFLAG(NoWalkAnimWeld, false);
    RBX_DFFLAG(ClampRunSignalMinSpeed, false);
    RBX_DFFLAG(EnableClimbingDirection, false);
    RBX_DFFLAG(FixJumpGracePeriod, true);
    RBX_DFFLAG(EnableHipHeight, false);
    RBX_DFFLAG(ExtendedCrashInfluxReporting, false);
    RBX_DFFLAG(ApiCapitalizationChanges, false);
    RBX_DFFLAG(LoadStarterGearWithoutLoadCharacter, false);
    RBX_DFFLAG(ValidateCharacterAppearanceUrl, false);
    RBX_DFFLAG(FilterKickMessage, false);
    RBX_DFFLAG(UseR15Character, false);
    RBX_DFFLAG(CloudEditDisablePlayerDestroy, false);
    RBX_DFFLAG(UseComSiftUpdatedWebChatFilterParamsAndHeader, true);
    RBX_DFFLAG(ConstructModerationFilterTextParamsAndHeadersUseLegacyFilterParams, true);
    RBX_DFFLAG(UseProtocolCompatibilityCheck, false);
    RBX_DFFLAG(DebugLogProcessCharacterRequestTime, false);
    RBX_DFFLAG(DisablePlaceAuthenticationPoll, false);
    RBX_DFFLAG(FilterAllPlayerPropChanges, false);
    RBX_DFFLAG(LogAllPlayerPropChanges, false);
    RBX_DFFLAG(TeamCreateAcceptTerrainReplicatedUpdatesWhenFilteringEnabled, true);
    RBX_DFFLAG(US27664p3, false);
    RBX_DFFLAG(US26301, false);
    RBX_DFFLAG(US28292p0, true);
    RBX_DFFLAG(US28292p1, false);
    RBX_DFFLAG(US28292p2, true);
    RBX_DFFLAG(US28292p3, false);
    RBX_DFFLAG(US28814, false);
    RBX_DFFLAG(US29001p1, false);
    RBX_DFFLAG(US29001p2, false);
    RBX_DFFLAG(IgnoreInvalidTicket, true);
    RBX_DFFLAG(HashConfigP1, false);
    RBX_DFFLAG(HashConfigP2, false);
    RBX_DFFLAG(HashConfigP7, false);
    RBX_DFFLAG(US25317p1, true);
    RBX_DFFLAG(US25317p2, true);
    RBX_DFFLAG(WhiteListChatFilter, false);
    RBX_DFFLAG(ReadDeSerializeProcessFlow, true);
    RBX_DFFLAG(ExplicitlyAssignDefaultPropVal, false);
    RBX_DFFLAG(GetCharacterAppearanceEnabled, false);
    RBX_DFFLAG(CreatePlayerGuiLocal, false);
    RBX_DFFLAG(FirePlayerAddedAndPlayerRemovingOnClient, false);
    RBX_DFFLAG(LoadGuisWithoutChar, false);
    RBX_DFFLAG(FilterInvalidWhisper, true);
    RBX_DFFLAG(CloudEditSupportPlayersKickAndShutdown, true);
    RBX_DFFLAG(DebugLogStaleInstanceCacheEntry, false);
    RBX_DFFLAG(PhysicsSenderSleepingUpdate, false);
    RBX_DFFLAG(PhysicsSenderUseOwnerTimestamp, false);
    RBX_DFFLAG(PhysicsSenderCheckPartInServiceBeforeSend, false);
    RBX_DFFLAG(DebugPhysicsSenderLogCacheMissToGA, false);
    RBX_DFFLAG(RCCSupportCloudEdit, false);
    RBX_DFFLAG(CloudEditGARespectsThrottling, false);
    RBX_DFFLAG(CloudEditCheckClientPresent, false);
    RBX_DFFLAG(DebugCrashOnFailToLoadClientSettings, false);
    RBX_DFFLAG(UseNewSecurityKeyApi, false);
    RBX_DFFLAG(UseNewMemHashApi, false);
    RBX_DFFLAG(US30476, false);
    RBX_DFFLAG(FullscreenRefocusingFix, false);
    RBX_DFFLAG(MouseDeltaWhenNotMouseLocked, false);
    RBX_DFFLAG(UserInputViewportSizeFixWindows, true);
    RBX_DFFLAG(DontOpenWikiOnClient, false);
    RBX_DFFLAG(WindowsInferredCrashReporting, false);
    RBX_DFFLAG(TextScaleDontWrapInWords, false);
    RBX_DFFLAG(ScreenShotDuplicationFix, false);
    RBX_DFFLAG(SphericalSparklesEmission, false);
    RBX_DFFLAG(DontReorderScreenGuisWhenDescendantRemoving, false);
    RBX_DFFLAG(G3DQuatConstructorFix, true);
    RBX_DFFLAG(FixMatrixToAxisAngle, false);
    RBX_DFFLAG(CyclicExecutiveForServerTweaks, false);
}

namespace DFInt {
    RBX_DFINT(BulletContactBreakThresholdPercent, 200);
    RBX_DFINT(BulletContactBreakOrthogonalThresholdPercent, 200);
    RBX_DFINT(BulletContactBreakOrthogonalThresholdActivatePercent, 200);
    RBX_DFINT(WorldStepMax, 30);
    RBX_DFINT(WorldStepsOffsetAdjustRate, 100);
    RBX_DFINT(smoothnessReportThreshold, 10000);
    RBX_DFINT(MaxMissedWorldStepsRemembered, 12);
    RBX_DFINT(SmoothTerrainPhysicsRayAabbSlop, 0);
    RBX_DFINT(InterpolationBufferMinSize, 2);
    RBX_DFINT(InterpolationBufferMaxSize, 8);
    RBX_DFINT(InterpolationDelayFactorTenths, 15);
    RBX_DFINT(MaxNodesPerPathPacket, 3);
    RBX_DFINT(NodeIntervalCapMS, 100);
    RBX_DFINT(MaxContentProviderRunsPerStep, 10);
    RBX_DFINT(MaxContentProviderRunsAccumulated, 20);
    RBX_DFINT(ExternalHttpResponseTimeoutMillis, 30000);
    RBX_DFINT(ExternalHttpRequestSizeLimitKB, 1024);
    RBX_DFINT(ExternalHttpResponseSizeLimitKB, 4096);
    RBX_DFINT(StreamingMemoryUsagePercent, 50);
    RBX_DFINT(MinSoundStreamSizeBytes, 512000);
    RBX_DFINT(TimeBetweenCheckingApiAccessMillis, 5000);
    RBX_DFINT(ContentProviderThreadPoolSize, 16);
    RBX_DFINT(HttpMaxRedirects, 10);
    RBX_DFINT(HttpCacheCleanMinFilesRequired, 3000);
    RBX_DFINT(HttpCacheCleanMaxFilesToKeep, 1500);
    RBX_DFINT(HttpCacheSendStatsEveryXSeconds, 60);
    RBX_DFINT(HttpCacheCleanIfGBLessThan, 5);
    RBX_DFINT(HttpCurlDeepErrorReportingCount, 0);
    RBX_DFINT(HttpResponseDefaultTimeoutMillis, 60000);
    RBX_DFINT(HttpSendDefaultTimeoutMillis, 60000);
    RBX_DFINT(HttpConnectDefaultTimeoutMillis, 60000);
    RBX_DFINT(HttpDataSendDefaultTimeoutMillis, 60000);
    RBX_DFINT(HttpSendStatsEveryXSeconds, 60);
    RBX_DFINT(HttpGAFailureReportPercent, 1);
    RBX_DFINT(HttpRBXEventFailureReportHundredthsPercent, 0);
    RBX_DFINT(HttpRbxApiJobFrequencyInSeconds, 1);
    RBX_DFINT(MaxLogHistory, 512);
    RBX_DFINT(BadLogInfluxHundredthsPercentage, 0);
    RBX_DFINT(BadLogMask, 0);
    RBX_DFINT(RakNetMaxSplitPacketCount, 1400);
    RBX_DFINT(PointBalanceCacheInvalidateTimeMs, 1000);
    RBX_DFINT(MaxAwardPointsHttpCallsPerMinute, 60);
    RBX_DFINT(SecondsPerBatchAwardPointsCall, 10);
    RBX_DFINT(UserHttpRequestsPerMinuteLimit, 500);
    RBX_DFINT(TeleportRetryTimes, 5);
    RBX_DFINT(CreatePlacePerMinute, 5);
    RBX_DFINT(CreatePlacePerPlayerPerMinute, 1);
    RBX_DFINT(SavePlacePerMinute, 10);
    RBX_DFINT(HttpInfluxHundredthsPercentage, 0);
    RBX_DFINT(ElevatedPhysicsFPSReportThresholdTenths, 610);
    RBX_DFINT(PathfindingMaxDistance, 512);
    RBX_DFINT(PathfindingJobRunsPerSecond, 10);
    RBX_DFINT(PathfindingChunksPerInvokation, 10);
    RBX_DFINT(PathfindingAgeToCollectChunks, 1000);
    RBX_DFINT(PathfindingCollectPeriod, 100);
    RBX_DFINT(PathfindingDefaultBucketNum, 2048);
    RBX_DFINT(PathfindingVerticalChunkClamp, 1);
    RBX_DFINT(PathfindingSmoothIterations, 5);
    RBX_DFINT(PathfindingAverageWindow, 7);
    RBX_DFINT(DataStoreMaxKeysToFetch, 100);
    RBX_DFINT(DataStoreKeyLengthLimit, 50);
    RBX_DFINT(DataStoreMaxPageSize, 100);
    RBX_DFINT(DataStoreMaxValueSize, 64*1024);
    RBX_DFINT(DataStoreTouchTimeoutInSeconds, 5);
    RBX_DFINT(DataStoreSameKeyPerMinute, 10);
    RBX_DFINT(DataStoreJobFrequencyInSeconds, 1);
    RBX_DFINT(DataStoreFetchFrequenceInSeconds, 30);
    RBX_DFINT(DataStoreFixedRequestLimit, 60);
    RBX_DFINT(DataStorePerPlayerRequestLimit, 10);
    RBX_DFINT(DataStoreInitialBudget, 100);
    RBX_DFINT(DataStoreOrderedSetFixedRequestLimit, 30);
    RBX_DFINT(DataStoreOrderedSetPerPlayerRequestLimit, 5);
    RBX_DFINT(DataStoreOrderedSetInitialBudget, 50);
    RBX_DFINT(DataStoreRefetchFixedRequestLimit, 30);
    RBX_DFINT(DataStoreRefetchPerPlayerRequestLimit, 5);
    RBX_DFINT(DataStoreSortedFixedRequestLimit, 5);
    RBX_DFINT(DataStoreSortedPerPlayerRequestLimit, 2);
    RBX_DFINT(DataStoreSortedInitialBudget, 10);
    RBX_DFINT(DataStoreMaxBudgetMultiplier, 100);
    RBX_DFINT(DataStoreMaxThrottledQueue, 30);
    RBX_DFINT(DataStoreAnalyticsReportEveryNSeconds, 60);
    RBX_DFINT(PercentApiRequestsRecordGoogleAnalytics, 1);
    RBX_DFINT(HttpRbxApiClientPerMinuteRequestLimit, 300);
    RBX_DFINT(HttpRbxApiMaxBudgetMultiplier, 1);
    RBX_DFINT(HttpRbxApiRequestsPerMinuteServerLimit, 300);
    RBX_DFINT(HttpRbxApiRequestsPerMinutePerPlayerInServerLimit, 100);
    RBX_DFINT(HttpRbxApiMaxThrottledQueueSize, 50);
    RBX_DFINT(HttpRbxApiMaxRetryBudgetPerMinute, 500);
    RBX_DFINT(HttpRbxApiMaxRetryCount, 10);
    RBX_DFINT(HttpRbxApiMaxRetryQueueSize, 500);
    RBX_DFINT(HttpRbxApiMaxSyncRetries, 3);
    RBX_DFINT(HttpRbxApiSyncRetryWaitTimeMSec, 500);
    RBX_DFINT(RemoteDelayedQueueLimit, 256);
    RBX_DFINT(ExpireMarketPlaceServiceCacheSeconds, 60);
    RBX_DFINT(PurchaseMismatchReportRate, 100);
    RBX_DFINT(PurchaseErrorReportRate, 100);
    RBX_DFINT(OnCloseTimeoutInSeconds, 30);
    RBX_DFINT(ActionStationDebounceTime, 2);
    RBX_DFINT(MoveInGameChatToTopPlaceId, 0);
    RBX_DFINT(LuaChatFloodCheckMessages, 7);
    RBX_DFINT(LuaChatFloodCheckInterval, 15);
    RBX_DFINT(LuaExceptionPlaceFilter, 0);
    RBX_DFINT(LuaExceptionThrottlingPercentage, 0);
    RBX_DFINT(LuaGcBoost, 1);
    RBX_DFINT(LuaGcMaxKb, 100);
    RBX_DFINT(DraggerMaxMovePercent, 100);
    RBX_DFINT(DraggerMaxMoveSteps, 10000);
    RBX_DFINT(PGSJumpForceAdjustment, 520);
    RBX_DFINT(HumanoidFloorTeleportWeightValue, 50);
    RBX_DFINT(HumanoidFloorManualFrictionVelocityMultValue, 100);
    RBX_DFINT(MotionDiscontinuityThreshold, 1);
    RBX_DFINT(RCCInfluxHundredthsPercentage, 1000);
    RBX_DFINT(MaxDataStepsPerCyclic, 5);
    RBX_DFINT(MaxDataStepsAccumulated, 15);
    RBX_DFINT(MaxClusterSendStepsPerCyclic, 5);
    RBX_DFINT(MaxClusterSendStepsAccumulated, 15);
    RBX_DFINT(MaxDataOutJobScaling, 10);
    RBX_DFINT(NumPhysicsPacketsPerStep, 1);
    RBX_DFINT(PhysicsSenderRate, 15);
    RBX_DFINT(WebChatFilterHttpTimeoutSeconds, 60);
    RBX_DFINT(ReportTimeLimit1, 4000);
    RBX_DFINT(Rtl1InfluxHundredthsPercentage, 100);
    RBX_DFINT(ReportTimeLimit2, 8000);
    RBX_DFINT(Rtl2InfluxHundredthsPercentage, 100);
    RBX_DFINT(ReportTimeLimit3, 1500);
    RBX_DFINT(Rtl3InfluxHundredthsPercentage, 100);
    RBX_DFINT(Rtl5InfluxHundredthsPercentage, 1);
    RBX_DFINT(Rtl6InfluxHundredthsPercentage, 100);
    RBX_DFINT(HashConfigP9, 100);
    RBX_DFINT(PartStreamingGCMinRegionLength, 2);
    RBX_DFINT(JoinDataCompressionLevel, 1);
    RBX_DFINT(JoinDataBonus, 0);
    RBX_DFINT(MaxClusterKBPerSecond, 40);
    RBX_DFINT(MaxDataPacketPerSend, 1);
    RBX_DFINT(PacketErrorInfluxHundredthsPercentage, 10000);
    RBX_DFINT(PhysicsCompressionSizeFilter, 50);
    RBX_DFINT(HashConfigP3, 4);
    RBX_DFINT(HashConfigP4, 1000);
    RBX_DFINT(HashConfigP5, 1);
    RBX_DFINT(HashConfigP6, 1);
    RBX_DFINT(HashConfigP8, 64);
    RBX_DFINT(MaxWaitTimeBeforeForcePacketProcessMS, 0);
    RBX_DFINT(MaxProcessPacketsStepsPerCyclic, 5);
    RBX_DFINT(MaxProcessPacketsStepsAccumulated, 15);
    RBX_DFINT(MaxProcessPacketsJobScaling, 10);
    RBX_DFINT(DebugMovementPathNumTotalWayPoint, 1000);
    RBX_DFINT(JoinInfluxHundredthsPercentage, 0);
    RBX_DFINT(MaxStreamPacketsPerStep, 16);
    RBX_DFINT(MaxServerStreamRegionRadius, 16);
    RBX_DFINT(StreamJobPriorityAmplifierRadius, 0);
    RBX_DFINT(MaxConsecutiveStreamJobWorkLoad, 1);
    RBX_DFINT(WriteFullDmpPercent, 0);
    RBX_DFINT(ClientInstanceQuotaCap, 10000);
    RBX_DFINT(ClientInstanceQuotaInitial, 2000);
    RBX_DFINT(PhysicsSenderBufferHealthThreasholdPercent, 40);
    RBX_DFINT(PhysicsSenderRotationThresholdThousandth, 20);
    RBX_DFINT(TaskSchedulerThreadCountEnum, 1);
    RBX_DFINT(HttpResponseExtendedTimeoutMillis, 600000);
    RBX_DFINT(HttpSendExtendedTimeoutMillis, 600000);
    RBX_DFINT(HttpConnectExtendedTimeoutMillis, 600000);
    RBX_DFINT(HttpDataSendExtendedTimeoutMillis, 600000);
    RBX_DFINT(TexAtlasUpdateLineHeight, 150);
    RBX_DFINT(TaskSchedularBatchErrorCalcFPS, 300);
}

namespace DFString {
    RBX_DFSTRING(RobloxAnalyticsURL, "");
    RBX_DFSTRING(HttpCurlProxyHostAndPort, "");
    RBX_DFSTRING(HttpInfluxURL, "");
    RBX_DFSTRING(HttpInfluxDatabase, "");
    RBX_DFSTRING(HttpInfluxUser, "");
    RBX_DFSTRING(HttpInfluxPassword, "");
    RBX_DFSTRING(AssetUrlPiece, "");
    RBX_DFSTRING(AssetVersionUrlPiece, "");
    RBX_DFSTRING(BaseSetsUrlPiece, "");
    RBX_DFSTRING(CollectionUrlPiece, "");
    RBX_DFSTRING(FreeModelUrlPiece, "");
    RBX_DFSTRING(FreeDecalUrlPiece, "");
    RBX_DFSTRING(UserSetsUrlPiece, "");
    RBX_DFSTRING(AssetVersionsUrl, "");
    RBX_DFSTRING(US30605p1, "");
    RBX_DFSTRING(US30605p2, "");
    RBX_DFSTRING(US30605p3, "");
    RBX_DFSTRING(US30605p4, "");
    RBX_DFSTRING(US30605p5, "");
    RBX_DFSTRING(MemHashConfig, "");
}

#endif // RBX_FASTLOG_H
