# App/include/v8datamodel/GamepadService.h

## Purpose

`GamepadService` (non-creatable service) — tracks live state for up to 8 gamepads (`RBX_MAX_GAMEPADS`), converts gamepad input to GUI navigation (thumbstick-driven selection with deadzone and repeat timers), and splits processing into core vs dev paths.

## Declared API

Free types: `#define RBX_MAX_GAMEPADS 8`; `typedef boost::unordered_map<KeyCode, shared_ptr<InputObject>> Gamepad;` `typedef boost::unordered_map<int, Gamepad> Gamepads;`

`class GamepadService : public DescribedNonCreatable<GamepadService, Instance, sGamepadService>, public Service`

- Statics: `static InputObject::UserInputType getGamepadEnumForInt(int controllerIndex); static int getGamepadIntForEnum(InputObject::UserInputType);`
- State query: `Gamepad getGamepadState(int controllerIndex);`
- Auto GUI selection: `bool setAutoGuiSelectionAllowed(bool value); bool getAutoGuiSelectionAllowed() const;`
- Navigation: `bool isNavigationGamepad(InputObject::UserInputType); void setNavigationGamepad(UserInputType, bool enabled); boost::unordered_map<UserInputType, bool> getNavigationGamepadMap();` (returns the map *by value*).
- Input routing: `GuiResponse processDev(const shared_ptr<InputObject>&); GuiResponse processCore(...);` shared private `process(event, BasePlayerGui*)`.
- Selection: `GuiResponse trySelectGuiObject(const Vector2& inputVector, const shared_ptr<InputObject>&, BasePlayerGui*); GuiResponse trySelectGuiObject(const Vector2&);`
- Private machinery: `gamepads` map; per-type navigation-enabled map; repeat timers `repeatGuiSelectionTimer`, `fastRepeatGuiSelectionTimer` (Time::Fast); thumbstick helper `lastGuiSelectionDirection`; connections for update-input/input-ended/input-changed/camera-cframe; helpers `createInputObjectForGamepadKeyCode(KeyCode, UserInputType)`, `createControllerKeyMapForController(int)`, `getGuiSelectionDirection(event)`, `isVectorInDeadzone(Vector2)`, `autoSelectGui()`, `getRandomShownGuiObject(Instance*)`, camera tracking (`currentCameraChanged`, `cameraCframeChanged(CoordinateFrame)`), step/update handlers.
- Override: `onServiceProvider(old,new)`.

## Gotchas

- Navigation map getter copies the whole unordered map on every call.
- GUI auto-selection depends on camera CFrame updates — camera changes feed the direction logic.
- Deadzone/repeat timing constants live in .cpp.

## UNKNOWN

- Which KeyCode layout maps to which gamepad button (.cpp — see [GamepadService.md](../../v8datamodel/GamepadService.md)).

## Cross-links

- Implementation: [App/v8datamodel/GamepadService.md](../../v8datamodel/GamepadService.md).
- Input kin: [UserInputService.md](UserInputService.md), [InputObject.md](InputObject.md), [PlayerGui.md](PlayerGui.md) (T–Z half), [GuiService.md](GuiService.md).
