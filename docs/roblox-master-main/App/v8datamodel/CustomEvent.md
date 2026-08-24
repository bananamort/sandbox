# CustomEvent.cpp

## Purpose

Implements `CustomEvent` ("CustomEvent") — the source half of the legacy float-event pair: holds a STREAMING PersistedCurrentValue, pushes SetValue to attached receivers, and exposes ReceiverConnected/Disconnected plus GetAttachedReceivers. Registration-only TU; add/removeReceiver logic lives header-side.

## Key types and API

Descriptors (all **Security::None**):
- `prop_PersistedCurrentValue("PersistedCurrentValue", category_Data, STREAMING)` — float get/set.
- `func_SetValue("SetValue", "newValue")` — BoundFunc void → setCurrentValue.
- `func_GetAttachedReceivers("GetAttachedReceivers")` — BoundFunc returning Instances.
- `event_ReceiverConnected("ReceiverConnected", "receiver")`, `event_ReceiverDisconnected("ReceiverDisconnected", "receiver")`.

Constants: `sCustomEvent = "CustomEvent"`.

## Usage / reflection touchpoints

Pairs with [CustomEventReceiver](CustomEventReceiver.md) via addReceiver/removeReceiver; value persistence rides the STREAMING descriptor path like other replicated data.

## Gotchas

- PersistedCurrentValue is the ONLY serialized state — receiver LINKS are not persisted; connections must be re-established by scripts after load.
- All logic beyond registration is in CustomEvent.h — this TU shows no fan-out code (UNKNOWN exact broadcast ordering from this file alone).
