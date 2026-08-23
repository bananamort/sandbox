# App/script/ — Module Index

## Module purpose

`App/script/` is the engine's scripting stack: everything between the DataModel and the embedded Lua 5.1.4 VM. State creation starts in `ScriptContext::openState`, which builds one `lua_State` per security tier (`VM_Default`, `VM_RobloxScriptPlus`, studio-plugin) through the custom `LuaAllocator`, loads trimmed standard libraries (`LuaCoreFunctions.cpp`), locks every metatable, and declares the bridge classes and globals (`game`, `wait`, `require`, ...). The bridge layer then mediates all DataModel access from Lua: `LuaInstanceBridge.cpp` turns Instance property/method/event lookups into reflection calls, `LuaSignalBridge.cpp` connects engine signals to coroutines, `LuaArguments.cpp` marshals Reflection Variants both directions, and `LuaAtomicClasses.cpp`/`LuaBridge.cpp` wrap value types as userdata. The execution pipeline runs: `Script.cpp`/`ModuleScript.cpp`/`CoreScript.cpp` instances negotiate when they run → `RuntimeScriptService`/`ScriptContext::startScript` create a sandboxed thread (`sandboxThread` chains a fresh globals table over `LUA_GLOBALSINDEX`) → `LuaVM::load` compiles text (server/dummy) or decrypts RSB1 bytecode (`LuaSerializer.inl`, keys managed by the `LuaVM*.cpp` flavor and `setKeys`) → every resume funnels through `ScriptContext::resumeImpl` → yields park in `YieldingThreads` (`ScriptEvent.cpp`) or continuations stored on `RobloxExtraSpace`, with threads kept alive by `ThreadRef.cpp`. For the Luau graft, the load/serialize path (`LuaVMClient/LuaVMServer/LuaSerializer.inl`), `resumeImpl`, `sandboxThread`, and the ckey/modkey plumbing are the primary surgery sites; the bridge/marshaling layer above them should survive largely intact.

## File roster

