# BackpackScript.lua

Source: `roblox-sandbox/content/scripts/Modules/BackpackScript.lua` (1543 lines; "Backpack Version 4.21" by OnlyTwentyCharacters)

## Purpose

The full hotbar + inventory backpack module: 10-slot (3 on phones) centered hotbar with number keys, expandable scrolling inventory grid with search, drag-and-drop slot management, equip highlighting (incl. HopperBin support), gamepad LB/RB cycling + radial select + swap mode.

## API (exposed table `BackpackScript`)

- `OpenClose()` — toggle inventory (assigned later), `IsOpen`, `StateChanged` (BindableEvent fires IsNowOpen), `TopbarEnabledChanged(enabled)` method.
- Internals: Slots[] of slot objects {Tool, Index, Frame, Fill/Clear/Swap/Delete/SlideBack/Reposition/Readjust/UpdateEquipView/Select/MoveToInventory/SetClickability/TurnNumber/CheckTerms}; SlotsByTool map; HotkeyFns keyed by KeyCode.Value; FullHotbarSlots counter; LowestEmptySlot; ActiveHopper; ResultsIndices for search.
- Slot visuals: 60px (100 ten-foot) buttons, equip = 4 blue edge frames (SLOT_EQUIP_THICKNESS relative); tooltip on hover w/ TextBounds sizing; draggable via legacy GuiObject.Draggable with DragBegin/DragStopped reparenting trick to escape ScrollingFrame clipping.
- Equip path: HopperBin via ToggleSelect/Active tracking; Tool equip done by **parenting to Character directly** (`Humanoid:EquipTool` commented out — "TODO: Switch back ... after EquipTool is fixed!").
- StarterTool special-case: first character tool matching StarterGear name gets bubble-shifted into slot 1 chain.
- Drop semantics: dropping outside both frames moves hotbar tool to inventory (drop-to-world block commented out).
- Gamepad: changeToolFunc LB/RB cycle w/ 60ms both-bumpers unequip combo (delay-based debounce), selectToolExperiment thumbstick→8-way angle→slot index, swap mode = selected slot gets BorderSizePixel 3 marker, second click swaps/deletes empties, X removes from hotbar, hints frame auto-spacing by TextBounds.
- Search: lowercase whole-word gsub hit counting over Name+ToolTip, results repositioned to top rows sorted by hits desc, x-button clear, Escape reset; xButton.Modal frees mouse in first person.
- CoreGui integration: OnCoreGuiChanged toggles WholeThingEnabled/MainFrame, AddKey/RemoveKey hotkey eating ("0".."9","`"), health offset −30 when legacy health bar shown, gamepad binds per state; FFlag UseInGameTopBar read via settings() pcall decides arrow-frame existence (topbar era hides arrow; backquote still toggles).

## Usage

spawn-required by StarterScript and Topbar/GamepadMenu/SettingsHub (`require(RobloxGui.Modules.BackpackScript)`).

## Gotchas
- `changeSlot`, `getGamepadSwapSlot`, `enableGamepadInventoryControl`, `unbindAllGamepadEquipActions` are GLOBAL functions (missing local).
- MakeSlot's MouseButton1Click closure references `changeSlot` before its global assignment — works only due to global lookup at call time.
- arrowFrame triple-var init `local arrowFrame, arrowIcon = nil, nil, nil` — extra value silently dropped.
- Draggable-based dragging is deprecated tech; double-click-to-hotbar uses lastUpTime per-slot state.
