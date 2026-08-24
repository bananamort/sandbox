# App/include/v8datamodel/UserController.h

## Purpose

Four-class controller layer: `ControllerService` — INTERNAL_LOCAL non-creatable service holding the raw `UserInputBase*` hardware device; abstract `Controller` (Described + IStepped) with intent-named Button enum (JUMP/DISMOUNT mapped to SDLK), bind/unbind/caption API and buttonChangedSignal; creatable `HumanoidController` (camera pan/rotate from nav keys); creatable `VehicleController` (keyboard/touch stepping into a weak VehicleSeat).

## Declared API

`class ControllerService : public DescribedNonCreatable<ControllerService, Instance, sControllerService, Reflection::ClassDescriptor::INTERNAL_LOCAL>, public Service`
- Private `UserInputBase* hardwareDevice;` with const/non-const inline getters and inline setter. Ctor.

`class Controller : public Reflection::Described<Controller, sController, Instance>, public IStepped`
- Protected: `getHardwareDevice() const`; inline onServiceProvider chaining Super + IStepped; member `DataModel* dataModel;`; override `onAncestorChanged(AncestorChanged&)`; friend ButtonBindingWidget.
- `enum Button { JUMP = SDLK_SPACE, DISMOUNT = SDLK_BACKSPACE }` — long in-header comment: enum values intentionally SDL-keycode-mapped "purely by convenience... don't serialize this enum" to preserve decoupling; names are intent-based.
- Nested protected `struct BoundButton {Button button; bool pressed; std::string caption; shared_ptr<ButtonBindingWidget> guiWidget;}`; `typedef boost::unordered_map<Button, BoundButton> BoundButtonSet; boundButtons;`
- Protected: `void setButton(Button button, bool value);`
- Public: ctor/virtual dtor; `bool isButtonBound(Button) const`; `std::string getButtonCaption(Button) const`; `bindButton(Button, std::string caption)` / `unbindButton(Button)`; two getButton overloads (const/non-const); shortcuts inline `getJump()` / `getDismount()` ("do we need this on the controller? probably shoudn't be here." — sic); `rbx::signal<void(Button)> buttonChangedSignal`.

`class HumanoidController : public DescribedCreatable<HumanoidController, Controller, sHumanoidController>`
- Private: `int stepsRotating; float panSensitivity;` camera helpers `rotateCam(int leftRight, Camera*, float gameStep)`, `preventMovement(Humanoid*)`, `updateCamera(const Stepped&, const NavKeys&)`; IStepped `onStepped { }` EMPTY.
- Public: ctor; inline `float getPanSensitivity() const` / `setPanSensitivity(float newPan)`.

`class VehicleController : public DescribedCreatable<VehicleController, Controller, sVehicleController>`
- Private: `onStepped(const Stepped&)` override; input steppers `onSteppedKeyboardInput(shared_ptr<VehicleSeat>)` / `onSteppedTouchInput(shared_ptr<VehicleSeat>)`; `weak_ptr<VehicleSeat> vehicleSeat`.
- Public: ctor; `void setVehicleSeat(VehicleSeat* value)`.

## Gotchas

- Button enum embeds SDLK values (JUMP=SDLK_SPACE, DISMOUNT=SDLK_BACKSPACE) — serialization would freeze key mapping (explicitly warned against in header).
- HumanoidController's onStepped is an EMPTY stub while it declares updateCamera/rotateCam — actual stepping likely wired via another path or dead code.
- Controllers hold raw DataModel*/hardware pointers set through provider/ancestor hooks.

## UNKNOWN

- Who calls HumanoidController::updateCamera (not referenced by the empty onStepper shown).

## Cross-links

- Implementation: [App/v8datamodel/UserController.md](../../v8datamodel/UserController.md).
- Consumers: [VehicleSeat.md](VehicleSeat.md), [SkateboardController.md](SkateboardController.md), humanoid docs; hardware: Util/UserInputBase.
