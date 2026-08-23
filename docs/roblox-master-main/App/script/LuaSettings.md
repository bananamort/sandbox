# App/script/LuaSettings.cpp

## Purpose

Defines the `LuaSettings` global settings instance ("Lua") exposing tunable scripting-stack parameters through the reflection settings surface: GC pause/step multiplier/limit/frequency, default wait time, waiting-thread CPU budget, and script-start reporting. These values are consumed by ScriptContext (openState gc tuning, WaitingScriptsJob budget, cleanTimeout clamp) and the patched luaconf defaults.

## API

- `const char *const RBX::sLuaSettings = "LuaSettings"`.
- Reflection properties (all BoundProp, no explicit security → default): `GcPause` (int, category string "Garbage Collection", init LUAI_GCPAUSE), `GcStepMul` (int, init LUAI_GCMUL), `DefaultWaitTime` (double, "Settings", init 0.03), `GcLimit` (int, init 2), `GcFrequency` (int, init 0), `AreScriptStartsReported` (bool, "Diagnostics", init false), `WaitingThreadsBudget` (float, init 0.1).
- Non-reflection members initialized in ctor: `smallestWaitTime(0.016667)` (~one 60Hz frame).
- Ctor names the instance "Lua"; accessed everywhere via `RBX::LuaSettings::singleton()`.

## Usage

Consumers across App/script: `ScriptContext::openState` reads gcStepMul/gcPause into lua_gc(SETSTEPMUL/SETPAUSE); `GcJob`/`stepGc` use DFInt knobs alongside these; `WaitingScriptsJob` computes its duty cycle from `waitingThreadsBudget/60.0`; `cleanTimeout` clamps waits to `defaultWaitTime`; start-script logging checks `areScriptStartsReported`. Values are runtime-editable through the settings() surface (Plugin permission gate lives at the settings() entry point, not here).

## Gotchas

- Defaults mirror stock Lua 5.1 luconf macros (LUAI_GCPAUSE/LUAI_GCMUL via LuaConf.h include) — a Luau graft must remap these onto Luau's incremental-GC parameters or drop the properties.
- smallestWaitTime exists but nothing in this module reads it (consumed elsewhere or dead).
- GcLimit/GcFrequency are registered but not referenced anywhere in App/script — likely consumed by legacy code paths outside this module.
