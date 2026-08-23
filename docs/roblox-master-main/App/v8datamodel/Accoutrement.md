# App/v8datamodel/Accoutrement.cpp

## Purpose

Implements `Accoutrement` ("Accoutrement") and its creatable subclasses `Hat` ("Hat") and `Accessory` ("Accessory") — wearable items whose `Handle` part gets welded onto a character. Contains the server-side (backend) state machine that equips/unequips hats via touch, plus the new attachment-based accessory welding behind DFFlag `AccessoriesAndAttachments` (default false in this tree).

## API

Reflection:
- `prop_AttachmentPoint` — `"AttachmentPoint"` (category_Appearance, STANDARD), CoordinateFrame, `getAttachmentPoint`/`setAttachmentPoint`.
- UI helper props derived from AttachmentPoint: `prop_AttachmentPos` (`"AttachmentPos"`, Vector3 translation), `prop_AttachmentForward` (`"AttachmentForward"`, lookVector), `prop_AttachmentUp` (`"AttachmentUp"`, upVector), `prop_AttachmentRight` (`"AttachmentRight"`, rightVector) — each setter orthonormalizes the frame around the given vector.
- `prop_BackendAccoutrementState` — `"BackendAccoutrementState"` (category_Appearance, REPLICATE_ONLY) int mirror of internal state.

Constants: `sAccoutrement`, `sHat`, `sAccessory`; flag `DFFlag::AccessoriesAndAttachments`.

Key methods: `PartInstance* getHandle()` (child literally named "Handle"); `static Attachment* findFirstMatchingAttachment(Instance* model, const std::string& name)` — recursive name match over Attachments, skipping Accoutrement subtrees; `const CoordinateFrame getLocation()`; `dropAll(ModelInstance*)` / `static dropAllOthers(ModelInstance*, Accoutrement* exception)` — reparents all Accoutrements to Workspace; `onCameraNear(float)`, `render3dSelect(...)` forwarding to children.

Backend state machine — enum `AccoutrementState { NOTHING, HAS_HANDLE, IN_WORKSPACE, IN_CHARACTER, EQUIPPED }`: `computeDesiredState()`, `setDesiredState(desired, provider)` (recursive single-step transitions), transition hooks `upTo_HasHandle/downFrom_HasHandle/upTo_InWorkspace/.../upTo_Equipped/downFrom_Equipped`, `connectTouchEvent`, `connectAttachmentAdjustedEvent`, `updateWeld`, event handlers `onEvent_HandleTouched`, `onEvent_AddedBackend/RemovedBackend`, `onChildAdded/onChildRemoved`, `onAncestorChanged`, `onEvent_AttachmentAdjusted(descriptor)` (reacts to `Attachment::prop_Frame`).

## Usage

Pure server-side behavior: every entry asserts `Network::Players::backendProcessing`. Equipping happens when a dropped hat's Handle is touched by a character with a Humanoid+Torso and no existing Accoutrement child (`onEvent_HandleTouched` reparents it). `upTo_Equipped` unjoins from outsiders, sets handle CanCollide(false), and welds: attachment path welds Handle→matching character attachment via `buildWeld(handle, matchingAttachmentPart, C0, C1, "AccessoryWeld")`; legacy path welds Head→Handle with `humanoid->getTopOfHead()` / `attachmentPoint` as "HeadWeld". Unequip/drop re-enables CanCollide, flings the handle up/forward (`moveToPointNoJoin` + rotational velocity 1,1,1) and forces camera-near so it doesn't render transparent.

## Gotchas

- State climbs strictly one step at a time (`setDesiredState` recurses); touching the weld's removal mid-transition (`onEvent_RemovedBackend` on the weld) forces state down to NOTHING.
- The state property is REPLICATE_ONLY — clients see BackendAccoutrementState but can't set it meaningfully.
- With the legacy path (flag off), only `HeadWeld` to the head exists; AttachmentPoint changes directly update `weld->setC1`. With the flag on they update `weld->setC0` from the handle's Attachment.
- Comment in source: equip code is "nearly the same as Tool::upTo_Equipped. That's evil!" — duplicated logic lives in Tool.
- UNKNOWN: `buildWeld` implementation is not in this TU (JointInstance/helper).
