# Tool.cpp

## Purpose

Implements `Tool` ("Tool"), the classic held-item Instance: a five-state backend state machine (NOTHING→HAS_HANDLE→IN_WORKSPACE→IN_CHARACTER→HAS_TORSO→EQUIPPED) managing handle-touch pickup, RightGrip weld creation (R6 arm vs R15 RightHand), character/torso event wiring, and drop physics; frontend equip installs ToolMouseCommand and fires Equipped with its Mouse; Activate/Deactivate are REPLICATED remote events; Grip property family defines the hand offset with a zero-column "MEGA HACK" repair.

## Key types and API

Descriptors:
- `prop_Grip("Grip")` — CoordinateFrame, category_Appearance, cap STANDARD; setter runs cleanUpZeroColumn (replaces any near-zero rotation column with a fixed basis — commented MEGA HACK) + orthonormalizeIfNecessary; live-updates weld C1 server-side.
- UI grip decomposition: "GripPos"/"GripForward"/"GripUp"/"GripRight" (cap UI) — setters rebuild orthonormal frames from one vector each.
- `prop_ToolTip("ToolTip")` — string; truncated to ContentFilter::MAX_CONTENT_FILTER_SIZE and PROFANITY-FILTERED unless RobloxLocked.
- Behavior: "ManualActivationOnly", "CanBeDropped", "RequiresHandle" (bools); `Tool::prop_Enabled("Enabled")` BoundProp category "State".
- Events: "Equipped(mouse)" via **special_equipped_signal** subclass whose operator() THROWS ("Don't use Event.fireEvent for equipped signal!") — state tracked via equipped()/unequipped() methods so currentlyEquipped/lastArg stay coherent; "Unequipped()"; RemoteEvents SCRIPTING CLIENT_SERVER **Security::None**: "Activated()", "Deactivated()"; `func_Activate("Activate()")` **Security::None**.

Backend state machine:
- `computeDesiredState`: no handle + RequiresHandle ⇒ NOTHING; not in workspace ⇒ NOTHING; parent not character ⇒ IN_WORKSPACE; no torso ⇒ IN_CHARACTER; R15 missing RightHand / R6 missing right arm+shoulder ⇒ HAS_TORSO; else EQUIPPED.
- Transitions wire/unwire: handle touchedSignal (HAS_HANDLE), character childAdded/Removed (IN_CHARACTER), torso childAdded/Removed (HAS_TORSO); EQUIPPED builds weld — ownWeld path builds "RightGrip" Weld(arm→handle, humanoid rightArmGrip × grip) + handle canCollide false; else SERVER searches existing RightGrip or waits on armChildAdded for a matching weld (name + part1==handle).
- Shortcuts fromNothingToEquipped/fromEquippedToNothing skip touch-event churn; downFrom_Equipped removes weld, restores canCollide, THROWS the handle 4 up + 8 forward with rotational velocity (1,1,1) when a character was involved.
- Pickup: `onEvent_HandleTouched` (backend only, IN_WORKSPACE): touching character fully-armed ⇒ if current tool canUnequip and player can pick up → moveAllToolsToBackpack, setParent(character), then TimerService::delay 0.2 s `moveOtherToolsToBackpack` (acknowledged hack for simultaneous backpack-equip races) + disableHopperBin on the backpack.
- onAncestorChanged resets ownWeld, tears down to NOTHING on old provider, recomputes on new: solo/backend ownership rules decide ownWeld (frontend owns weld only when tool came FROM the local player's backpack; NPC tools are backend-owned).
- Static helpers: dropAll(player) (undroppable tools → backpack, others → workspace), moveAllToolsToBackpack, characterCanUnequipTool.

Frontend:
- `onEquipping`: local player's character parent only → install ToolMouseCommand into Workspace, return its Mouse (else NULL → createMouse fallback in setBackendToolState). onUnequipped restores default mouse command.
- `luaActivate`: warns and refuses when not EQUIPPED; gamepad/touch paths synthesize mouse position (average of touches!) before activate. `activate(manuallyActivated)` respects ManualActivationOnly for non-manual calls; both fireAndReplicate Activated/Deactivated.
- Backpack click flow: onLocalClicked/onLocalOtherClicked enforce single-equipped invariant (RBXASSERT <2).

## Usage / reflection touchpoints

The full classic tool API is script-facing. Pairs with Mouse.md/MouseCommand.md/ToolMouseCommand.md, Humanoid grip machinery, Backpack.md/HopperBin.md in this folder, [Network](../../Network/) replication ordering notes.

## Gotchas

- Equipped signal throws if fired generically — engine MUST use equipped()/unequipped(); plugins replicating this pattern need the same discipline.
- Handle canCollide forced false while welded, true on unequip — scripts toggling it fight the engine.
- The 0.2 s multi-tool sweep uses an UNCAPTURED `this` raw pointer in boost::bind over TimerService delay — tool destruction within 0.2 s of pickup is use-after-free territory (mitigated only by weak Player capture).
- Grip zero-column hack silently replaces degenerate rotations with a fixed orientation rather than erroring.
- Profanity filter bypass for RobloxLocked tools — core tools may carry any tooltip text.
- UNKNOWN: getRightArmGrip exact frame math header-side; HopperBin interplay documented separately.
