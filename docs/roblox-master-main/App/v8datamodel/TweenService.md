# TweenService.cpp

## Purpose

Implements `TweenService`, the early GUI-tween driver: keeps a weak set of tweening GuiObjects, steps them each render (client) or heartbeat (server), and dispatches completion/cancel callbacks. The modern TweenBase API lives elsewhere; this service backs legacy GuiObject::tweenStep.

## Key types and API

No reflection descriptors.

- `addTweeningObject(weak GuiObject)`: insert-once into weak set.
- `addTweenCallback(func, status)`: queues (callback, terminal-status) pairs consumed next update.
- `onServiceProvider`: clears callbacks on detach; server-present ⇒ heartbeat-driven (wallStep), else IStepped Render (gameStep).
- `update(step)`: fires all pending completion callbacks first (swap-and-clear), then iterates tweening objects — `tweenStep(step)` true (finished) or dead weak_ptr erases; erasure is iterator-safe (erase(iter++)).

## Usage / reflection touchpoints

None directly — driven by GuiObject tween methods. Pairs with GuiObject.md family in this folder.

## Gotchas

- Completion callbacks fire BEFORE the final tweenStep of that frame's batch — a callback adding a new tween on the same object races the erase loop harmlessly but ordering is subtle.
- Server-side stepping uses wallStep while client uses gameStep — pausing the game freezes tweens only on clients.
- Callbacks cleared wholesale on provider detach — in-flight tween completions are silently dropped.
