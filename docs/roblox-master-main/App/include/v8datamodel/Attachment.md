# App/include/v8datamodel/Attachment.h

## Purpose

`Attachment` Instance ("Attachment") — a named point+orientation frame parented inside a part (the "new joint schema" anchor object). Stores pivot/axis/secondary-axis vectors in part space, exposes world-space conversions for scripting/UI, and renders editor adornments. Whole file is wrapped in `#if 1 // disable until we are ready for new joint schema`.

## Declared API

`class Attachment : public DescribedCreatable<Attachment, Instance, sAttachment>, public IAdornable`

- Static adorn metrics: `static float adornRadius;` and AttachmentTool-only `toolAdornHandleRadius`, `toolAdornMajorAxisSize`, `toolAdornMajorAxisRadius`, `toolAdornMinorAxisSize`, `toolAdornMinorAxisRadius`.
- Reflection: `static Reflection::PropDescriptor<Attachment, CoordinateFrame> prop_Frame;`
- Visibility/lock (scripting + streaming): `bool getVisible() const / setVisible(bool)`; `bool getLocked() const / setLocked(bool)`.
- Frame access (UI + replication): `CoordinateFrame getFrameInPart() const / setFrameInPart(const CoordinateFrame&)`; `CoordinateFrame getFrameInWorld() const`.
- Pivot (UI + scripting): `Vector3 getPivotInPart()/setPivotInPart(const Vector3&)`; `getPivotInWorld()`.
- Euler angles (UI + scripting): `getEulerAnglesInPart()/setEulerAnglesInPart(const Vector3&)`; `getEulerAnglesInWorld()`.
- Axes (read): `Vector3 getAxisInPart()/getAxisInWorld()`; `getSecondaryAxisInPart()/getSecondaryAxisInWorld()`; `CoordinateFrame getParentFrame() const`.
- Scripting-only: `void setAxes(Vector3 axis, Vector3 secondaryAxis);`
- Hidden API (side effects, AttachmentTool only): `void setAxisInPart(Vector3 axis);`
- Ray hit: `virtual float intersectAdornWithRay(const RbxRay& r);`
- Rendering: `enum SelectState { SelectState_None=0, SelectState_Normal=1, SelectState_Hovered=2, SelectState_Paired=4, SelectState_Hidden=8 };` `void render3dToolAdorn(Adorn*, SelectState);` `void render3dAdorn(Adorn*) override;` `shouldRender3dAdorn()` override returns true.
- Tree guards: `verifySetParent(const Instance*) const override; verifyAddChild(const Instance*) const override;`
- Private internals: `setAxisInPartInternal(const Vector3&)` ("might change the secondary axis to keep it orthogonal"), `setSecondaryAxisInPartInternal(const Vector3&)` ("project the secondary axis onto the orthogonormal circle to the axis"), `setOrientationInPartInternal(const Matrix3&)`, `Matrix3 getOrientationInPart()/getOrientationInWorld() const`. State: `bool visible; bool locked; Vector3 pivotPositionInPart, axisDirectionInPart, secondaryAxisDirectionInPart;`
- Disabled feature: `#ifdef RBX_ATTACHMENT_LOCKING static const PropDescriptor<Attachment,bool> prop_Locked;` — commented "not streaming/replication safe".

## Gotchas

- Axis setters are order-dependent and may silently re-project the other axis — hence both hidden from the public API.
- The file's own top comment says it was gated pending the new joint schema; treat the enabled state as build-time choice.
- `prop_Locked` exists only under RBX_ATTACHMENT_LOCKING; `locked` member still exists unconditionally with plain getter/setter.

## UNKNOWN

- Which joint types consume Attachments in this drop (Weld-constraint plumbing lives elsewhere).

## Cross-links

- Implementation: [App/v8datamodel/Attachment.md](../../v8datamodel/Attachment.md).
- Consumers: [Accoutrement.md](Accoutrement.md) (`findFirstMatchingAttachment`), joints family [JointInstance.md](JointInstance.md); base adorn surface GfxBase/IAdornable.
