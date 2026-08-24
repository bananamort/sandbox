# Utility.lua

Source: `roblox-sandbox/content/scripts/Modules/Settings/Utility.lua` (2023 lines)

## Purpose

The settings-UI toolkit every Settings page requires: styled buttons, dropdown/selector/slider value-changer classes with full gamepad+touch+keyboard input handling, row layout helpers, modal alerts, easing/tweening, and small-screen/ten-foot detection.

## API (moduleApiTable)

- `Create(instanceType)` — property-table builder (numeric keys parent children).
- Easing: `GetEaseLinear/EaseOutQuad/EaseInOutQuad`; `TweenProperty(...)` = `PropertyTweener` RenderStepped-driven manual tween with Finish/Cancel/GetPercentComplete.
- `CreateSignal()` — BindableEvent signal w/ cached args (same pattern as PlayerDropDown's).
- `MakeStyledButton(name,text,size,clickFunc,pageRef,hubRef)` → button, textLabel, setRowRef — MenuButton 9-slice skin, self-referential NextSelection L/R traps, gamepad-aware click arg (`lastInputTypee == ...` **TYPO: undefined global `lastInputTypee`** makes first comparison false; Gamepad2/3/4 checks still work), hover/select highlight + hub ScrollToFrame via optional rowRef.
- `CreateNewSlider(numOfSteps,startStep,minStep)` → {SliderFrame, Steps[], ValueChanged, SetValue/GetValue/SetInteractable/SetZIndex/SetMinStep} — step blocks w/ 9-slice end caps, drag-to-set via AbsolutePosition hit-test on InputChanged, d-pad/A/D keys, thumbstick repeat stepping at CONTROLLER_SCROLL_DELTA(0.2s) cadence bound to RenderStep while selected.
- `CreateNewSelector(table,startPos)` → {SelectorFrame, Selections, IndexChanged, ...} — sliding label carousel w/ TextTransparency PropertyTweener cross-fade, click-anywhere auto-advance button overlay per selection, same input trio.
- `CreateNewDropDown(table,startPos)` → {DropDownFrame, IndexChanged, SetSelectionIndex/ByValue, ResetSelectionIndex, GetSelectedIndex, SetInteractable, UpdateDropDownList} — fullscreen modal list under CoreGui.RobloxGui, B/Escape/outside-click close, freeze binds, selection tuple registration, Enter-key processing. Note: `settingsHub.PoppedMenu:connect` — called with hub nil from moduleApiTable path would ERROR (only AddNewRow passes real hub).
- `AddNewRow(page,label,type,values,default,extraSpacing)` → RowFrame, RowLabel, ValueChanger — ROW_HEIGHT 50 (90 ten-foot); positions value changer right-aligned; 'TextBox' type builds inline 100px box (placeholder-clear on focus); MouseEnter→SelectedCoreObject handoff guarded by visible DropDownFullscreenFrame; tracks per-page Y in nextPosTable.
- `AddNewRowObject(page,label,object,extraSpacing)` — wrap arbitrary control as a row.
- `ShowAlert(message,okText,hub,okPressedFunc,hasBackground)` — modal AlertViewBacking (MenuButton slice or bare text), OK button self-trapping selections, Esc/B/A bind destroy+callback+ShowBar.
- `IsSmallTouchScreen()` (TouchEnabled && viewport.Y≤500), `UsesSelectedObject()`, GetEase* etc.

## Usage

Required by SettingsPageFactory, every Page, SettingsHub, GamepadMenu, HealthScript error path, NotificationScript2 alert.

## Gotchas
- MakeButton's `lastInputTypee` typo silently breaks the "isGamepad" flag for clicks (always false unless nil-input branch).
- CreateDropDown double-declares indexChangedEvent (second shadows first — harmless but sloppy).
- GuiService handler `if not prop == "SelectedCoreObject"` in DropDownFrameClicked is precedence bug (`not prop` then compare) — always runs body.
- ShowAlert references global `Game.GuiService`.
