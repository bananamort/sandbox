# HapticService.cpp

## Purpose

Implements `HapticService` ("HapticService") — gamepad vibration control: per-inputType/per-motor enable maps (populated externally via setEnabledVibrationMotorsSignal), Set/GetMotor Tuple state, and support queries. Console/gamepad plumbing lives on the signal consumers.

## Key types and API

Descriptors (all **Security::None**):
- `func_isVibrationSupported("IsVibrationSupported", "inputType")` — bool; true if ANY motor 0..MOTOR_NONE-1 enabled.
- `func_isMotorSupported("IsMotorSupported", "inputType","vibrationMotor")` — bool; fires setEnabledVibrationMotorsSignal FIRST (platform fills the map lazily), then map lookup default false.
- `func_setMotor("SetMotor", "inputType","vibrationMotor","vibrationValues")` — void; requires non-empty Tuple else console ERROR "no values found"; validates inputType/motor with errors; stores + raises setVibrationMotorSignal.
- `func_getMotor("GetMotor", …)` — returns stored Tuple or EMPTY tuple.

Enum registered: "VibrationMotor" {Large, Small, LeftTrigger, RightTrigger} (+ Variant/StringConverter plumbing).

Constants: `sHapticService = "HapticService"`.

## Usage / reflection touchpoints

Enabled-map population happens platform-side via the signals ([UserInputService](UserInputService.md) gamepad layer); registered in [DataModel](DataModel.md) service bootstrap.

## Gotchas

- isMotorSupported mutates state indirectly by triggering the enable-refresh signal on EVERY query — a query path with side effects.
- GetMotor returning an EMPTY tuple vs nil is ambiguous for scripts checking validity.
- SetMotor silently ignores empty Tuples after only logging — no error callback surface.
