# Accoutrement.cpp

## Purpose

Implements `Accoutrement` ("Accoutrement") and its creatable subclasses `Hat` ("Hat") and `Accessory` ("Accessory") — wearable items whose child part named "Handle" gets welded onto a character. Hosts a server-only five-state backend state machine (NOTHING → HAS_HANDLE → IN_WORKSPACE → IN_CHARACTER → EQUIPPED) that equips hats on touch and drops them on unequip, with a legacy HeadWeld path and a newer attachment-matched AccessoryWeld path behind DFFlag `AccessoriesAndAttachments` (default false).

## Key types and API

Descriptors:
- `prop_AttachmentPoint("AttachmentPoint", category_Appearance)` — CoordinateFrame, STANDARD, get/set.
- UI helpers derived from AttachmentPoint (all category_Appearance, UI): `prop_AttachmentPos("AttachmentPos")` translation, `prop_AttachmentForward("AttachmentForward")` lookVector, `prop_AttachmentUp("AttachmentUp")` upVector, `prop_AttachmentRight("AttachmentRight")` rightVector — each setter orthonormalizes the rotation around the given vector via `Math::safeDirection`.
- `prop_BackendAccoutrementState("BackendAccoutrementState", category_Appearance)` — int mirror of internal state, REPLICATE_ONLY (clients observe, cannot drive). No Security:: arguments on any descriptor in this TU.

Constants: `sAccoutrement`, `sHat`, `sAccessory`; flag `DYNAMIC_FASTFLAGVARIABLE(AccessoriesAndAttachments, false)`.

State machine:
- enum `AccoutrementState { NOTHING, HAS_HANDLE, IN_WORKSPACE, IN_CHARACTER, EQUIPPED }`; touch watch table: IN_CHARACTER/IN_WORKSPACE/HAS_HANDLE watch touches, NOTHING doesn't.
- `computeDesiredState()` / `computeDesiredState(Instance* testParent)` — no Handle → NOTHING; not in Workspace → HAS_HANDLE; parent not character → IN_WORKSPACE; character with Torso (`getTorsoSlow`) → EQUIPPED else NOTHING.
- `setDesiredState(desired, provider)` — climbs one step per recursion via `upTo_*`/`downFrom_*` hooks.
- Hooks: `upTo_HasHandle` connects Handle `touchedSignal`; `upTo_InCharacter` hooks parent childAdded/RemovedSignal; `upTo_Equipped` disconnects touch, `DragUtilities::unJoinFromOutsiders`, then welds (flag on: handle's first Attachment matched by name against character via recursive static `findFirstMatchingAttachment(Instance*, const std::string&)` → `buildWeld(handle, matchingAttachmentPart, C0, C1, "AccessoryWeld")`, fallback legacy HeadWeld; flag off: always `buildWeld(head, handle, humanoid->getTopOfHead(), attachmentPoint, "HeadWeld")`); sets handle CanCollide(false).
- `downFrom_Equipped` removes weld, restores CanCollide(true), flings handle up/forward (+4y, +8·lookVector) with rotational velocity (1,1,1), calls `onCameraNear(999.0f)` anti-transparency hack, reconnects touch.
- Event handlers: `onEvent_HandleTouched` (IN_WORKSPACE + touching character with Torso + character has NO existing Accoutrement → reparent onto it), `onEvent_AddedBackend/RemovedBackend` (weld removal forces state down to NOTHING), `onChildAdded/onChildRemoved/onAncestorChanged` → `rebuildBackendState()`, `onEvent_AttachmentAdjusted` reacts to `Attachment::prop_Frame` → `updateWeld()`.
- Misc: `getHandle()` finds literal "Handle" child PartInstance; `dropAll(ModelInstance*)` / static `dropAllOthers(character, exception)` reparent all Accoutrements to Workspace; `UnequipThis` steps EQUIPPED→IN_WORKSPACE; `updateWeld()` re-C0/C1s on attachment moves; `Hat`/`Accessory` ctors are name-only shells.

## Usage / reflection touchpoints

Pure backend behavior — every entry asserts `Network::Players::backendProcessing`. Equipping is touch-driven server logic; clients only see BackendAccoutrementState. Pairs with [Tool](Tool.md) (same state-machine shape) and [Attachment](Attachment.md); weld creation lives with JointInstance machinery ([Base](../../Base/) physics).

## Gotchas

- State changes strictly one step per recursion — a jump from NOTHING to EQUIPPED runs all four up-hooks in order.
- With the flag OFF, AttachmentPoint edits rewrite `weld->setC1` directly; with it ON they go through `updateWeld()` → `setC0` from the handle attachment. Two different semantics behind one property.
- Equip requires the character to have NO other Accoutrement child at touch time (checked in `onEvent_HandleTouched`); multi-hat characters are impossible through this path.
- Source comment admits `upTo_Equipped` is "nearly the same as Tool::upTo_Equipped. That's evil!" — duplicated equip logic in Tool.md.
- UNKNOWN: `buildWeld` implementation is not in this TU (lives with JointInstance/helpers).
