# ContextActionTouch.lua

Source: `roblox-sandbox/content/scripts/CoreScripts/ContextActionTouch.lua` (268 lines)

## Purpose

Touch-button UI for `ContextActionService` bindings (Ben Tkacheff, 2014): renders up to 7 on-screen buttons for actions bound with createTouchButton=true and forwards touch Begin/Change/End into the bound Lua functions via CallFunction.

## API / Behavior

- State: functionTable (actionName→info+button), buttonVector (7-slot array with "empty" markers), fixed 7-entry position table (right-side cluster), down/up images asset 97166756/97166444.
- Globals: `createContextActionGui` (ScreenGui + right-side 30%×50% frame; visibility tracks ModalEnabled via UIS.Changed), `setButtonSizeAndPosition` (55px small screens / 85px; note: only sets SIZE — xOffset/yOffset locals unused), `contextButtonDown/Moved/Up` (image swap + CAS CallFunction with matching UserInputState), `isSmallScreenDevice` (screen y ≤ 320), `createNewButton` (ImageButton w/ per-button single-touch tracking: currentButtonTouch claim + oldTouches ended-set to swallow late events; ActionIcon ImageLabel from infoTable.image; ActionTitle TextLabel from infoTable.title), `createButton` (first-empty-slot placement; >maxButtons silently dropped; lazy-parents gui under PlayerGui), `removeAction` (slot → "empty", Destroy), `addAction` (replace-if-exists).
- Connections to CAS signals: BoundActionChanged (live image/title/position updates; description TODO), BoundActionAdded, BoundActionRemoved, GetActionButtonEvent (FireActionButtonFoundSignal reply).
- Bootstrap: replays `GetAllBoundActionInfo()` for anything bound before this script ran.

## Usage

Loaded by StarterScript ONLY when TouchEnabled. Games interact purely through ContextActionService:BindAction.

## Gotchas
- InputEnded connection that clears oldTouches is created PER BUTTON — N buttons ⇒ N duplicate global clears (benign but sloppy).
- createButton parents gui to localPlayer.PlayerGui, not CoreGui — game scripts can see/delete it.
- setButtonSizeAndPosition computes offsets it never applies (dead code); buttons keep 90/70px size from creation.
- 8th simultaneous action silently never gets a button (todo comment admits no user feedback).