| File | Lines | Doc | One-line summary |
|---|---|---|---|
| ScriptContext.cpp | 3525 | [ScriptContext.md](ScriptContext.md) | Core orchestrator: VM creation/sandboxing, thread resume + continuations, timeouts, GC job, require/reload machinery, RuntimeScriptService. |
| LuaGenCS.inl | 22022 | [LuaGenCS.md](LuaGenCS.md) | Generated blob: 37 encrypted core-script bytecodes plus rot13-keyed gCoreScripts/gCoreModuleScripts index tables. |
| ScriptAnalyzer.cpp | 4059 | [ScriptAnalyzer.md](ScriptAnalyzer.md) | Self-contained Lua 5.1 lexer/parser/AST plus lint passes (UnknownGlobal, DeprecatedGlobal, ...) — the ancestor of Luau's frontend. |
| LuaAtomicClasses.cpp | 3060 | [LuaAtomicClasses.md](LuaAtomicClasses.md) | All atomic-value bridges (Vector3/CFrame/UDim2/BrickColor/sequences/...) with constructors, operators, registerClass specializations, and shared string/stack helpers. |
| DebuggerManager.cpp | 2201 | [DebuggerManager.md](DebuggerManager.md) | Studio debugging instances: hook-based pause/step machinery, breakpoints with conditions, watches evaluated in env-metatable eval threads. |
| LuaInstanceBridge.cpp | 1222 | [LuaInstanceBridge.md](LuaInstanceBridge.md) | The "Object" bridge: property/function/event/child resolution, Instance.new, yield-function machinery, callback invocation. |
| LuaSerializer.inl | 547 | [LuaSerializer.md](LuaSerializer.md) | RSB1 container codec: Proto-tree serialize/deserialize, LZ4 + XXH32 XOR scramble, modkey multiplication decode. |
| ThreadRef.cpp | 479 | [ThreadRef.md](ThreadRef.md) | WeakThreadRef/ThreadRef/LiveThreadRef lifetime pins, WeakFunctionRef registry pins, lua_tofunction/lua_pushfunction, GenericFunction closures. |
| LuaSignalBridge.cpp | 438 | [LuaSignalBridge.md](LuaSignalBridge.md) | RBXScriptSignal/RBXScriptConnection: connect/wait slots that fire events into cached coroutines with reentrancy caps. |
| LuaArguments.cpp | 586 | [LuaArguments.md](LuaArguments.md) | Reflection Variant ↔ Lua stack marshaling: typed getters, recursive table conversion, ArgumentPusher visitor. |
| LuaLibrary.cpp | 275 | [LuaLibrary.md](LuaLibrary.md) | Legacy LoadLibrary("Name") support: memoized RbxLibrary userdata backed by registry tables filled by core-script results. |
| LuaSourceContainer.cpp | 328 | [LuaSourceContainer.md](LuaSourceContainer.md) | LinkedSource storage/download state, editor-lock remote protocol, batch preload of linked scripts under write lock. |
| Script.cpp | 253 | [Script.md](Script.md) | BaseScript/Script/LocalScript instances: Source/LinkedSource/Disabled properties driving restart via IScriptFilter-approved RuntimeScriptService. |
| LuaVMDummy.cpp | 174 | [LuaVMDummy.md](LuaVMDummy.md) | Test/studio LuaVM flavor: compiles 5.1 source directly, applies DAX obfuscation locally, canCompileScripts()=true. |
| LuaVMServer.cpp | 204 | [LuaVMServer.md](LuaVMServer.md) | Server LuaVM flavor: text lua_load path, RSB1 serialization with process-lifetime encode/decode key pair, getModKeyCore transform. |
| LuaVMClient.cpp | 119 | [LuaVMClient.md](LuaVMClient.md) | Client LuaVM flavor: deserialize-only load, stubbed parser throwing LUA_ERRSYNTAX, rot13 lookup of embedded core bytecodes. |
| LuaVM.cpp | 60 | [LuaVM.md](LuaVM.md) | Anti-tamper glue: lua_vmhooked_handler hack-flag on patched lua_* entries, secure-double XOR mask init, .text scan bounds. |
| LuaEnum.cpp | 156 | [LuaEnum.md](LuaEnum.md) | Enum/Enums/EnumItem bridges over the reflection descriptor registry; read-only Name/Value, GetEnumItems. |
| ScriptEvent.cpp | 129 | [ScriptEvent.md](ScriptEvent.md) | YieldingThreads priority queue resuming waited coroutines with (elapsed, wallTime); connection tostring specializations. |
| CoreScript.cpp | 116 | [CoreScript.md](CoreScript.md) | Privileged RobloxLocked scripts: disk-.lua vs embedded-bytecode fetch policy, .cse error reporting. |
| LuaMemory.cpp | 189 | [LuaMemory.md](LuaMemory.md) | LuaAllocator: pooled small allocations, heap stats/high-water marks, identity-gated heap limit. |
| ModuleScript.cpp | 195 | [ModuleScript.md](ModuleScript.md) | ModuleScript PerVMState machine (NotRunYet/Running/Completed*) backing require: result registry refs, yielded importers, cleanup. |
| LuaCoreFunctions.cpp | 222 | [LuaCoreFunctions.md](LuaCoreFunctions.md) | Trimmed os (time/difftime only), math.noise (Perlin), debug.traceback via engine call-stack printer. |
| LuaSettings.cpp | 29 | [LuaSettings.md](LuaSettings.md) | "Lua" settings instance: GcPause/GcStepMul/DefaultWaitTime/WaitingThreadsBudget etc. |
| ScriptStats.cpp | 79 | [ScriptStats.md](ScriptStats.md) | Per-hash activity/invocation meters with resume-stack attribution; LuaStatsItem counters for the stats service. |
| LuaBridge.cpp | 147 | [LuaBridge.md](LuaBridge.md) | Template anchor forcing Bridge<Class>::registerClass/on_tostring instantiations for every bridged value type; metatable layout (__type/__index/__newindex/__gc/__tostring, readonly). |

REMAINING: none — all 26 enumerated source files under App/script/ are documented.
