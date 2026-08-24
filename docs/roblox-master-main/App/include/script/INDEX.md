# App/include/script — Index

Header declarations for the scripting subsystem: the Lua VM lifecycle (`ScriptContext`), script Instance classes (`script.h`/`ModuleScript`/`CoreScript`/`LuaSourceContainer`), Lua↔C++ marshaling (`LuaArguments`, `LuaAtomicClasses`, bridge headers), thread references (`ThreadRef`), obfuscation keys (`LuaVM.h`), debugging (`DebuggerManager`), and support types. All implementations pair with the certified docs under `docs/roblox-master-main/App/script/`.

## Files

- [CoreScript.md](CoreScript.md) — non-creatable internal BaseScript whose source is fetched by name via `fetchSource`.
- [DebuggerManager.md](DebuggerManager.md) — DebuggerManager service, ScriptDebugger, DebuggerBreakpoint, DebuggerWatch; pause/step/hook machinery.
- [ExitHandlers.md](ExitHandlers.md) — Scripts::Continuations success/error handler typedefs and their lua_State-flavored Lua::Continuations adapter.
- [IScriptFilter.md](IScriptFilter.md) — interface deciding whether scripts run + RuntimeScriptService buffering Run-gated scripts.
- [LuaArguments.md](LuaArguments.md) — Lua-stack↔Variant marshaling for reflected calls plus the withVariantValue type-switch.
- [LuaAtomicClasses.md](LuaAtomicClasses.md) — Lua bridges for all atomic value types (CFrame, Vector3, UDim2, BrickColor, sequences, ...).
- [LuaCoreFunctions.md](LuaCoreFunctions.md) — extra C functions grafted onto standard libraries (`LuaOsExtension`/`LuaMathExtension`/`LuaDebugExtension` registries).
- [LuaEnum.md](LuaEnum.md) — Enums/Enum/EnumItem singleton bridges over reflection enum descriptors.
- [LuaInstanceBridge.md](LuaInstanceBridge.md) — ObjectBridge exposing Instances to Lua (global Instance table, member dispatch).
- [LuaLibrary.md](LuaLibrary.md) — named-library value + LibraryBridge.
- [LuaMemory.md](LuaMemory.md) — LuaAllocator: pooled VM allocator with heap-limit accounting.
- [LuaSettings.md](LuaSettings.md) — settings item exposing GC pause/stepmul/limit/frequency and wait-time knobs.
- [LuaSignalBridge.md](LuaSignalBridge.md) — EventInstance/EventBridge/SignalConnectionBridge for events in Lua.
- [LuaSourceContainer.md](LuaSourceContainer.md) — base for source-bearing instances: script id, cached remote source, editor locks, linked-source loading.
- [LuaVM.md](LuaVM.md) — compile/load entry points, LUAVM_SECURE shuffle/obfuscation macros, opcode encoders, fixed core keys.
- [ModuleScript.md](ModuleScript.md) — ModuleScript instance: per-VM state, registry-cached results, yielded-importer queue.
- [ScriptAnalyzer.md](ScriptAnalyzer.md) — static-analysis warning codes, locations, Result struct, analyze() entry point.
- [ScriptContext.md](ScriptContext.md) — central service owning per-identity global states, script admission, resume/scheduling, require/reload.
- [ScriptEvent.md](ScriptEvent.md) — YieldingThreads wait/resume min-heap + on_tostring bridge specializations.
- [ScriptStats.md](ScriptStats.md) — per-script-hash activity meters and the "Lua" stats tree item.
- [ThreadRef.md](ThreadRef.md) — LiveThreadRef/ThreadRef/WeakThreadRef/WeakFunctionRef reference counting + lua_tofunction/pushfunction.
- [script.md](script.md) — BaseScript/Script/LocalScript hierarchy, Code struct, Slot connection holder.

## Subdirectory

- [lua/](lua/INDEX.md) — LuaBridge template machinery and lua.hpp/stub shims.
