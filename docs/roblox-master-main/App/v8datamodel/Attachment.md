# App/v8datamodel/Attachment.cpp

## Purpose

Implements `Attachment` ("Attachment") — a point+orientation frame parented inside a Part (or Workspace) used as the anchor for welds, accessories, and (future) constraints. Stores an axis/secondary-axis pair plus pivot position in part space; the Lua-visible `CFrame` property is composed from them. Whole file is wrapped in `#if 1 // disable until we are ready for new joint schema`.

## API

Reflection:
- `Attachment::prop_Frame` — `"CFrame"` (category_Data, STANDARD), CoordinateFrame, `getFrameInPart`/`setFrameInPart`.
- `prop_Position` — `"Position"` (category_Data, UI), Vector3 pivot in part space (`getPivotInPart`/`setPivotInPart`); setter raises Position, WorldPosition, and CFrame.
- `prop_Rotation` — `"Rotation"` (category_Data, UI), Vector3 XYZ Euler degrees (`getEulerAnglesInPart`/`setEulerAnglesInPart`).
- Derived read-only (category "Derived Data", UI): `prop_WorldPosition` ("WorldPosition"), `prop_WorldRotation` ("WorldRotation").
- Compiled out unless ENABLE_AXES_API: Axis/SecondaryAxis/WorldAxis/WorldSecondaryAxis props + `"SetAxes"(axis0,axis1)` / `"SetAxis"(axis)` funcs.
- Compiled out unless RBX_ATTACHMENT_LOCKING: `Attachment::prop_Locked` — `"Locked"` (category_Behavior, UI).

State: defaults axis=(1,0,0), secondary=(0,1,0), pivot=(1,0,0), visible=false, locked=false. Static adorn sizing constants (`adornRadius=0.2`, `toolAdornHandleRadius=0.2`, etc.).

Key methods: orientation is orthonormalized from the two axes (`getOrientationInPart`; third column = cross product; world variants transform through `getParentFrame()`); secondary-axis projection logic falls back to projecting unitY/unitZ/unitX when input is parallel to the primary axis; `setLocked(bool)` re-bases all stored vectors between part space and identity/world frame on toggle (locking freezes the attachment in world space); rendering via `render3dAdorn` (green sphere when visible) and editor `render3dToolAdorn` (orange/green sphere + yellow/red axis cylinders, SelectState flags Normal/Hovered/Paired/Hidden); `intersectAdornWithRay` sphere pick.

Hierarchy validation: `verifySetParent` — "Attachments can only be parented to parts or the workspace"; `verifyAddChild` — "Attachments can't have children." (constraint check commented out).

## Usage

The universal joint anchor: Accoutrement accessory welding reads `handle->findFirstChildOfType<Attachment>()` and matches by name against character attachments; `Attachment::prop_Frame` changes drive `Accoutrement::updateWeld`. getParentFrame() returns identity when locked or unparented.

## Gotchas

- Setting CFrame/Position/Rotation raises multiple dependent property-changed signals — listeners must tolerate cascades.
- Near-zero vectors are silently ignored by both setters (< 0.0001 primary, < 0.00001 secondary).
- World* properties are derived only; writing them does nothing.
- Axes API and Locked are disabled at compile time in this tree.
