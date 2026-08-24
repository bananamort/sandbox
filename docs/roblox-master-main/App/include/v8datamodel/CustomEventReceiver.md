# App/include/v8datamodel/CustomEventReceiver.h

## Purpose

`CustomEventReceiver` Instance — partner to [CustomEvent](CustomEvent.md): holds a weak reference to a source event, receives its float values, and re-exposes them as script events. Parented under Parts only.

## Declared API

`class CustomEventReceiver : public DescribedCreatable<CustomEventReceiver, Instance, sCustomEventReceiver>`

- Reflection: `prop_Source` (RefProp to Instance), event `event_SourceValueChanged<void(float)>`, function `func_GetCurrentValue<float()>`, events `event_EventConnected/event_EventDisconnected<void(shared_ptr<Instance>)>`.
- Interop signals ("public for interoperation with CustomEvent"): `sourceValueChanged<void(float)>`; test signals `eventConnected`, `eventDisconnected`.
- Constructor wires `sourceValueChangedConnection = sourceValueChanged.connect(bind(&setCurrentValue, this, _1))` — incoming values land in `lastReceivedValue`.
- Value: `void setCurrentValue(float newValue)` (RBXASSERTs the value actually changed), `float getCurrentValue()`.
- Source plumbing (serialization only per comments): `Instance* const getSource() const; void setSource(Instance* sourceEvent);`
- Tree rules: `askSetParent` allows PartInstance only; `askForbidChild` → true for all.
- Override: `onServiceProvider(old,new)` (.cpp); commented-out `onAncestorChanged` declaration ("needs to be forward declared because it depends on CustomEvent").
- State: `weak_ptr<CustomEvent> sourceEvent; scoped_connection sourceValueChangedConnection; float lastReceivedValue;`

## Gotchas

- `RBXASSERT(newValue != lastReceivedValue)` — setting the same value twice trips an assert in diagnostics builds.
- Copy/assign disabled deliberately.
- getSource returns raw Instance* of a weak lock — can be null after the event dies.

## UNKNOWN

- How setSource resolves/attaches to a CustomEvent and fires connected signals (.cpp — see [CustomEventReceiver.md](../../v8datamodel/CustomEventReceiver.md)).

## Cross-links

- Implementation: [App/v8datamodel/CustomEventReceiver.md](../../v8datamodel/CustomEventReceiver.md).
- Pair: [CustomEvent.md](CustomEvent.md).
