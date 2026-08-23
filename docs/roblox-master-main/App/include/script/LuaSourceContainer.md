# App/include/script/LuaSourceContainer.h

## Purpose

Declares `RBX::LuaSourceContainer`, the non-creatable `Instance` base for everything holding Lua source (Script, ModuleScript, etc.): a `ContentId` script id, cached remote source plus its load state, editor lock bookkeeping (`requestLock`/`lockGrantedOrNot` remote signals), and static helpers that walk an instance tree and fetch linked script sources through a `ContentProvider`.

## Declared API

- `extern const char* const sLuaSourceContainer;`
- `class LuaSourceContainer : public DescribedNonCreatable<LuaSourceContainer, Instance, sLuaSourceContainer>`
  - `enum RemoteSourceLoadState { NotAttemptedToLoad, Loaded, FailedToLoad };`
  - Statics:
    - `static void loadLinkedScripts(shared_ptr<ContentProvider> cp, Instance* root, AsyncHttpQueue::ResultJob jobType, boost::function<void()> callback);`
    - `static void loadLinkedScriptsForInstances(shared_ptr<ContentProvider> cp, Instances& instances, AsyncHttpQueue::ResultJob jobType, boost::function<void()> callback);`
    - `static void blockingLoadLinkedScripts(ContentProvider* cp, Instance* root);`
    - `static void blockingLoadLinkedScriptsForInstances(ContentProvider* cp, Instances& instances);`
    - `static Reflection::RemoteEventDesc<LuaSourceContainer, void()> event_requestLock;`
  - Instance API:
    - `LuaSourceContainer();`
    - `const ContentId& getScriptId() const;` / `void setScriptId(const ContentId& contentId);`
    - `const ProtectedString& getCachedRemoteSource() const;` / `void setCachedRemoteSource(const ProtectedString& value);`
    - `int getCachedRemoteSourceLoadState() const;` / `void setCachedRemoteSourceLoadState(int value);`
    - `Instance* getCurrentEditor() const;` / `void setCurrentEditor(Instance* newEditor);`
    - `virtual void fireSourceChanged() {};` (empty default)
    - Signals: `rbx::remote_signal<void()> requestLock;` `rbx::remote_signal<void(bool)> lockGrantedOrNot;`
  - Protected: `virtual void onScriptIdChanged() {}` ; override `void processRemoteEvent(const Reflection::EventDescriptor&, const Reflection::EventArguments&, const SystemAddress& source);`
  - Private nested: `struct LinkedScriptLoadData { rbx::atomic<int> scriptCount; boost::function<void()> callbackWhenDone; shared_ptr<Instance> context; AsyncHttpQueue::ResultJob jobType; boost::mutex scriptApplyResultClosuresMutex; std::vector<boost::function<void()> > scriptApplyResultClosures; };`
  - Private statics: `linkedSourceCountingVisitor`, `linkedSourceLoadedHandler(weak_ptr<LuaSourceContainer>, AsyncHttpQueue::RequestResult, shared_ptr<const std::string>, shared_ptr<LinkedScriptLoadData>)`, `updateScriptInstancesUnderWriteLock(DataModel*, ...)`, `linkedSourceFetchingVisitor`.
  - State: `ContentId scriptId; ProtectedString cachedRemoteSource; RemoteSourceLoadState cachedRemoteSourceLoadState; weak_ptr<Instance> currentEditor;`

## Usage notes

- Pairs with certified App/script docs (`linkedSourceLoadedHandler`, `updateScriptInstancesUnderWriteLock` behavior verified there).
- `getCachedRemoteSourceLoadState` exposes the enum as plain int — cast at call site.

## Gotchas

- `currentEditor` is a weak_ptr but `getCurrentEditor()` returns a raw `Instance*` — pointer can dangle immediately after return; use only for short-lived comparisons.
- Load-state field is typed as the enum in storage but int in accessors — no validation on set.
- Static loaders take both shared_ptr and raw ContentProvider forms; blocking variants exist for startup paths where async queue isn't pumping.
