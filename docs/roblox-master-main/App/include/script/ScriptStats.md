# App/include/script/ScriptStats.h

## Purpose

Declares `RBX::ScriptStats`, per-script-name activity accounting for the Lua VM (resume started/stopped bookkeeping feeding an ActivityMeter/InvocationMeter pair per script hash), and `RBX::LuaStatsItem`, the Stats tree item ("Lua") that surfaces VM-wide counters (GC interval/time averages, resumed/deferred thread counts) from a `ScriptContext`.

## Declared API

- `class RBX::ScriptStats`
  - Public nested: `struct StatCollection { boost::shared_ptr<ActivityMeter<2> > activity; boost::shared_ptr<InvocationMeter<2> > invocations; };` and typedef `ScriptActivityMeterMap = std::map<std::string, StatCollection>`.
  - Protected: `ScriptActivityMeterMap scriptActivityMap;` `std::stack<std::string> scriptStack;` `void stopCollection(const std::string& scriptHash);` `void startCollection(const std::string& scriptHash, bool firstTime);`
  - `ScriptStats();`
  - `void scriptResumeStarted(const std::string& scriptHash);`
  - `void scriptResumeStopped(const std::string& scriptHash);`
  - `const ScriptActivityMeterMap& getScriptActivityMap() const;` (inline, returns reference into protected member)
- `class RBX::LuaStatsItem : public Stats::Item`
  - Private: `ScriptContext* scriptContext;` `Stats::Item* averageGcInterval;` `Stats::Item* averageGcTime;` `Stats::Item* resumedThreads;` `Stats::Item* deferredThreads;`
  - `LuaStatsItem(ScriptContext* context);` (inline ctor sets name "Lua")
  - `static shared_ptr<LuaStatsItem> create(ScriptContext* context);` (inline — creates via `Creatable<Instance>::create<LuaStatsItem>` then calls `init()`)
  - `void init();`
  - `virtual void update();`

## Usage notes

- Includes pull in `script/ScriptContext.h` and `V8DataModel/Stats.h`; this header is heavy on purpose since it's used where ScriptContext is already live.
- Meter templates come from `rbx/RunningAverage.h`.

## Gotchas

- Keys are script *hashes* (strings), not names or Instance refs — two identical scripts share one stat bucket.
- `scriptStack` implies nested resume tracking; unbalanced start/stop calls will corrupt attribution.
- `LuaStatsItem` holds a raw `ScriptContext*` and raw child `Stats::Item*` pointers — lifetime is tied to the owning DataModel stats tree, not reference-counted here.
