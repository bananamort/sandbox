# App/include/v8datamodel/PVInstance.h

## Purpose

`PVInstance` ("Position/Velocity Instance") — the abstract base between `Instance` and all spatial objects (parts, models): declares location via virtual `IHasLocation`, forces subclasses to implement hit-testing, world extents, and primary-part resolution, and hosts the shared Lua move-to-point helpers. Non-creatable abstract root of the PV hierarchy.

## Declared API

`class RBXBaseClass PVInstance : public Reflection::Described<PVInstance, sPVInstance, Instance>, public virtual IHasLocation`

- Protected ctor `PVInstance(const char* name)`; public `virtual ~PVInstance()`.
- `/*override*/ int getPersistentDataCost() const { return Super::getPersistentDataCost() + 6; }` (inline).
- Serialization: `/*override*/ virtual void readProperty(const XmlElement* propertyElement, IReferenceBinder& binder)` (protected).
- Rendering/debug helper: `void renderCoordinateFrame(Adorn* adorn)` (protected).
- Pure virtuals (the PV contract): `virtual bool hitTestImpl(const RBX::RbxRay& worldRay, Vector3& worldHitPoint) = 0`, `virtual Extents computeExtentsWorld() const = 0`, `virtual PartInstance* getPrimaryPart() = 0`.
- Public wrapper: `bool hitTest(const RbxRay&, Vector3&) { return hitTestImpl(...); }` inline.
- Lua move helpers (comment: ".cpp file uses workspace.h"; apply to Parts AND Models; snap to "SnapLocation" — part center or model PrimaryPart center): `void moveToPointNoUnjoinNoJoin(Vector3 point)`, `void moveToPointAndJoin(Vector3 point)`, `void moveToPointNoJoin(Vector3 point)`.
- Hierarchy utilities: `PVInstance* getTopLevelPVParent()` (+const overload); inline `bool isTopLevelPVInstance()` — true if no typed PV parent or parent is the typed root.
- Legacy shim: `void setPVGridOffsetLegacy(const CoordinateFrame& _offset)` ("pre 11/20/2005 — now all parts store in global"); commented legacy CanSelect→Locked note.

## Gotchas

- Abstract by design: three pure virtuals mean only concrete geometry holders can instantiate.
- moveToPoint* semantics differ ONLY in join behavior — pick deliberately; joining mutates joint graph.
- Virtual inheritance of IHasLocation (diamonds possible in subclass lattices).

## UNKNOWN

- Whether any Lua name binding still exposes setPVGridOffsetLegacy.

## Cross-links

- Implementation: [App/v8datamodel/PVInstance.md](../../v8datamodel/PVInstance.md).
- Direct heir: [PartInstance.md](PartInstance.md); model aggregate: [ModelInstance.md](ModelInstance.md).
