# Bindable.cpp

## Purpose

Implements `BindableFunction` ("BindableFunction") and `BindableEvent` ("BindableEvent") — the same-server-script communication pair. BindableFunction queues Invoke calls made before any OnInvoke callback is connected and drains them on connect; BindableEvent.Fire is a direct signal raise. A `Property`/PropertyInstance design exists fully commented out (`#if 0`).

## Key types and API

BindableFunction:
- `func_Invoke("Invoke", "arguments", Security::None)` — BoundYieldFunc, Tuple→Tuple.
- `callback_OnInvoke("OnInvoke", &onInvoke, "arguments", &processQueue)` — BoundAsyncCallbackDesc; the queue-drain runs as the callback-change hook.
- `invoke()` — if no OnInvoke listener: push {arguments, resume, error} onto `queue` (returns immediately); else call straight through.
- `processQueue(oldValue)` — after a callback is assigned, pops the queue copying each invocation to the stack "to avoid re-entrancy bugs".
- `askSetParent` — always true.

BindableEvent:
- `func_Fire("Fire", "arguments", Security::None)` — BoundFunc void.
- `event_Event("Event", "arguments")` — script-visible Event; `fire()` just raises it.
- `askSetParent` — always true.

Dead code block registers "Property" class: prop Value, OnGetValue/OnSetValue callbacks, ValueChanged event, FireValueChanged func — all disabled.

## Usage / reflection touchpoints

Server-local messaging primitive; contrast with [Remote](Remote.md) which does client↔server transport with security validation — Bindables have NONE by design.

## Gotchas

- Invocations queued while OnInvoke was empty fire LATER, out of original script context, once the callback connects — arguments may be stale.
- processQueue drains unconditionally in a loop; an OnInvoke that itself Invokes re-enters through the direct path (not queued).
- Fire has no queueing/buffering — listeners must exist at fire time or the event is lost.
- No replication descriptors at all: cross-server or client usage silently does nothing.
