# App/include/script/LuaSettings.h

## Purpose

Declares `RBX::LuaSettings`, the settings DataModel item (via `GlobalAdvancedSettingsItem`) that exposes Lua VM tuning knobs: GC pause/step-multipplier/limit/frequency, wait-time floors, script-start reporting, and the waiting-threads budget fraction.

## Declared API

- `extern const char* const sLuaSettings;`
- `class LuaSettings : public GlobalAdvancedSettingsItem<LuaSettings, sLuaSettings>`
  - `LuaSettings();`
  - Public data members:
    - `int gcPause;` / `int gcStepMul;`
    - `double defaultWaitTime;` / `double smallestWaitTime;`
    - `int gcLimit;` — "Ideal limit above which we trigger aggressive garbage collection, in average KB per gcFrequency"
    - `int gcFrequency;` — "How many heartbeats between manual GC steps"
    - `bool areScriptStartsReported;`
    - `float waitingThreadsBudget;` — "0..1  A percentage"

## Usage notes

- Consumed by ScriptContext/LuaVM when configuring `lua_gc` parameters and scheduler waits.
- Paired implementation documented under certified App/script module.

## Gotchas

- All fields are public PODs with no change-notification plumbing visible in this header — runtime mutation semantics live in GlobalAdvancedSettingsItem machinery.
- `waitingThreadsBudget` is a plain float with no range enforcement here; out-of-range values depend on consumer behavior.
