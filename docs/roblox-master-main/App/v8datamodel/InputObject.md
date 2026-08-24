# InputObject.cpp

## Purpose

Implements `InputObject` ("InputObject") — the immutable-ish input event instance: UserInputType/UserInputState/KeyCode/Position/Delta reflection, dual old(mod)/new(modCodes+scanCode+inputText) keyboard representations, GUI-inset-aware position reads, and a battery of key-classification predicates. Cloned for GUI hit-remapping (see BillboardGui).

## Key types and API

Descriptors (all SCRIPTING persistence, no Security:: arguments):
- `prop_userInputType("UserInputType", category_Data)`, `prop_userInputState("UserInputState", category_State)` — enums registered here: "UserInputType" {MouseButton1..3, MouseWheel, MouseMovement, Touch, Keyboard, Focus, Accelerometer, Gyro, Gamepad1..8, TextInput, None}; "UserInputState" {Begin, Change, End, Cancel, None}.
- `prop_Position("Position")`, `prop_inputDelta("Delta")` — Vector3; `prop_KeyCode("KeyCode")` — KeyCode enum.
Source comment: "todo: add scanCode, typedKey, and a way to query mod codes".

Behavior:
- Six ctors cover mouse/gamepad/key/mod/scancode variants; copy ctor copies only the CORE five fields (drops delta/inputText/scanCode/modCodes/sourceInputType!); all bind weak Workspace via DataModel.
- getPosition subtracts GuiService global inset xy when isScreenPositionEvent; getRawPosition doesn't; getWindowSize from camera viewport.
- isPublicEvent — hides legacy TYPE_MOUSEIDLE/MOUSEDELTA and any event whose sourceInputType was rewritten (GUI remapping marks them private).
- Predicates branch on UserInputService::IsUsingNewKeyboardEvents: new path uses scanCode/modCodes, old uses keyCode/mod. isNavigationKey includes WASD as well as arrows. isTextCharacterKey = modifiedKey != 0.
- StringConverter<InputObject> always false (not string-representable).

## Usage / reflection touchpoints

The currency of [UserInputService](UserInputService.md)/[ContextActionService](ContextActionService.md)/[DataModel](DataModel.md) input waterfall and [MouseCommand](MouseCommand.md) processing.

## Gotchas

- The COPY CTOR drops Delta, inputText, scanCode, modCodes and sourceInputType — cloned events lose new-keyboard fidelity silently (BillboardGui's transformedEvent path hits this).
- setPosition on a remapped clone keeps sourceInputType ≠ inputType → isPublicEvent false — intentional privacy but surprising when debugging lost events.
- KeyCode prop raises but scanCode/inputText setters deliberately don't (commented-out raises).
