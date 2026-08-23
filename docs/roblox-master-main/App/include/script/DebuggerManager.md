# App/include/script/DebuggerManager.h

## Purpose

Declares the Lua script-debugging DataModel surface in `RBX::Scripting`: `DebuggerManager` (non-creatable internal Service holding all debuggers + global debug state), `ScriptDebugger` (per-script creatable Instance: breakpoints, watches, stack inspection, pause/step control, hook plumbing), `DebuggerBreakpoint` (line + condition child instance), `DebuggerWatch` (expression child instance), plus `BreakOnErrorMode`, `ExecutionMode`, and the `ISpecialBreakpoint` interface.

## Declared API

- Enums:
  - `enum BreakOnErrorMode { BreakOnErrorMode_Never=0, BreakOnErrorMode_AllExceptions, BreakOnErrorMode_UnhandledExceptions };`
  - `enum ExecutionMode { ExecutionMode_Continue=0, ExecutionMode_Break };`
- `struct ISpecialBreakpoint` — virtual dtor, `virtual bool hitTest(lua_State* L, lua_Debug* ar) = 0;`, public member `lua_State* baseThread;`
- `extern const char* const sDebuggerManager;`
- `class DebuggerManager : public DescribedNonCreatable<..., INTERNAL_LOCAL, Security::LocalUser>` ("Contains all data related to Lua debugging of Scripts")
  - Types: `typedef boost::unordered_map<const Instance*, ScriptDebugger*> Debuggers;` private `UnaddedDebuggers` (shared_ptr values) and `DebuggersLookup` keyed by `const lua_State*`.
  - State: enabled flag, three maps, `RBX::DataModel* dataModel`, breakOnErrorMode, scoped specialBreakpoint, executionMode, `std::list<Lua::WeakThreadRef> pausedThreads, resumingPausedThreads, errorThreads;` `bool resuming, scriptAutoResume;` signal connections for error + descendantAdded.
  - Public: ctor/dtor; `static DebuggerManager& singleton();`; `setDataModel/getDataModel`; `void enableDebugging(); bool getEnabled() const;`; break-on-error get/set; `static Reflection::Variant readWatchValue(std::string expression, int stackFrame, lua_State* L);`; `getDebuggers()` (non-const ref accessor), `shared_ptr<const Instances> getDebuggers_Reflection();`; `ScriptDebugger* findDebugger(lua_State* L);` / `(Instance* script);`; three `addDebugger` overloads (`(Instance*)`→shared_ptr, `_Reflection(shared_ptr<Instance>)`, `(shared_ptr<ScriptDebugger>)`); `void populateForLookup(lua_State* L, ScriptDebugger* debugger);`; `pause/resume/stepOver/stepInto/stepOut/reset();` inline `setScriptAutoResume(bool)`; `static void hook(lua_State* L, lua_Debug* ar);` signals `debuggerAdded/debuggerRemoved(shared_ptr<Instance>)`.
  - Protected overrides: askForbidChild, verifyAddChild, onChildAdded/onChildRemoved/onChildChanged; helpers `addScriptDebugger`, `onErrorSignal(lua_State*)`, `onHook(lua_State*, lua_Debug*)`, `addUnaddedDebuggerForAddedDescendant`.
