# TouchInputService.cpp

## Purpose

Implements `TouchInputService`, the mobile touch-event marshaling service: platform threads push raw touch updates into a mutex-guarded buffer keyed by an incrementing touch id; the UserInputService updateInput signal drains the buffer on the input thread, maintaining one persistent InputObject per touch (delta computation, zero-delta CHANGE suppression) and firing them into UserInputService::dangerousFireInputEvent.

## Key types and API

No reflection. Constants sTouchInputService.

- `addTouchToBuffer(touch*, rbxLocation, newState)` [platform thread]: BEGIN assigns a new monotonically increasing touchCount id and registers in both directions (touch→id, id→touch); non-BEGIN appends to existing id's vector (RBXASSERT(false)+drop for unknown touch — "unaccounted for touch wtf"); END removes touch→id mapping only.
- `processTouchBuffer()` [input thread via updateInputSignal]: swaps out the whole buffer under mutex; per id reuses or creates TYPE_TOUCH InputObject; replays queued states in order: zero-delta CHANGE events are DROPPED as "unnecessary"; others get delta (except BEGIN), position, then dangerousFireInputEvent(obj, raw touch pointer); END/CANCEL cleans up both maps (re-locking the mutex mid-iteration).

## Usage / reflection touchpoints

Feeds UserInputService.md touch pipeline (TouchStarted/Changed/Ended ultimately). Pairs with PlayerMouse.md/ScrollingFrame.md touch consumers.

## Gotchas

- countToTouchMap erased on END but touchToCountMap entries for CANCEL never arrive here (CANCEL state can only be injected via InputObject elsewhere).
- Zero-delta suppression uses Vector3 equality on raw positions — float jitter still produces events.
- The cleanup path takes the buffer mutex while iterating a LOCAL swapped copy — safe but means a BEGIN arriving between swap and cleanup lands in the NEXT frame's batch.
- dangerousFireInputEvent is the "dangerous" (no validation) entry — this service trusts its own synthesis.
