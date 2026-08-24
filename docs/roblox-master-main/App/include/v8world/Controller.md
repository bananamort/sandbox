# App/include/v8world/Controller.h

## Purpose

Enum-only header defining `LegacyController::InputType` — the vocabulary of legacy control inputs (tracks, throttle, buttons, scripted constant/sine) consumed by vehicle/humanoid controllers.

## Declared API

- `class LegacyController`
  - `typedef enum InputType { NO_INPUT = 0, LEFT_TRACK_INPUT, RIGHT_TRACK_INPUT, RIGHT_LEFT_INPUT, BACK_FORWARD_INPUT, STRAFE_INPUT, UP_DOWN_INPUT, BUTTON_1_INPUT, BUTTON_2_INPUT, BUTTON_3_INPUT, BUTTON_4_INPUT, BUTTON_3_4_INPUT, CONSTANT_INPUT, SIN_INPUT, NUM_INPUT_TYPES } InputType;`
  - In-header comment: adding items requires updating "the associated string matrix in ControllerTypes.cpp".
  - Value comments: `RIGHT_LEFT_INPUT` — −1.0 == right, 1.0 == left; `BACK_FORWARD_INPUT` — −1.0 == back, 1.0 == forward.

## Gotchas

- Enum ordering is serialized/switched elsewhere — appending is only safe at the end (before `NUM_INPUT_TYPES`) and still demands the string-matrix update.
- No methods or members here despite the name "Controller" — actual control logic lives in other headers/implementations.

## UNKNOWN

- Where the string matrix lives in this drop (`ControllerTypes.cpp` not part of App/include).

## Cross-links

- Consumers of input semantics live outside v8world (humanoid/tool layers); see [../humanoid/INDEX.md](../humanoid/INDEX.md) if present.
