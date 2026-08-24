# App/include/v8datamodel/CustomEvent.h

## Purpose

`CustomEvent` Instance — legacy 2011-era event/value object parented under a Part: scripts call `SetValue` and every attached `CustomEventReceiver` gets the (0..1-clamped) float; tracks connected receivers via weak refs and CollectionService tagging.

## Declared API

`class CustomEvent : public DescribedCreatable<CustomEvent, Instance, sCustomEvent>`

- Reflection surface: `prop_PersistedCurrentValue` (float), `func_SetValue<void(float)>`, `func_GetAttachedReceivers<shared_ptr<const Instances>()>`, events `event_ReceiverConnected/event_ReceiverDisconnected<void(shared_ptr<Instance>)>`.
- Test-visible signals: `receiverConnected`, `receiverDisconnected`.
- Value: `float getPersistedCurrentValue() const;` `void setPersistedCurrentValue(float)` — serialization only, "WILL NOT cause receivers to get a value update"; `void setCurrentValue(float newValue)` — clamps to [0,1], raises prop change, then pushes to each live receiver whose current value differs (`receiver->sourceValueChanged(currentValue)`).
- Receivers: `shared_ptr<const Instances> getAttachedReceivers();` `void addReceiver(CustomEventReceiver*); void removeReceiver(CustomEventReceiver*);` — both fire signals only after internal state updates; add is idempotent by pointer identity.
- Tree rules: `askSetParent` allows only PartInstance parents; `askForbidChild` returns true for everything.
- Lifecycle: inline `onServiceProvider(old,new)` override — removes self from old provider's CollectionService, adds to new; when provider goes null, clears every receiver's source (`setSource(NULL)`).
- Storage: `std::list<weak_ptr<CustomEventReceiver>> receivers; float currentValue;` copy/assign declared private (not defined) per comment about "sensitive pointer management".

## Gotchas

- Values are clamped floats in [0,1] — not arbitrary payloads (Tuple-based BindableEvent is the general path).
- Receiver list holds weak_ptrs: dead receivers are skipped lazily but never pruned eagerly.
- Copy semantics disabled deliberately.

## UNKNOWN

- How CustomEventReceiver discovers events to attach to (see [CustomEventReceiver.md](CustomEventReceiver.md) / impl doc [CustomEvent.md](../../v8datamodel/CustomEvent.md)).

## Cross-links

- Implementation: [App/v8datamodel/CustomEvent.md](../../v8datamodel/CustomEvent.md).
- Pair: [CustomEventReceiver.md](CustomEventReceiver.md); registry: [CollectionService.md](CollectionService.md); modern replacement family: [Bindable.md](Bindable.md), [Remote.md](Remote.md) (N–Z half).
