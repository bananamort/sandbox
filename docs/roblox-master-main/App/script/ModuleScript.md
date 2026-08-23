# App/script/ModuleScript.cpp

## Purpose

Implements the `ModuleScript` instance class plus its `PerVMState` bookkeeping type — the state machine (NotRunYet → Running → CompletedSuccess/CompletedError) that backs `require`: one entry per global lua_State VM, holding the running thread's weak-ref node, yielded importer threads waiting on the module, and the registry index of the module's single return value.

## API

- `const char* const RBX::sModuleScript = "ModuleScript"`.
- Reflection: `ModuleScript::prop_Source` — `"Source"` (category_Data, STANDARD, Security::Plugin) via getSource/setSource; file-static `prop_LinkedSource` — `"LinkedSource"` via getScriptId/setScriptId.
- `ModuleScript::ModuleScript()` — empty source, reloadRequested=false, named ModuleScript.
- `class ModuleScript::PerVMState` — ctor initializes `scriptLoadingState(NotRunYet)`, `node(NULL)`, `globalStateContainingResult(NULL)`, `resultRegistryIndex(LUA_NOREF)`; dtor runs releaseReferenceIfCompletedSuccessfully + releaseScriptNodeIfPresent.
  - `void setRunning(boost::intrusive_ptr<Lua::WeakThreadRef::Node> node)` (asserts NotRunYet)
  - `void setCompletedError()` (asserts Running; immediately releases the thread node "don't wait for ModuleScript instance to be GCed")
  - `void setCompletedSuccess(lua_State* globalStateContainingResult, int resultRegistryIndex)` (asserts Running; keeps first non-null global state)
  - `int getResultRegistryIndex() const`; `ModuleScript::ScriptSetupState getCurrentState() const`
  - `void addYieldedImporter(Lua::WeakThreadRef thread)` (asserts Running); `void getAndClearYieldedImporters(std::vector<Lua::WeakThreadRef>* out)`
  - `void cleanupAndResetState()` — unrefs result, erases node refs, clears importers, back to NotRunYet
  - `void resetState()` — asserts not Running; drops result index and node, NotRunYet
  - `void reassignResultRegistryIndex(int result)` — unrefs old, stores new (used by hot-reload patching)
- `ModuleScript` members: `void setSource(const ProtectedString&)` (raisePropertyChanged), `ProtectedString getSource() const`, `std::string requestHash() const` (MD5 of source via MD5Hasher), `PerVMState& vmState(lua_State* vm)` (`return stateMap[vm];`), `static void cleanupAndResetState(const weak_ptr<ModuleScript>)` (applies to every VM entry), `void resetState()` (all VMs), `void onScriptIdChanged()`, `void fireSourceChanged()`.

## Usage

Driven almost entirely from App/script/ScriptContext.cpp: `startRunningModuleScript` calls `vmState(rootGlobalState).setRunning(WeakThreadRef::Node::create(thread))`, `setCompletedSuccess(globalState, libraryResultRef)` or `setCompletedError()`; `requireModuleScriptFromInstance` reads `getCurrentState()` and parks callers with `addYieldedImporter(WeakThreadRef(L))`; require/reload continuations use `getResultRegistryIndex`, `getAndClearYieldedImporters`, `reassignResultRegistryIndex`; shutdown uses the static `cleanupAndResetState`. The node released by `releaseScriptNodeIfPresent` is what breaks rbx::signal connections held by module code when a module errors or is cleaned up.

## Gotchas

- State map is keyed by raw `lua_State*` (`VMStateMap stateMap`) — one module can hold independent results per VM tier; entries are created lazily by `vmState()` and destroyed with the ModuleScript.
- `setCompletedError` releases the thread node immediately so connections made during a failed module die right away, while success keeps `node` alive until cleanup/restart — asymmetric lifetime worth preserving in any rework.
- `setCompletedSuccess` intentionally keeps the FIRST `globalStateContainingResult` if already set but overwrites `resultRegistryIndex` unconditionally — the hot-reload path exploits this via `reassignResultRegistryIndex(oldResultRegistryIndex)` after patching the old table in place (see ScriptContext.md).
- `resetState` asserts the module isn't Running; the reload deferral (reloadRequested flag) exists precisely to avoid violating this.
- `requestHash()` is always computed (no embedded-vs-linked distinction like Script); stats aggregation treats each distinct module source as its own bucket.
- Uses `lua_unref` (Roblox custom spelling) rather than `luaL_unref` in release paths.
