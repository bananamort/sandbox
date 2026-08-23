# App/script/LuaSourceContainer.cpp

## Purpose

Implements `LuaSourceContainer`, the shared base (alongside BaseScript) for anything carrying a `LinkedSource`: it stores the remote `ContentId` scriptId, the asynchronously downloaded `CachedRemoteSource` ProtectedString plus its load state (both REPLICATE_CLONE properties so place serialization round-trips them), an editor-lock mini protocol (RequestLock/LockGrantedOrNot/CurrentEditor remote events for collaborative editing), and the batch machinery that preloads every linked script under an instance tree before invoking a completion callback.

## API

Reflection registered here: property `"CachedRemoteSource"` (getCachedRemoteSource/setCachedRemoteSource, category_Data, REPLICATE_CLONE); `"CachedRemoteSourceLoadState"` (int-backed `RemoteSourceLoadState`, REPLICATE_CLONE); `"CurrentEditor"` RefPropDescriptor (PUBLIC_REPLICATE, weak-backed); `static RemoteEventDesc event_requestLock` — "RequestLock", Security::None, REPLICATE_ONLY, CLIENT_SERVER; file-static `event_lockGrantedOrNot` — "LockGrantedOrNot" with "granted" arg, BROADCAST.

- Constants/state: `const char* const RBX::sLuaSourceContainer = "LuaSourceContainer"`; ctor initializes `cachedRemoteSourceLoadState(NotAttemptedToLoad)`.
- Accessors: `getScriptId/setScriptId` (ContentId; change triggers `onScriptIdChanged()` virtual), `getCachedRemoteSource/setCachedRemoteSource` (raiseChanged), `getCachedRemoteSourceLoadState/setCachedRemoteSourceLoadState` (cast int→enum, raiseChanged), `getCurrentEditor/setCurrentEditor` (weak ref compare, raiseChanged).
- Batch preload API: `static void loadLinkedScripts(shared_ptr<ContentProvider>, Instance* root, AsyncHttpQueue::ResultJob, boost::function<void()> callback)`; `static void loadLinkedScriptsForInstances(..., Instances&, ...)`; `static void blockingLoadLinkedScripts(ContentProvider*, Instance*)` / `blockingLoadLinkedScriptsForInstances(ContentProvider*, Instances&)` (CEvent wait, AsyncInline); internals `linkedSourceCountingVisitor(descendant, int*)`, `linkedSourceFetchingVisitor(descendant, cp, jobType, metadata)`, `static void linkedSourceLoadedHandler(weak_ptr<LuaSourceContainer>, AsyncHttpQueue::RequestResult, shared_ptr<const std::string>, shared_ptr<LinkedScriptLoadData>)`, `static void updateScriptInstancesUnderWriteLock(DataModel* unused, shared_ptr<LinkedScriptLoadData>)`; anonymous-namespace helpers `isScriptWithLinkedSource(shared_ptr<Instance>, ContentId* out)` and `wrap(DataModel*, callback)`.
- `void LuaSourceContainer::processRemoteEvent(const Reflection::EventDescriptor&, const Reflection::EventArguments&, const SystemAddress& source)` — handles requestLock: grants iff `player != NULL && editor == NULL`, sets CurrentEditor, replies via `raiseEventInvocation(event_lockGrantedOrNot, args, &source)`; everything else defers to Instance::processRemoteEvent.

Preload algorithm: count matching descendants; if zero dispatch callback immediately through `AsyncHttpQueue::dispatchGenericCallback` (preserves queue/job ordering); else fire one `cp->loadContentString(out, PRIORITY_SCRIPT, handler, AsyncInline)` per linked script; each completion appends an apply-closure under mutex; when count reached, one final dispatch runs `updateScriptInstancesUnderWriteLock`, which acquires a `DataModel::scoped_write_transfer` if the thread lacks the write lock, applies all results (`applyLinkedScriptResult`: Succeeded → setLoaded + setCachedRemoteSource(fromTrustedSource), else FailedToLoad + error log "The LinkedSource name may have changed or been removed"), then invokes the user callback.

URL hardening inside the fetching visitor: named assets trigger once-only GA event ("Load Named LinkedSource"); `convertAssetId(baseUrl, universeId)` + `convertToLegacyContent`; HTTP URLs get `&serverplaceid=%d` appended unless they already contain "serverplaceid=" or (under DFFlag::RejectHashesInLinkedSource) a '#' — tamper attempts fail fast through the normal failure path.

## Usage

`ScriptContext::moduleContentLoaded` chains `loadLinkedScriptsForInstances` before running a remotely required module; place-load code uses the blocking variants during deserialization; BaseScript/Script/ModuleScript inherit the LinkedSource plumbing (`prop_LinkedSource` descriptors bind to getScriptId/setScriptId defined here). Consumers of the loaded state: `BaseScript::requestCode` (returns code only when Loaded) and `ScriptContext::startRunningModuleScript`.

## Gotchas

- Load-state discipline is enforced by consumers, not here: nothing stops a script from starting while FailedToLoad; requestCode/startRunningModuleScript simply see stale/empty cached source.
- Results apply strictly later than downloads, all at once under the DataModel write lock — individual scripts do NOT become runnable as their bytes arrive; the final callback fires only after every script succeeded or failed.
- The `serverplaceid=` guard is acknowledged in-source as "overly zealous": any URL containing that substring anywhere (even as a value) fails the load; '#' rejection is flag-gated.
- CachedRemoteSource is REPLICATE_CLONE — clients receive downloaded sources through replication too, not just via this HTTP path.
- `wrap` exists solely to adapt AsyncHttpQueue's DataModel* first argument to a plain callback, keeping zero-count trees queue-consistent.
