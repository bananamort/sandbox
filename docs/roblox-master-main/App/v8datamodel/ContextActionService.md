# ContextActionService.cpp

## Purpose

Implements `ContextActionService` ("ContextActionService") — the client-side action-binding service. Binds Lua callbacks to input types/keys (developer `BindAction` and core-script `BindCoreAction` namespaces), synthesizes `Activate` events via BindActivate, drives touch-button metadata (title/description/image/position), and exposes bound-action introspection to core scripts. Also defines the reflection enum `PlayerActions`.

## Key types and API

Descriptors (REFLECTION_BEGIN block):
- `GetCurrentLocalToolIcon() -> string` — Security::None; texture id of the currently-equipped local Tool ("todo: remove these" tool convenience shim).
- Events `LocalToolEquipped(toolEquipped)` / `LocalToolUnequipped(toolUnequipped)` — Security default (no tier arg); fired by watching the local player's character childAdded/childRemoved for Tool instances.
- `BindCoreAction(actionName, functionToBind, createTouchButton, inputTypes)` — Security::RobloxScript.
- `BindAction(actionName, functionToBind, createTouchButton, inputTypes)` — Security::None.
- `BindActionToInputTypes(...)` — deprecated alias of func_bind (`Attributes::deprecated(func_bind)`), Security::None.
- `BindActivate(userInputTypeForActivation, keyCodeForActivation=SDLK_UNKNOWN)` / `UnbindActivate(...)` — Security::None.
- Touch-button interface: `SetTitle(actionName,title)`, `SetDescription(actionName,description)`, `SetImage(actionName,image)`, `SetPosition(actionName,position UDim2)`, yield-func `GetButton(actionName)` — all Security::None.
- Unbinding: `UnbindCoreAction(actionName)` — Security::RobloxScript; `UnbindAction(actionName)` — Security::None; `UnbindAllActions()` — Security::None.
- Introspection: `GetBoundActionInfo(actionName) -> ValueTable`, `GetAllBoundActionInfo() -> ValueTable` — Security::None.
- Core-backend signals (RobloxScript): `BoundActionChanged(actionChanged, changeName, changeTable)`, `BoundActionAdded(actionAdded, createTouchButton, functionInfoTable)`, `BoundActionRemoved(actionRemoved, functionInfoTable)`, `GetActionButtonEvent(actionName)` (event), `FireActionButtonFoundSignal(actionName, actionButton)`, `CallFunction(actionName, state, inputObject)` — all Security::RobloxScript.

Enum: `PlayerActions` = CharacterForward/CharacterBackward/CharacterLeft/CharacterRight/CharacterJump (EnumDesc "PlayerActions").

State: two parallel stores — `functionMap`+`functionVector` (dev actions) and `coreFunctionMap`+`coreFunctionVector` (core); each entry a `BoundFunctionData{inputTypes tuple, luaFunction, title/image/description/position, hasTouchButton, lastInput weak}`; `activateGuid` RBX GUID marks BindActivate entries inside functionVector; `lastZPositionsForActivate` map for gamepad trigger analog thresholding; `yieldFunctionMap` backs the GetButton yield.

Behavior:
- `bindActionInternal`: throws "can only be called from a local script" unless `Network::Players::frontendProcessing`; rejects empty actionName and hotkeys not of KeyCode/string/UserInputType/PlayerActionType; per new hotkey calls `checkForInputOverride` on BOTH vectors (dev binds cancel overlapping core binds AND dev binds; core binds only cancel core), firing INPUT_STATE_CANCEL callbacks using the stored `lastInput` InputObject (or a synthesized TYPE_NONE one). Rebinding an existing name unbinds first. Callbacks run through `InvokeCallback` → ScriptContext::callInNewThread.
- `tryProcess(inputObject, vector, menuIsOpen)`: reverse iteration so last-bound wins; matches via `tupleContainsInputObject` (single-char strings cast to KeyCode; PlayerActionType matched against hardcoded WASD/arrows/space in `processInputForPlayerMovement` — those return sinkInput=false). If menuIsOpen, callback receives INPUT_STATE_CANCEL instead of real state. Entries named activateGuid instead synthesize a MouseBUTTON1 InputObject at current mouse position and inject it via DataModel::processInputObject, with R2/L2 analog-edge detection (z ≥0.5 crossing up, ≤0.2 crossing down).
- `unbindActionInternal` erases from map+vector and fires BoundActionRemoved with the snapshot table; `unbindAll` clears dev maps only (core untouched).
- `fireBoundActionChangedSignal` adds `"position"` to the change table (title/description/image setters reuse it).

## Usage / reflection touchpoints

Consumed by [UserInputService](UserInputService.md)-driven input dispatch (`processCoreBindings`/`processDevBindings` are called externally, not in this file); depends on [Tool](Tool.md)/[ModelInstance](ModelInstance.md) for tool-icon plumbing, Network::Players for local-player wiring on onServiceProvider, [GuiService](GuiService.md)/[GuiObject](GuiObject.md) headers for response types, ScriptContext for callback invocation.

## Gotchas

- `UnbindAllActions` does NOT clear coreFunctionMap/coreFunctionVector — only dev bindings.
- Hardcoded movement keys (WASD/arrows/space) in processInputForPlayerMovement; comment admits "allow users to set this" is TODO. PlayerActionType matches never sink input.
- Error message typo shipped: "CallFunction does have a function for %s" (meant "does NOT have").
- `checkForInputOverride` cancels at most ONE overridden binding per new hotkey (returns after first match).
- BindActivate entries live only in the DEV vector but bypass the luaFunction path; unbindActivate ignores the keyCode argument when matching (erases any entry whose first value is the UserInputType).
- `getButton` yield leaks if FireActionButtonFoundSignal never fires for that actionName; yieldFunctionMap entries are never erased after resume.
- `tupleContainsInputObject` sink semantics: KeyCode/UserInputType matches return with sinkInput=true (input swallowed); PlayerActionType matches set sinkInput=false (movement keys pass through); no match sets sinkInput=false.
