# Remote.cpp

## Purpose

Implements `RemoteFunction` and `RemoteEvent`, the two client↔server script communication creatables. RemoteEvent is fire-and-forget (FireServer/FireClient/FireAllClients → OnServerEvent/OnClientEvent); RemoteFunction adds request/response with per-invocation ids, pending-continuation map, delayed queue while callbacks unassigned, player-disconnect cleanup, and play-solo local simulation. All transport rides REPLICATE_ONLY internal remote events through the EventSource/replicator layer.

## Key types and API

### RemoteFunction ("RemoteFunction")
Descriptors (**Security::None** on all):
- Yield funcs: "InvokeServer(arguments)" / "InvokeClient(player, arguments):Tuple".
- AsyncCallback descriptors: "OnServerInvoke(player, arguments)" + change notifier; "OnClientInvoke(arguments)".
- Internal RemoteEventDescs, all Security::None REPLICATE_ONLY CLIENT_SERVER: "RemoteOnInvokeServer(id, player, arguments)", "RemoteOnInvokeClient(id, arguments)", "RemoteOnInvokeSuccess(id, arguments)", "RemoteOnInvokeError(id, error:string)".

Mechanics:
- Direction guards throw: InvokeServer client-only ("can only be called from the client"), InvokeClient server-only + Player arg validated. Play solo (neither present) simulates locally.
- Invocation tracking: monotonic id in [1..INT_MAX] wrapping at INT_MAX (`createRemoteInvocation` stores {weak player, resume, error}); success/error events round-trip the id; `localSuccess/localError` consume the map entry (RBXASSERT(false) on unknown id).
- Callback assignment validation: setting OnServerInvoke on a CLIENT clears it and throws ("can only be implemented on the server"); mirror for OnClientInvoke on server. Each successful set triggers `processDelayedInvocations()`.
- DelayedInvocationQueue (DFInt RemoteDelayedQueueLimit = 256): invocations arriving before callback exists are re-queued; overflow errors "Remote function invocation queue exhausted for <full name>; did you forget to implement OnServerInvoke?". process() RBXCRASHes on base_exception escaping a handler.
- Server-side validation: incoming RemoteOnInvokeServer checks `isPlayerValid(player, source)` — Player whose remote address matches sender — else MESSAGE_SENSITIVE log "ignore a remote call from %x:%d".
- Cleanup: onServiceProvider hooks Players::playerRemovingSignal → `onPlayerRemoving` errors every open invocation for that player ("Player X disconnected during remote call to Y").
- GA once-per-process: "RemoteFunction"/invokeClient, invokeServer.

### RemoteEvent ("RemoteEvent")
Descriptors:
- BoundFuncs **Security::None**: "FireServer(arguments)", "FireClient(player, arguments)", "FireAllClients(arguments)".
- `event_OnServerEvent("OnServerEvent(player, arguments)")` / `event_OnClientEvent("OnClientEvent(arguments)")` — RemoteEventDesc with LatchedSignal<rbx::remote_signal> storage created lazily via getOrCreate*(bool create); SCRIPTING + CLIENT_SERVER; **Security::None**.
- Direction guards identical pattern (throw text "…can only be called from the client/server"); play-solo fires locally into the latched signal directly.
- getOrCreateOnServerEvent(create=true on client) throws "OnServerEvent can only be used on the server"; mirrored for OnClientEvent.
- Incoming OnServerEvent validated by isPlayerValid like RemoteFunction (address spoofing defense); OnClientEvent path passes straight to EventSource.
- GA once flags: fireClient/fireServer/FireAllClients under category "RemoteEvent".

Both classes: `askSetParent` returns true unconditionally.

## Usage / reflection touchpoints

The entire modern script networking surface. Transport details pair with [Network](../../Network/) replicator docs (raiseEventInvocation addressing); FastLog.h reconstruction notes in Base docs.

## Gotchas

- Invocation ids wrap at INT_MAX and are only unique within one RemoteFunction instance — stale continuations from a wrapped id would collide (RBXASSERT in release builds is a no-op).
- RemoteEvent signals are LAZY LatchedSignals — connecting creates them, so direction-check happens at first connect, not Instance.new time.
- FireAllClients is legal ONLY from server; play-solo branch of FireAllClients delivers to local OnClientEvent only (no other clients exist).
- The delayed-queue crash path (RBXCRASH) turns a Lua handler exception during delayed processing into a process kill — by design but brutal.
- askSetParent true everywhere means remotes can be parented anywhere including workspace (visibility rules apply replicator-side).
- UNKNOWN: LatchedSignal latch semantics (whether pre-connect fires replay) header-side; EventArguments serialization limits live in replicator docs.
