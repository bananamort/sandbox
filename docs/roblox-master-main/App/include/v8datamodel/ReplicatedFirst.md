# App/include/v8datamodel/ReplicatedFirst.h

## Purpose

`ReplicatedFirst` — PERSISTENT_HIDDEN creatable service: the container replicated to clients before everything else (loading-screen assets/scripts). Tracks replication completion, owns default-loading-GUI removal timing, starts its local scripts early, and gates scripts via IScriptFilter.

## Declared API

`class ReplicatedFirst : public DescribedCreatable<ReplicatedFirst, Instance, sReplicatedFirst, Reflection::ClassDescriptor::PERSISTENT_HIDDEN>, public Service, public IScriptFilter`

- Signals: `rbx::signal<void()> finishedReplicatingSignal`, `rbx::signal<void()> removeDefaultLoadingGuiSignal`.
- Public API: `void doRemoveDefaultLoadingGui()`; inline `bool getIsDefaultLoadingGuiRemoved()`; inline `bool getIsFinishedReplicating()` / `bool getAllInstancesHaveReplicated()` (same flag); `void setAllInstancesHaveReplicated()`; `void startLocalScript(shared_ptr<Instance> instance)`; `void gameIsLoaded()`.
- IScriptFilter: `/*override*/ bool scriptShouldRun(BaseScript* script)`.
- Private state: `isDefaultLoadingGuiRemoved`, `allInstancesHaveReplicated`, `removeDefaultLoadingGuiOnGameLoaded`; helper `startLocalScripts()`.
- Parenting locked down inline: `askSetParent {return false}`, `askForbidParent = !askSetParent`, real `askAddChild`, `askForbidChild = !askAddChild`; `onServiceProvider` override.

## Gotchas

- Cannot be reparented ever (askSetParent=false) — root-level service only.
- getAllInstancesHaveReplicated and getIsFinishedReplicating read the SAME bool — two names for one state bit.
- gameIsLoaded() presumably triggers deferred removal (`removeDefaultLoadingGuiOnGameLoaded`) — ordering between it and doRemoveDefaultLoadingGui matters for loading screens.

## UNKNOWN

- What askAddChild permits (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/ReplicatedFirst.md](../../v8datamodel/ReplicatedFirst.md).
- Storage siblings: [ReplicatedStorage.md](ReplicatedStorage.md), [RobloxReplicatedStorage.md](RobloxReplicatedStorage.md), [ServerStorage.md](ServerStorage.md); loading flow: [DataModel.md](DataModel.md).
