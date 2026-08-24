# UserController.cpp

## Purpose

Implements FIVE classes: `ControllerService` ("ControllerService", service owning the hardware device pointer and a default HumanoidController), `Controller` (base with BindButton/UnbindButton/GetButton + ButtonChanged event), `HumanoidController` / `VehicleController` (concrete controllers), plus `ButtonBindingWidget` (a Widget rendering "Press Backspace to …" hints). VehicleController translates touch/keyboard into VehicleSeat throttle/steer each HighPriority step.

## Key types and API

### Controller
Descriptors (**Security::None**):
- "BindButton(button, caption)" + deprecated lowercase twin "bindButton"; "UnbindButton(button)"; "GetButton(button):bool" + deprecated "getButton".
- Event "ButtonChanged(button:Button)" — no security tier (default).
- Enum `Button`: Jump, Dismount. StringConverter is fully INVERTED by truthiness bugs: `if(text.find("Jump"))` is FALSE only when the string STARTS with "Jump" (position 0), and `if(npos)` is always TRUE otherwise. Net mapping: a string beginning with "Jump" falls through to the second check and becomes **DISMOUNT**; every other string — including literal "Dismount" and arbitrary garbage — becomes **JUMP**.
- Button state map with captions; setButton raises buttonChangedSignal only on transitions; getButton/getButtonCaption THROW when unbound.

### HumanoidController
- panSensitivity 0.06; rotateCam pans camera ×30×gameStep counting stepsRotating; updateCamera picks ASW vs arrow rotation by GameBasicSettings cam-lock mode; preventMovement = typing OR sitting OR platformStanding.

### VehicleController
- setVehicleSeat asserts expired weak then binds. onStepped: touch path zeroes then sets from humanoid walk direction (y>0 ⇒ throttle −1; steer tolerance 0.2, ×4 on touch devices); keyboard path NavKeys arrows+WASD → seat->setThrottle(sum), setSteer(−sum). RBXASSERT(0) when seat gone.

### ControllerService
- Ctor creates+parents a HumanoidController; holds hardwareDevice (NULL default).

### ButtonBindingWidget (RBX_REGISTER_CLASS)
- Non-creatable Widget; onClick presses bound button once (toggle TODO commented); renders translucent bar "Press Backspace to <title>" only when keyboard enabled, honoring workspace->imageServerViewHack; getKeyName knows only DISMOUNT→"Backspace".

## Usage / reflection touchpoints

BindButton family script-facing at Security::None. Pairs with SkateboardController.md/VehicleSeat.md consumers in this folder, GameBasicSettings.md cam-lock flag.

## Gotchas

- The Button StringConverter inverts both names: "Dismount" parses as Jump, "Jump" (or any "Jump"-prefixed string) parses as Dismount, and arbitrary garbage also parses as Jump — silent data corruption loading string-encoded buttons.
- VehicleController::onStepped RBXASSERT(0)s every frame after seat destruction until controller itself dies.
- bindButton re-binding overwrites nothing (insert into multimap-like set with make_pair) — duplicates possible (UNKNOWN container semantics header-side).
