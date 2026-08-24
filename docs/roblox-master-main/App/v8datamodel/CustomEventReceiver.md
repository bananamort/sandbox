# CustomEventReceiver.cpp

## Purpose

Implements `CustomEventReceiver` ("CustomEventReceiver") — the sink half of the legacy CustomEvent pair: a Source ref to a CustomEvent, SourceValueChanged/GetCurrentValue surface, and careful connect/disconnect event ordering. Also registers into CollectionService buckets and defines `Security::hackFlag4` at file scope.

## Key types and API

Descriptors (all **Security::None**):
- `prop_Source("Source", category_Data, STANDARD)` — RefPropDescriptor<Instance> → setSource.
- `event_SourceValueChanged("SourceValueChanged", "newValue")` — float payload.
- `func_GetCurrentValue("GetCurrentValue")` — BoundFunc float.
- `event_EventConnected("EventConnected", "event")`, `event_EventDisconnected("EventDisconnected", "event")`.

Constants: `sCustomEventReceiver`. File-scope: `RBX::Security::hackFlag4 = 0` ("Randomized Locations for hackflags" decoy block).

Behavior:
- `setSource(Instance*)` — no-op if same source; disconnect path: old source removeReceiver → reset weak ref → fire EventDisconnected AFTER state update; connect path: fastDynamicCast to CustomEvent (debugAssert, silently ignored when NULL!), addReceiver, sync value by firing SourceValueChanged ONLY if local ≠ source's PersistedCurrentValue, then EventConnected; setting NULL fires SourceValueChanged(0) when current ≠ 0; finally raisePropertyChanged(Source).
- `onServiceProvider` — CollectionService remove/add like Configuration; provider loss calls setSource(NULL).

## Usage / reflection touchpoints

Counterpart [CustomEvent](CustomEvent.md); bucket registration via [CollectionService](CollectionService.md).

## Gotchas

- Assigning a non-CustomEvent Source is silently DROPPED in release (debugAssert only) while still raising Source changed — scripts see a change that connected nothing.
- Value sync is one-shot on connect; later drift relies on the event's SetValue push path.
- hackFlag4 is a decoy security canary defined here but consumed elsewhere (UNKNOWN where).
