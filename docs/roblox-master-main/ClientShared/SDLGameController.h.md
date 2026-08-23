# SDLGameController.h

Source: `roblox-sandbox/ClientShared/SDLGameController.h` (81 lines)

## Purpose

Declares `SDLGameController`, the SDL2-backed gamepad bridge that translates SDL controller/haptic events into Roblox `InputObject`s and services. It owns three ID maps (joystick→gamepad, gamepad→SDL controller handle, gamepad→haptic state), connects to the DataModel's UserInputService/HapticService/GamepadService signals, and defines `RBX::Gamepad` — the per-pad map of `KeyCode → shared_ptr<InputObject>` used everywhere gamepad input flows.

## API

```cpp
namespace RBX {
    typedef boost::unordered_map<RBX::KeyCode, boost::shared_ptr<RBX::InputObject>> Gamepad;
}

struct HapticData {
    int   hapticEffectId;
    float currentLeftMotorValue;
    float currentRightMotorValue;
    SDL_Haptic* hapticDevice;
};

class SDLGameController {
public:
    SDLGameController(boost::shared_ptr<RBX::DataModel> newDM);
    ~SDLGameController();
    void updateControllers();                                   // poll + dispatch SDL events
    void onControllerAxis(const SDL_ControllerAxisEvent);
    void onControllerButton(const SDL_ControllerButtonEvent);
    void removeController(int joystickId);
    void addController(int gamepadId);
private:
    void initSDL();  void bindToDataModel();
    RBX::UserInputService* getUserInputService();
    RBX::HapticService*    getHapticService();
    RBX::GamepadService*   getGamepadService();
    RBX::Gamepad getRbxGamepadFromJoystickId(int joystickId);
    void setupControllerId(int joystickId, int gamepadId, SDL_GameController*);
    SDL_GameController* removeControllerMapping(int joystickId);
    int  getGamepadIntForEnum(RBX::InputObject::UserInputType);
    void findAvailableGamepadKeyCodesAndSet(RBX::InputObject::UserInputType);
    boost::shared_ptr<const RBX::Reflection::ValueArray>
        getAvailableGamepadKeyCodes(RBX::InputObject::UserInputType);
    void refreshHapticEffects();
    bool setupHapticsForDevice(int id);
    void setVibrationMotorsEnabled(RBX::InputObject::UserInputType);
    void setVibrationMotor(RBX::InputObject::UserInputType,
                           RBX::HapticService::VibrationMotor,
                           shared_ptr<const RBX::Reflection::Tuple> args);
};
```

Free functions defined in the .cpp: `getKeyCodeFromSDLAxis(SDL_GameControllerAxis, int& axisValueChanged)`, `getKeyCodeFromSDLButton(SDL_GameControllerButton)`, `getKeyCodeFromSDLName(std::string)`.

## Usage

Consumed only by WindowsClient: `WindowsClient/UserInput.h` includes it and the vcxproj lists it as a ClInclude; the platform-agnostic placement in ClientShared lets non-Windows clients substitute their own backends. Requires SDL headers (`SDL.h`, `SDL_gamecontroller.h`) plus engine headers `util/KeyCode.h`, `v8datamodel/InputObject.h`, `v8datamodel/HapticService.h`.

## Gotchas

- The header pulls heavy engine types (DataModel, InputObject, HapticService) via includes despite only forward-declaring classes — including it drags in v8datamodel.
- Constructor stores a weak_ptr to the DataModel; all service lookups re-lock it and silently no-op if expired.
- `RBX::Gamepad` is a typedef here but is treated as a value type by callers (`getRbxGamepadFromJoystickId` returns copies) — mutations through one copy are invisible elsewhere.
