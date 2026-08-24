# App/include/v8datamodel/Accoutrement.h

## Purpose

Base class for wearable/attachable character items — the `Accoutrement` Instance ("Accoutrement") plus concrete `Hat` and `Accessory` creatables. An Accoutrement carries a handle Part, replicates an equip state machine between server ("backend") and client ("frontend"), welds itself into a character on pickup/equip, and exposes its attachment frame for both welding and camera framing.

## Declared API

`class Accoutrement : public DescribedCreatable<Accoutrement, Instance, sAccoutrement>, public IEquipable, public IAdornable, public CameraSubject`

- Class descriptors: `sAccoutrement`, `sHat`, `sAccessory` (extern names).
- State enum: `AccoutrementState { NOTHING, HAS_HANDLE, IN_WORKSPACE, IN_CHARACTER, EQUIPPED }`.
- Replicated state: `int getBackendAccoutrementState() const`; `void setBackendAccoutrementState(int value)` (replication signal); protected setter `setBackendAccoutrementStateNoReplicate(int)`. Comment: backend writes, frontend reads.
- Attachment frame: `const CoordinateFrame& getAttachmentPoint() const` / `void setAttachmentPoint(const CoordinateFrame&)`; UI decomposition props `getAttachmentPos/Forward/Up/Right()` and matching setters (`Vector3`).
- Handle access: `PartInstance* getHandle()`; `const PartInstance* getHandleConst() const`.
- `Attachment* findFirstMatchingAttachment(Instance* model, const std::string& originalAttachment)`.
- Statics: `static void dropAll(ModelInstance* character)`; `static void dropAllOthers(ModelInstance* character, Accoutrement* exception)`.
- Backend machinery (protected): `computeDesiredState()` / `computeDesiredState(Instance* testParent)`, `setDesiredState(AccoutrementState, const ServiceProvider*)`, `rebuildBackendState()`, `connectTouchEvent()`, `connectAttachmentAdjustedEvent()`, ladder climb/drop helpers `upTo_Equipped/InCharacter/InWorkspace/HasHandle()` and `downFrom_*`, `updateWeld()`, `static characterCanPickUpAccoutrement(Instance* touchingCharacter)`, `static UnequipThis(shared_ptr<Instance>)`.
- Signal handlers: `onEvent_AddedBackend/RemovedBackend(shared_ptr<Instance>)`, `onEvent_HandleTouched(shared_ptr<Instance>)`, `onEvent_AttachmentAdjusted(const Reflection::PropertyDescriptor*)`; scoped connections `handleTouched`, `characterChildAdded`, `characterChildRemoved`, `attachmentAdjusted`.
- Overrides: `onChildAdded/onChildRemoved`, `onAncestorChanged`, `askSetParent`/`askAddChild` (both return true), `getLocation()` (IHasLocation), CameraSubject `getRenderLocation()` (= getLocation), `getRenderSize()` (handle's `getPartSizeUi()`, else zero vector), `onCameraNear(float)`, `drawSelected()` (true when state >= EQUIPPED), IAdornable `render3dSelect(Adorn*, SelectState)`.

`class Hat : public DescribedCreatable<Hat, Accoutrement, sHat>` — constructor only.
`class Accessory : public DescribedCreatable<Accessory, Accoutrement, sAccessory>` — constructor only.

## Gotchas

- The equip state machine lives entirely in the header-declared protected methods; behavior (weld creation, touch pickup) is implemented in the .cpp — see implementation doc.
- `getRenderSize()` returns zero when there is no handle yet; camera framing silently degenerates.
- `attachmentPoint` is the replicated source of truth; the four Pos/Forward/Up/Right props are "Auxillary UI props" derived views.
- IEquipable inheritance is explicitly marked TODO — commonality with Tool was still mid-migration in this drop.

## UNKNOWN

- Exact semantics of each state transition (implemented in .cpp; see [Accoutrement.md](../../v8datamodel/Accoutrement.md)).

## Cross-links

- Implementation: [App/v8datamodel/Accoutrement.md](../../v8datamodel/Accoutrement.md).
- Siblings: [Tool.md](Tool.md) (the other IEquipable), [Attachment.md](Attachment.md), [ModelInstance.md](ModelInstance.md).
