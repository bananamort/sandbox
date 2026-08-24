# util/RunStateOwner.h

## Purpose
The engine's run-loop service: `RunService` (a RUNTIME_LOCAL datamodel Service) owns run state (stopped/running/paused), game/wall clocks, and the stepped/heartbeat/renderStepped signal fan-out to both engine listeners and Lua callbacks; also defines the `Stepped`/`Heartbeat` event payload structs and `RunState`/`RunTransition` types. Header notes "TODO: Refactor: Move this out of Util".

## Declared API
```cpp
class Stepped {          // per-game-step event payload
public:
    const double gameTime, gameStep;
    const bool longStep;
    Stepped(double gameTime, double gameStep, bool longStep);
};

class Heartbeat {        // "This event occurs at regular intervals"
public:
    const double wallTime, wallStep, gameTime, gameStep;
    const Time expirationTime;
    Heartbeat(double wallTime, double wallStep, double gameTime, double gameStep, Time expirationTime);
};

enum RunState { RS_STOPPED, RS_RUNNING, RS_PAUSED };   // low-to-high precedence

class RunTransition { public: RunState oldState, newState; };

extern const char* const sRunService;

class RunService : public DescribedNonCreatable<RunService, Instance, sRunService,
                    Reflection::ClassDescriptor::RUNTIME_LOCAL>, public Service {
public:
    typedef enum {
        RENDERPRIORITY_FIRST = 0, RENDERPRIORITY_INPUT = 100, RENDERPRIORITY_CAMERA = 200,
        RENDERPRIORITY_CHARACTER = 300, RENDERPRIORITY_LAST = 2000
    } RenderPriority;

    RunService();
    ~RunService();

    static bool parallelPhysicsUserEnabled;

    // Engine-facing signals:
    rbx::signal<void(const Stepped&)>   highPrioritySteppedSignal;
    rbx::signal<void(const Stepped&)>   steppedSignal;
    rbx::signal<void(const Stepped&)>   renderSteppedSignal;
    rbx::signal<void()>                 earlyRenderSignal;
    rbx::signal<void(const Heartbeat&)> heartbeatSignal;
    rbx::signal<void(RunTransition)>    runTransitionSignal;

    TaskScheduler::Job* getPhysicsJob();
    TaskScheduler::Job* getHeartbeat();

    // Lua-facing signals:
    rbx::signal<void(double, double)> scriptSteppedSignal;
    rbx::signal<void(double)> scriptHeartbeatSignal;
    rbx::signal<void(double)> scriptRenderSteppedSignal;
    rbx::signal<void()>       scriptRenderSteppedEarlySignal;
    rbx::signal<void(double)>* getOrCreateScriptRenderSteppedSignal(bool create = true);

    void bindFunctionToRenderStepEarly(std::string name, int priority, Lua::WeakFunctionRef functionToBind);
    void unbindFunctionFromRenderStepEarly(std::string name);
    void fireRenderStepEarlyFunctions();

    void setRunState(RunState newState);
    void run()   { setRunState(RS_RUNNING); }
    void pause() { setRunState(RS_PAUSED); }
    void stop()  { setRunState(RS_STOPPED); }
    void stopTasks();
    void start();

    void raiseHeartbeat(double step, const Time::Interval& stepBudget);
    void gameStepped(double step, bool longStep);
    void gameNotStepped(double skipped);
    void renderStepped(double step, bool longStep);

    RunState getRunState() const;
    bool isEditState() const;    // RS_STOPPED
    bool isRunState() const;     // RS_RUNNING
    bool isPauseState() const;   // RS_PAUSED
    bool isRunning();            // RS_RUNNING (non-const!)
    bool isServer();  bool isClient();  bool isStudio();  bool isRunMode();

    double wallTime() const;   double gameTime() const;
    double smoothFps() const;  double heartbeatFps() const;
    double physicsCpuFraction() const;   double heartbeatCpuFraction() const;
    double physicsAverageStep() const;   double heartbeatAverageStep() const;
protected:
    void onServiceProvider(ServiceProvider* oldProvider, ServiceProvider* newProvider);
private:
    shared_ptr<PhysicsJob> physicsJob;      // friend PhysicsJob
    shared_ptr<HeartbeatTask> heartbeatTask; // friend HeartbeatTask
    std::vector<shared_ptr<void*>> dummyTasksPadding;  // or DummyTask in test builds
    RunState runState;
    double totalGameTime, totalGameTimeAtLastHeartbeat, totalWallTime, skippedTimeAccumulated;
    typedef std::pair<std::string, Lua::WeakFunctionRef> FunctionNameRefPair;
    typedef std::map<int, std::vector<FunctionNameRefPair>> EventCallbackMap;
    EventCallbackMap renderSteppedEarlyCallbackMap;
    void stepDataModel();                   // friend DataModel
};
```

## Gotchas
- Two parallel signal families: engine signals carry `Stepped`/`Heartbeat` structs; `script*Signal`s carry raw doubles (game time) for Lua bindings.
- `isRunning()` is the only non-const query (inconsistent with the rest).
- `gameNotStepped(skipped)` accumulates skipped time — clock recovery after stalls.
- RenderPriority enum values are the documented contract for `bindFunctionToRenderStepEarly` priorities (FIRST 0 / INPUT 100 / CAMERA 200 / CHARACTER 300 / LAST 2000).
- `dummyTasksPadding` exists purely to keep field offsets identical between test and non-test builds.
- `Heartbeat.expirationTime` lets receivers detect over-budget frames.

## UNKNOWN
- Exact FPS smoothing windows (.cpp-side).
