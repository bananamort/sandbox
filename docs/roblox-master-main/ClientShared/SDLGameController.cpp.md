# SDLGameController.cpp

Source: `roblox-sandbox/ClientShared/SDLGameController.cpp` (666 lines)

## Purpose

Implements the SDL2 gamepad bridge: initializes SDL (gamecontroller + haptic subsystems), loads `fonts/gamecontrollerdb.txt` mappings through ContentProvider, binds to UserInputService/HapticService signals inside a DataModel write task, then per render-step polls SDL events and converts button/axis motion into Roblox InputObjects fired via `UserInputService::dangerousFireInputEvent`, while maintaining infinite-duration LEFTRIGHT haptic effects for vibration.

## API

```cpp
SDLGameController::SDLGameController(shared_ptr<RBX::DataModel> newDM);
void SDLGameController::initSDL();            // SDL_Init(GAMECONTROLLER|HAPTIC) + mapping load + submitTask(bindToDataModel, Write)
void SDLGameController::bindToDataModel();    // connect updateInputSignal, getSupportedGamepadKeyCodesSignal,
                                              //        setEnabledVibrationMotorsSignal, setVibrationMotorSignal
RBX::Gamepad SDLGameController::getRbxGamepadFromJoystickId(int joystickId);
void SDLGameController::addController(int gamepadId);          // SDL_IsGameController/Open, register maps, fire connected
void SDLGameController::removeController(int joystickId);      // unmap, destroy haptics, SDL_GameControllerClose
void SDLGameController::updateControllers();                   // SDL_PollEvent loop + refreshHapticEffects()
void SDLGameController::onControllerButton(const SDL_ControllerButtonEvent);
void SDLGameController::onControllerAxis(const SDL_ControllerAxisEvent);
void SDLGameController::setVibrationMotorsEnabled(RBX::InputObject::UserInputType); // enables LARGE+SMALL only
void SDLGameController::setVibrationMotor(RBX::InputObject::UserInputType,
    RBX::HapticService::VibrationMotor motor, shared_ptr<const RBX::Reflection::Tuple> args);
shared_ptr<const RBX::Reflection::ValueArray>
    SDLGameController::getAvailableGamepadKeyCodes(RBX::InputObject::UserInputType); // parses SDL mapping string

// free functions (external linkage, defined outside the class):
RBX::KeyCode getKeyCodeFromSDLAxis(SDL_GameControllerAxis, int& axisValueChanged);
RBX::KeyCode getKeyCodeFromSDLButton(SDL_GameControllerButton);
RBX::KeyCode getKeyCodeFromSDLName(std::string sdlName);      // for "a","b","leftx",... mapping-string tokens
```

Constants: `MAX_AXIS_VALUE 32767.0f`.

## Usage

Compiled by WindowsClient (the vcxproj references it via the header; the file itself includes v8datamodel/{DataModel, GamepadService, UserInputService, ContentProvider}). Event flow: `UserInputService.updateInputSignal` → `updateControllers()` → `onControllerButton/Axis` → mutate `gamepad[code]` InputObject position/delta/state → `inputService->dangerousFireInputEvent(...)`. Haptics flow: `HapticService.setVibrationMotorSignal` → `setVibrationMotor` → SDL_HapticNewEffect/RunEffect with `SDL_HAPTIC_INFINITY` length and repeat each frame in `refreshHapticEffects`.

## Gotchas

- Axis Y is inverted (`currentPosition.y = -axisValue`) but X/Z are not; triggers map onto `position.z` with `INPUT_STATE_BEGIN` synthesized when z >= 1.0f.
- `onControllerAxis` divides by `MAX_AXIS_VALUE` (32767), so a full-negative axis (-32768) clamps to -1.0 via G3D::clamp — asymmetric range handled only by clamping.
- `gamepad[buttonCode]->getUserInputState()` dereferences without checking the key exists in the Gamepad map; an unmapped button arriving before GamepadService populated state would be UB.
- Vibration motors: trigger motors (LEFTTRIGGER/RIGHTTRIGGER) are force-disabled in `setVibrationMotorsEnabled`; only LARGE/SMALL drive the SDL effect. Motor values >1 or <0 from Lua are clamped, non-numeric first Tuple value logs MESSAGE_ERROR and bails.
- Every vibration change destroys and recreates the SDL haptic effect (destroy→new→run); effect id `-1` means "none".
- `initSDL` failure path returns silently after stderr fprintf — and because the early `return` precedes `submitTask`, `bindToDataModel` NEVER runs on SDL_Init failure: no signals get connected, so this object is fully inert (no input polling, no haptics), not merely half-initialized.
- `getKeyCodeFromSDLName` treats leftx/lefty both as THUMBSTICK1 (same as the axis switch) — supported-keycode reporting can't distinguish X/Y components.
- SDL guide button and invalid/max enums deliberately map to SDLK_UNKNOWN and get dropped early.
