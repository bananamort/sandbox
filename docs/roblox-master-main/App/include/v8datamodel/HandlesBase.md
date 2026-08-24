# App/include/v8datamodel/HandlesBase.h

## Purpose

Shared base for part handles ([Handles](Handles.md), [ArcHandles](ArcHandles.md)): a PartAdornment that renders 2D+3D handle graphics, hit-tests the mouse against handle faces (`findTargetHandle` and per-mode geometry helpers), captures mouse-down state, and tracks hover/masked normals.

## Declared API

`class HandlesBase : public DescribedNonCreatable<HandlesBase, PartAdornment, sHandlesBase>`

- `HandlesBase(const char* name);`
- Default: `virtual RBX::HandleType getHandleType() const { return RBX::HANDLE_RESIZE; }`
- Instance: `onAncestorChanged(const AncestorChanged&) override;` commented-out onPropertyChanged — "must implement in derived".
- GuiBase: `bool canProcessMeAndDescendants() const override;`
- IAdornable: `render2d(Adorn*)`, `render3dAdorn(Adorn*)` overrides; protected `shouldRender2d() { return shouldRender3dAdorn(); }`.
- Hit-test helpers (protected): `bool findTargetHandle(const shared_ptr<InputObject>&, Vector3& hitPointWorld, NormalId& hitNormalId);` `bool getDistanceFromHandle(input, NormalId localNormalId, hitPointWorld, float& distance);` `bool getFacePosFromHandle(input, faceId, hitPointWorld, Vector2& relativePos, Vector2& absolutePos);` `bool getAngleRadiusFromHandle(input, faceId, hitPointWorld, float& angle, float& radius, float& absangle, float& absradius);`
- Capture struct: `struct MouseDownCaptureInfo { CoordinateFrame partLocation; Vector3 hitPointWorld; NormalId hitNormalId; ctor; };`
- State: `NormalId mouseOver; shared_ptr<MouseDownCaptureInfo> mouseDownCaptureInfo; bool serverGuiObject;` virtual `setServerGuiObject()`; virtual `int getHandlesNormalIdMask() const { return 0; }`.

## Gotchas

- Normal mask default 0 = no faces active until a subclass supplies its mask.
- Mouse-down capture stores part CFrame + world hit + normal — drag math replays against this snapshot.
- Subclasses must re-implement onPropertyChanged themselves (base deliberately omits it).

## UNKNOWN

- canProcessMeAndDescendants gating rules (.cpp — see [HandlesBase.md](../../v8datamodel/HandlesBase.md)).

## Cross-links

- Implementation: [App/v8datamodel/HandlesBase.md](../../v8datamodel/HandlesBase.md).
- Children: [Handles.md](Handles.md), [ArcHandles.md](ArcHandles.md); base adornment [Adornment.md](Adornment.md).
