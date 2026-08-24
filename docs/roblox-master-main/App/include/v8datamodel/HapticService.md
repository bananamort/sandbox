# App/include/v8datamodel/HapticService.h

## Purpose

`HapticService` (INTERNAL_LOCAL service) — vibration-motor control per input device: enable/disable motors (large, small, left/right trigger) and set/get motor state tuples, with signals announcing changes.

## Declared API

- `enum VibrationMotor { MOTOR_LARGE=0, MOTOR_SMALL=1, MOTOR_LEFTTRIGGER=2, MOTOR_RIGHTTRIGGER=3, MOTOR_NONE=4 };`
- Signals: `setVibrationMotorSignal<void(UserInputType, VibrationMotor, shared_ptr<const Tuple>)>`, `setEnabledVibrationMotorsSignal<void(UserInputType)>`.
- Methods: `void setEnabledVibrationMotors(InputObject::UserInputType, VibrationMotor, bool isEnabled);` `bool isVibrationSupported(UserInputType); bool isMotorSupported(UserInputType, VibrationMotor);` `void setMotor(UserInputType, VibrationMotor, shared_ptr<const Reflection::Tuple> args); shared_ptr<const Tuple> getMotor(UserInputType, VibrationMotor);`
- State: nested maps `vibrationMotorsEnabledMap` (`unordered_map<UserInputType, unordered_map<VibrationMotor,bool>>`) and `vibrationMotorsStateMap` (motor → tuple).

## Gotchas

- Motor payloads are opaque Reflection Tuples — schema defined by convention at call sites.
- MOTOR_NONE exists as a sentinel enum value.

## UNKNOWN

- Which platforms back the vibration calls (.cpp — see [HapticService.md](../../v8datamodel/HapticService.md)).

## Cross-links

- Implementation: [App/v8datamodel/HapticService.md](../../v8datamodel/HapticService.md).
- Input kin: [UserInputService.md](UserInputService.md), [GamepadService.md](GamepadService.md), [ContextActionService.md](ContextActionService.md).
