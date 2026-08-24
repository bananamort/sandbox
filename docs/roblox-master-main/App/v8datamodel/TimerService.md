# TimerService.cpp

## Purpose

Implements `TimerService`, a per-DataModel heartbeat-driven delay queue: `delay(func, seconds)` inserts into an ordered list; each heartbeat fires due functors front-to-back. Used engine-side (e.g., Tool.md multi-equip cleanup, Test.md watchdogs).

## Key types and API

No reflection.

- `delay(boost::function0<void>, double seconds)`: linear insertion keeping list sorted by fire time (later at back).
- `onHeartbeat(Heartbeat)`: pops+invokes every item whose time ≤ now (Fast clock); base_exception → MESSAGE_WARNING print, item still popped (one bad callback can't stall the queue but IS dropped after firing attempt).

## Usage / reflection touchpoints

None script-facing. Pairs with DebrisService.md (same heartbeat idiom), Tool.md/Test.md consumers in this folder.

## Gotchas

- Callbacks run on the heartbeat thread inside whatever lock context delivers Heartbeat — long callbacks stall the frame.
- Exceptions during a callback discard that callback permanently (no retry).
- No cancellation API — scheduled items always eventually fire.
