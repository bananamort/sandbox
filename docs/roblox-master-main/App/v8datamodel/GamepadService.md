# GamepadService.cpp

## Purpose

Implements `GamepadService` ("GamepadService") — the gamepad GUI-navigation engine: per-controller persistent InputObject keymaps (8 pads × 18 buttons), thumbstick/dpad → selection-direction decoding with deadzones and repeat timers, core-vs-dev GUI navigation split, auto-select on Select-button, and navigation-enable map.

## Key types and API

Descriptors: none. Constants: VIRTUAL_CURSOR_DEADZONE 0.14, GUI_SELECTION_INITIAL_REPEAT_TIME 500 ms, GUI_SELECTION_REPEAT_TIME 120 ms. Note getUserIntentThumbstick uses its own 0.6 threshold (deadzone constant unused by that path).

Behavior:
- Enum↔int mapping for TYPE_GAMEPAD1..8; `createInputObjectForControllerKeyMap` builds Gamepad maps of InputObjects (state END, zero position) refreshed per provider; navigation enabled default true per pad.
- Hooks UIS updateInputSignal/coreInputEndedEvent/coreInputUpdatedEvent + camera cframeChangedSignal/currentCameraChangedSignal ("todo: figure out a better way to set arrow cursor" — camera moves force arrow cursor when last input was gamepad and mouse over GUI).
- Direction decode (`getGuiSelectionDirection`): left thumbstick quantized to ±1 via 0.6 thresholds (y INVERTED), only accepted when last direction in deadzone; dpad BEGIN events map directly; direction changes reset the initial-repeat timer.
- `updateOnInputStep` — held direction auto-repeats selection after 500 ms then every 120 ms.
- `trySelectGuiObject(dir[, event, gui])` — clears stale invisible selections (except under ScrollingFrame) via GuiService setSelected{CoreGui,}ObjectLua(NULL); respects getCoreGamepadNavEnabled/getGamepadNavEnabled gates; zero-vector handling sinks navigation-sourced null moves and resets direction; otherwise delegates to CoreGuiService::selectNewGuiObject or PlayerGui::selectNewGuiObject.
- `autoSelectGui()` — Select button: deselects current PlayerGui selection, else picks FIRST visible+Selectable GuiButton/TextBox descendant via recursive getRandomShownGuiObject.
- processCore → CoreGuiService tree; processDev → local player's PlayerGui (+auto-select); dev path requires isNavigationGamepad except core.
- setNavigationGamepad/isNavigationGamepad maintain the per-pad enable map.

## Usage / reflection touchpoints

Feeds from [UserInputService](UserInputService.md) core signals; selection state lives in [GuiService](GuiService.md); invoked from [DataModel](DataModel.md)::processCoreGamepadEvent/processDevGamepadEvent.

## Gotchas

- Two different thresholds: VIRTUAL_CURSOR_DEADZONE(0.14) only guards repeat-acceptance while 0.6 hard-quantizes intent — stick values between behave inconsistently.
- getRandomShownGuiObject returns the first match in child order — "random" is a misnomer.
- Navigation-enabled map resets to all-true on every provider attach; Lua-side disables don't survive rejoin.
