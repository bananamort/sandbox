# DebrisService.cpp

## Purpose

Implements `DebrisService` ("Debris") — timed item destruction: AddItem schedules instance.destroy() after a lifetime via TimerService and enforces a FIFO max-items cap (default 1000); provider shutdown flushes the queue immediately.

## Key types and API

Descriptors:
- `prop_MaxItems("MaxItems", category_Data)` — int, default 1000; setter requires **Security::LocalUser** permission ("DebrisService MaxItems is restricted") UNLESS legacy mode enabled; negative throws "MaxItems must be greater than 0" (note: message says greater than 0 while code only rejects <0).
- `func_AddItem("AddItem", "item", "lifetime"[10], Security::None)` + deprecated lowercase alias "addItem" — same handler.
- `func_LegacyMaxItems("SetLegacyMaxItems", "enabled", Security::LocalUser)`.

Constants: `sDebrisService = "Debris"`.

Behavior:
- `addItem` — null no-op; calls `item->securityCheck()` first (caller must have credentials to act on the item); TimerService delay of weak_ptr cleanup after lifetime seconds; pushes to FIFO then `cleanup()` pops+destroys while size > maxItems.
- Free function cleanup wraps destroy in try/catch warning.
- onServiceProvider — destroys EVERYTHING still queued before rebinding to the new provider's TimerService.

## Usage / reflection touchpoints

Timer plumbing via [TimerService](TimerService.md); classic pairing with [PartInstance](PartInstance.md) explosion/rocket debris.

## Gotchas

- Items are destroyed at lifetime end EVEN IF reparented elsewhere — Debris never cancels the timer.
- MaxItems eviction is strict FIFO: oldest queued items die early when the cap is hit, regardless of their remaining lifetime.
- The legacy flag exists so old scripts could keep raising MaxItems without LocalUser security.
- Queue holds strong shared_ptr until evicted — debris items stay alive (unreclaimed) for their whole lifetime even if already unparented manually.
