# ReplicatedFirst.cpp

## Purpose

Implements `ReplicatedFirst` ("ReplicatedFirst"), the client-side container replicated BEFORE everything else so early loading UI/scripts can run. Tracks two lifecycle flags (default loading GUI removed; all instances replicated), runs its LocalScripts once replication completes, forwards teleport-arrival signals, and gates what may be parented under it.

## Key types and API

Descriptors:
- `func_setLoadingFinished("RemoveDefaultLoadingScreen()")` — **Security::None**.
- `event_finishedReplicating("FinishedReplicating()")`, `func_getFinishedReplicating("IsFinishedReplicating():bool")` — **Security::RobloxScript**.
- `event_loadingFinished("RemoveDefaultLoadingGuiSignal()")`, `func_getLoadingFinished("IsDefaultLoadingGuiRemoved():bool")` — **Security::RobloxScript**.

Behavior:
- `onServiceProvider`: connects DataModel gameLoadedSignal (fires immediately if already loaded).
- `gameIsLoaded`: play-solo (frontend AND backend processing both true) short-circuits `setAllInstancesHaveReplicated()`; honors deferred GUI removal (`removeDefaultLoadingGuiOnGameLoaded`).
- `setAllInstancesHaveReplicated`: RBXASSERT one-shot; empty container → defer default-GUI removal instead of starting scripts (nothing replicated = nothing to run); else `startLocalScripts()`; ALWAYS raises FinishedReplicating.
- `startLocalScripts`: restarts every LocalScript descendant passing scriptShouldRun; after teleport with matching creator id/type re-emits `sendPlayerArrivedFromTeleportSignal(customTeleportLoadingGui, dataTable)` else the empty/nil variant — exactly one arrival signal always fires post-teleport.
- `scriptShouldRun`: requires ancestor + replication complete + LocalScript; play-solo allowed, pure-server or pure-frontend contexts rejected appropriately.
- `askAddChild`: only LocalScript or GuiObject children accepted.
- `doRemoveDefaultLoadingGui`: sets flag + raises RemoveDefaultLoadingGuiSignal.

## Usage / reflection touchpoints

Pairs with TeleportService.md (arrival handshake), PlayerScripts.md/StarterPlayerScripts.md (the other early-script paths), GuiObject family in this folder; replicator ordering at [Network](../../Network/).

## Gotchas

- setAllInstancesHaveReplicated asserts NOT already-replicated but doesn't guard — a second call double-fires FinishedReplicating and re-runs scripts.
- Empty-container case silently converts "RemoveDefaultLoadingScreen" calls into deferred-on-game-loaded removal rather than executing immediately.
- scriptShouldRun returns false for ModuleScript/Script — only LocalScripts ever run from this container.
- askAddChild accepts GuiObject directly (not ScreenGui specifically) — any GuiBase2d-derived object passes if it dynamic-casts to GuiObject.
- UNKNOWN: who calls setAllInstancesHaveReplicated in real networked joins (replicator side, header/other-TU).
