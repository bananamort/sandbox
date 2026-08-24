# App/include/v8datamodel/TouchTransmitter.h

## Purpose

`TouchTransmitter` — INTERNAL creatable `Instance` auto-attached to parts that have Touched/TouchEnded listeners: debounces physics contact events via a private `TouchDebouncer` and reports touch/untouch to the owning part.

## Declared API

`class TouchTransmitter : public DescribedCreatable<TouchTransmitter, Instance, sTouchTransmitter, Reflection::ClassDescriptor::INTERNAL>, public Diagnostics::Countable<TouchTransmitter>`

- Ctor/dtor; private `boost::scoped_ptr<TouchDebouncer> touchDebouncer`.
- `bool checkTouch(const shared_ptr<PartInstance>& other)` / `bool checkUntouch(const shared_ptr<PartInstance>& other)` — debounced contact evaluation; return semantics (fired or suppressed) out-of-line.

## Gotchas

- Per project recon: this class is one of the decoy-hackFlag sites (hackFlag0/6/7 cluster in SurfaceSelection/PhysicsInstructions/TouchTransmitter) — anti-tamper noise; verify against certified doc.
- Lifetime is managed by PartInstance's add/removeTouchTransmitter (see OnDemandPartInstance in [PartInstance.md](PartInstance.md)) — created lazily on first signal connection.
- INTERNAL creatable: not intended for user creation.

## UNKNOWN

- Debounce window/threshold parameters inside TouchDebouncer (separate type, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/TouchTransmitter.md](../../v8datamodel/TouchTransmitter.md).
- Host part: [PartInstance.md](PartInstance.md); input service: [TouchInputService.md](TouchInputService.md).
