# App/include/script/ModuleScript.h

## Purpose

Declares `RBX::ModuleScript`, the creatable `LuaSourceContainer` subclass backing Roblox `ModuleScript` instances: holds a `ProtectedString` source, tracks per-VM loading state (`NotRunYet/Running/CompletedError/CompletedSuccess`), caches each VM's returned result in the Lua registry, and queues threads that `require`d it while it was mid-yield.

## Declared API

- `extern const char* const sModuleScript;`
- `class ModuleScript : public DescribedCreatable<ModuleScript, LuaSourceContainer, sModuleScript>`
  - Statics/members: `static const Reflection::PropDescriptor<ModuleScript, ProtectedString> prop_Source;`
  - `enum ScriptSetupState { NotRunYet=0, Running=1, CompletedError=2, CompletedSuccess=3 };`
  - Nested `class PerVMState`
    - `PerVMState(); virtual ~PerVMState();`
    - `int getResultRegistryIndex() const;`
    - `void reassignResultRegistryIndex(int newIndex);` ("Destroy the current result index and replace it with index.")
    - `void setRunning(boost::intrusive_ptr<Lua::WeakThreadRef::Node> node);`
    - `void setCompletedError();`
    - `void setCompletedSuccess(lua_State* globalStateContainingResult, int resultRegistryIndex);`
    - `ScriptSetupState getCurrentState() const;`
    - `void addYieldedImporter(Lua::WeakThreadRef L);` / `void getAndClearYieldedImporters(std::vector<Lua::WeakThreadRef>* out);`
    - `void cleanupAndResetState();` / `void resetState();`
    - Private: state fields incl. `lua_State* globalStateContainingResult`, `int resultRegistryIndex`, `std::vector<Lua::WeakThreadRef> yieldedImporters`, helpers `releaseReferenceIfCompletedSuccessfully()` / `releaseScriptNodeIfPresent()`.
  - Instance API:
    - `ModuleScript();`
    - `bool askSetParent(const Instance*) const override;` (inline, always true)
    - `ProtectedString getSource() const;` / `void setSource(const ProtectedString& newText);`
    - `std::string requestHash() const;`
    - `PerVMState& vmState(lua_State* vm);`
    - `static void cleanupAndResetState(const weak_ptr<ModuleScript> module);` — comment: "Try to get rid of this method once new play button is launched."
    - `void resetState();` — "Reset the state of the module script without destroying its result index."
    - `void setReloadRequested(bool reload);` / `bool getReloadRequested() const;` (both inline)
    - `void fireSourceChanged() override;`
    - Signal: `rbx::signal<void(lua_State*)> starting;`
  - Protected/private: `void onScriptIdChanged() override;` `ProtectedString source; bool reloadRequested; typedef boost::unordered_map<lua_State*, PerVMState> VMStateMap; VMStateMap stateMap;`

## Usage notes

- Pairs with the certified App/script implementation docs (`docs/roblox-master-main/App/script/`) for require/resume behavior.
- Depends on `ThreadRef.h` (WeakThreadRef) and `LuaSourceContainer.h`.

## Gotchas

- State is keyed by raw `lua_State*` in an unordered_map — closing/reusing VM pointers invalidates bookkeeping; per-VM results live in each VM's registry (`resultRegistryIndex`).
- Two distinct reset paths: `cleanupAndResetState` (destroys result index) vs `resetState` (preserves it) — choosing wrong one leaks or drops cached results.
- `askSetParent` always returns true: ModuleScripts can be parented anywhere without restriction.