- `extern const char* const sScriptDebugger;`
- `class ScriptDebugger : public DescribedCreatable<ScriptDebugger, Instance, sScriptDebugger, PERSISTENT_HIDDEN, Security::LocalUser>` ("Debugs an RBX::Script")
  - Types: `Breakpoints = unordered_map<int, DebuggerBreakpoint*>` (by line), `Watches = vector<DebuggerWatch*>`, `struct PausedThreadData { int pausedLine; Lua::WeakThreadRef thread; bool hasError; Stack callStack; std::string errorMessage; PausedThreadData(); }`, `PausedThreads = unordered_map<long, PausedThreadData>`; `struct FunctionInfo { shared_ptr<Instance> script; int frame; std::string name, what, namewhat, short_src; int currentline, linedefined, lastlinedefined; }; typedef std::vector<FunctionInfo> Stack;`
  - State: breakpoints/watches/specialBreakpoint, `shared_ptr<Instance> script`, four scoped_connections (started/stopped/parentChanged/cloned), `Lua::WeakThreadRef rootThread` ("Set when the Script starts and reset when it stops"), `HookFunction hookFunction` ("used to overload the hook function"), paused/error WeakThreadRefs, `lua_Debug* breakpointHookData`, raw script ptr/table bookkeeping (`globalRawScriptPtr`, `Table* prevFuncTable`, `prevRawScriptPtr`), currentLine, ignoreDebuggerBreak, currentThreadID, pausedThreads, rootThreadResumed.
  - Script binding: `Instance* getScript() const; void setScript(Script*); void setScript(ModuleScript*); std::string getScriptPath() const; void setScriptPath(std::string); void setIgnoreDebuggerBreak(bool);` (setters partially inline).
  - Breakpoints/watches: `findBreakpoint(int line); setBreakpoint(int line)->shared_ptr<DebuggerBreakpoint>; setBreakpoint_Reflection(int)->shared_ptr<Instance>; getBreakpoints(); getBreakpoints_Reflection(); addWatch(std::string)->shared_ptr<DebuggerWatch>; addWatch_Reflection(...); getWatches(); getWatches_Reflection(); Variant getWatchValue(DebuggerWatch*, int stackFrame=0); getWatchValue_Reflection(shared_ptr<Instance> watch); static Variant readWatchValue(...) [on manager]; Variant getKeyValue(std::string key, int stackFrame);`
  - State queries: `bool isDebugging()` (inline — rootThread non-empty), `isPaused()`, `hasError()` (inline), `getCurrentLine()` (inline), `isRootThreadResumed()` (inline), thread-id predicates `isPausedThread/isErrorThread/isRootThread(long)`, `setCurrentThread(long)/getCurrentThread()`.
  - Control: `pause(); resume(); resumeTo(int line); stepOver(); stepInto(); stepOut(); handleError(lua_State*); updateHook(); ScriptContext::Result resumeThread(lua_State* L, bool evalLineHookForCurrentLine = false); bool handleHook(lua_State*, lua_Debug*); bool onLineHook(lua_State*, lua_Debug*); void debuggerBreak(lua_State*, lua_Debug*);`
  - Introspection: `Stack getStack(); getStack_Reflection(); getLocals(int stackIndex); getUpvalues(int); getGlobals(); setLocal(name, value, frame=0); setUpvalue(...); setGlobal(...); const PausedThreads& getPausedThreads();`
  - Signals: `encounteredBreak(int)`, `resuming()`, `breakpointAdded/breakpointRemoved/watchAdded/watchRemoved(shared_ptr<Instance>)`, `scriptErrorDetected(int line, std::string, Stack)`.
  - Protected overrides: askForbidChild, verifySetParent, verifyAddChild, onChildAdded/onChildRemoved. Private helpers incl. statics `readLocals/readUpvalues/readGlobals/readStack`, `getScriptForLuaState`, `updateRootThread`, `setLuaHook`, `createClone`, template `withPausedThread<R>(boost::function<R(lua_State*, lua_Debug*)>)` with comment "TODO: template specialization for R=void", and out-param variant `withPausedThreadHook`.
- `extern const char* const sDebuggerBreakpoint;`
- `class DebuggerBreakpoint : public DescribedCreatable<..., PERSISTENT_HIDDEN, Security::LocalUser>`
  - State: `bool enabled; int line; std::string condition;` ctors `()`/`(int line)`, dtor.
  - Inline getters `getLine/isEnabled/getCondition`; bound props `prop_Enabled` (bool), `prop_Condition` (string), private `prop_Line_Data` (int).
  - Overrides: verifySetParent, askForbidChild→true, verifyAddChild throws `"DebuggerBreakpoint can have no children"`. Private `void setLine(int);`
- `extern const char* const sDebuggerWatch;`
- `class DebuggerWatch : public DescribedCreatable<..., PERSISTENT, Security::LocalUser>` — note PERSISTENT (not hidden): expression string, ctors, inline `getCondition` (returns the EXPRESSION string — name mismatch), `checkExpressionSyntax(); getExpression(); prop_Expression;` overrides verifySetParent/askForbidChild→true/verifyAddChild throws `"DebuggerWatch can have no children"`.

## Usage notes

- Pairs with certified App/script docs for DebuggerManager.cpp behavior (hook dispatch, breakpoint hit-testing, clone semantics).
- Studio-facing: everything is gated `Security::LocalUser`; instances are PERSISTENT_HIDDEN so they serialize but don't show in Explorer.

## Gotchas

- `DebuggerWatch::getCondition()` returns the expression member despite its name — two names, one field.
- DebuggerManager::singleton() exists alongside per-DataModel setDataModel — mixing them across DataModels is a hazard; state lives on the manager, lookup keyed by raw pointers/lua_States.
- `withPausedThread` TODO admits R=void lacks a specialization — void usage relies on the out-param variant instead.
- Breakpoints map is keyed by line number only: one breakpoint per line per debugger.
