# App/include/v8datamodel/SkateboardController.h

## Purpose

`SkateboardController` — creatable `Controller` (legacy skateboard control object): Lua-facing throttle/steer floats, per-step input polling split into touch vs keyboard paths, a weak link to its `SkateboardPlatform`, and an `axisChangedSignal` for UI.

## Declared API

`class SkateboardController : public DescribedCreatable<SkateboardController, Controller, sSkateboardController>`

- Private: IStepped `onStepped(const Stepped&)`; state `float throttle; float steer;`; setters (private) `setThrottle(float)/setSteer(float)`; input steppers `onSteppedTouchInput()/onSteppedKeyboardInput()`; `weak_ptr<SkateboardPlatform> skateboardPlatform`.
- Public: ctor; `void setSkateboardPlatform(SkateboardPlatform*)`; Lua API inline getters `float getThrottle() const`, `float getSteer() const`; `rbx::signal<void(std::string)> axisChangedSignal`.

## Gotchas

- Controller holds only a WEAK platform ref — platform deletion doesn't dangle but leaves the controller inert.
- Throttle/steer are continuous floats here but ints (-1/0/1) on the platform side — conversion at the interface.
- Header includes Util/SteppedInstance.h; onStepped drives everything (polling model).

## UNKNOWN

- Axis-changed string format ("throttle 1" style?) out-of-line.

## Cross-links

- Implementation: [App/v8datamodel/SkateboardController.md](../../v8datamodel/SkateboardController.md).
- Platform: [SkateboardPlatform.md](SkateboardPlatform.md); controller base: [UserController.md](UserController.md).
