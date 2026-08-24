# App/include/v8datamodel/Mouse.h

## Purpose

Legacy `Mouse` Instance (non-creatable) — the script-facing 3D mouse object handed to Tools and MouseCommand-driven LocalScripts: caches the newest `InputObject`, exposes raycast results (Hit/Target/TargetSurface/UnitRay), screen coordinates, icon, and per-event signals.

## Declared API

`class Mouse : public DescribedNonCreatable<Mouse, Instance, sMouse>`

- Signals: moveSignal, idleSignal, button1DownSignal/button2DownSignal/button1UpSignal/button2UpSignal, wheelForwardSignal/wheelBackwardSignal (all void()), keyDownSignal/keyUpSignal `void(std::string)`.
- Event pump: `virtual void update(const shared_ptr<InputObject>& inputObject);` plus `cacheInputObject(const shared_ptr<InputObject>&);`
- Geometry getters (all virtual): `CoordinateFrame getHit() const` ("frame rotated so that the mouse shoots down -Z"), `getOrigin() const`, `PartInstance* getTarget() const`, `NormalId getTargetSurface() const`, `RBX::RbxRay getUnitRay() const`.
- Filter: `shared_ptr<Instance> getTargetFilter() const; Instance* getTargetFilterUnsafe() const` (weak lock; TODO notes RefPropDescriptor should take shared_ptr), `virtual void setTargetFilter(Instance*)`, protected setTargetFilterUnsafe ("solely called by child classes to fire changed event").
- Icon: `virtual TextureId getIcon() const / setIcon(const TextureId&)`.
- Coordinates: `virtual int getX()/getY()/getViewSizeX()/getViewSizeY() const`.
- Wiring: `void setCommand(MouseCommand* value); void setWorkspace(Workspace* workspace);`
- Protected: `checkActive() const` (virtual guard), `Workspace* getWorkspace() const`; state `workspace`, `command`, `icon`, `shared_ptr<InputObject> lastEvent`, `weak_ptr<Instance> targetFilter`.

## Gotchas

- All state flows through the cached lastEvent: before any event arrives the geometry getters degenerate.
- Non-virtual setCommand/setWorkspace vs virtual everything else — subclass Player Mouse extends behavior via overrides.
- checkActive is the lifetime gate (derived classes throw once detached).

## UNKNOWN

- Signal firing rules per input type live in .cpp (see [Mouse.md](../../v8datamodel/Mouse.md)).

## Cross-links

- Implementation: [App/v8datamodel/Mouse.md](../../v8datamodel/Mouse.md).
- Engine side: [MouseCommand.md](MouseCommand.md); kin [PlayerMouse.md]/[PluginMouse.md] (P–Z half), [Tool.md](Tool.md).
