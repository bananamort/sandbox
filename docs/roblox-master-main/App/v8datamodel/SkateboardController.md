# SkateboardController.cpp

## Purpose

Implements `SkateboardController` ("SkateboardController"), the legacy vehicle controller bound to a SkateboardPlatform. Each step it translates touch or keyboard input into Throttle/Steer axes, raises AxisChanged, handles jump binding pass-through to the controlling Humanoid, and forces a dismount on Backspace regardless of script bindings.

## Key types and API

Descriptors:
- `propThrottle("Throttle")` / `propSteer("Steer")` — float read-only (NULL setters), category "Axes", cap UI.
- `event_AxisChanged("AxisChanged(axis:string)")` — event with NO security tier argument (descriptor default).

Input stepping (`onStepped` per Stepped):
- Touch path: reads controlling humanoid walk direction; prefers normalized UserInputService input walk vector (÷ maxInputWalkValue); movement.y>0 ⇒ throttle −1 (forward is negative!), y<0 ⇒ +1; x beyond ±0.2 ⇒ steer ∓1; zero movement zeroes both.
- Keyboard path: NavKeys arrows+WASD summed → setThrottle(forwardBackward), setSteer(−leftRight); JUMP button if script-bound else passes nav.space straight to humanoid->setJump; DISMOUNT button always set from backspace AND backspace force-triggers humanoid->setJump(true) ("do a dismount regardless of what script says").
- Axis setters raise axisChangedSignal with the axis name string.

Binding: `setSkateboardPlatform(SkateboardPlatform*)` asserts currently-expired weak ref then stores.

## Usage / reflection touchpoints

Read-only axes + event for scripts; pairs with SkateboardPlatform.md in this folder, UserInputService.md, UserController.md (controller base machinery).

## Gotchas

- Touch forward maps to NEGATIVE throttle but keyboard W/Up maps to positive sum — sign conventions differ between paths (platform side must normalize).
- Keyboard steer INVERTS left/right (−leftRight) vs touch which uses raw sign comparisons — another asymmetry.
- setSkateboardPlatform RBXASSERTs expiry — rebinding without clearing crashes debug builds.
- AxisChanged fires even when values change due to zeroing each frame? No — guarded by != checks; but rapid alternation still spams the event per-frame under oscillating input.
