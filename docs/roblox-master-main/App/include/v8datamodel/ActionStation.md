# App/include/v8datamodel/ActionStation.h

## Purpose

Header-only CRTP-style mixin template layered over any Part-bearing Instance (used for seat-like "action stations" — e.g. the Seat family) that adds sleep/debounce timers and forces the underlying `Primitive` to the seat size multiplier.

## Declared API

`template<class Base> class ActionStation : public Base`

- Constructor: initializes `sleepTime` 4 seconds in the past (so `sleepTimeUp()` is immediately true, asserted), stamps `debounceTime = now`, asserts a part primitive exists, and calls `this->getPartPrimitive()->setSizeMultiplier(Primitive::SEAT_SIZE)`.
- `virtual ~ActionStation() {}`
- Protected state: `Time sleepTime; Time debounceTime;`
- `bool sleepTimeUp() const` — true when more than **3.0 s** (hard-coded) since `sleepTime`.
- `bool debounceTimeUp() const` — true when more than `DFInt::ActionStationDebounceTime` seconds since `debounceTime`.
- `void setName(const std::string& value)` override — calls Super::setName then re-stamps `setSizeMultiplier(Primitive::SEAT_SIZE)`. The source comment labels this "Ultra mega super hack - setName is setting the internal Primitive::sizeMultiplier".

Settings: declares `DYNAMIC_FASTINT(ActionStationDebounceTime)` at file scope.

## Gotchas

- Requires `Base` to expose `getPartPrimitive()` (PartInstance-like); constructor RBXASSERTs it non-null but release builds proceed regardless.
- The debounce duration is server-config tunable via DFInt; the sleep threshold is not.
- Timer members are never reset inside the template itself — derived classes own when to restamp them.
- Template defined entirely in the header; no .cpp exists in this drop.

## UNKNOWN

- Which concrete classes instantiate `ActionStation<Base>` in this tree (Seat-family candidates; not shown here).

## Cross-links

- Siblings: [Seat.md](Seat.md), [VehicleSeat.md](VehicleSeat.md), [JointInstance.md](JointInstance.md), [Workspace.md](Workspace.md).
