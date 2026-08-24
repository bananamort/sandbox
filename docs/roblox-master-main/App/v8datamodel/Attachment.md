# Attachment.cpp

## Purpose

Implements `Attachment` ("Attachment") — a named pivot point + orientation frame parented to a Part (or Workspace), stored as two orthonormal axis vectors and a position in part space. Provides CFrame/Position/Rotation/World* reflection, optional world-space locking, and studio adorn rendering. Entire TU is inside `#if 1 // disable until we are ready for new joint schema`.

## Key types and API

Descriptors:
- `Attachment::prop_Frame("CFrame", category_Data)` — CoordinateFrame, STANDARD (public static, consumed by Accoutrement etc.).
- `prop_Position("Position", category_Data, UI)` — pivot in part space; `prop_Rotation("Rotation", category_Data, UI)` — XYZ Euler degrees; setters raise cascading changed events.
- Derived read-only (NULL setter): `prop_WorldPosition`, `prop_WorldRotation` — category "Derived Data", UI. No Security:: arguments on any descriptor.
- Gated out: `Axis/SecondaryAxis/WorldAxis/WorldSecondaryAxis` props + `SetAxes/SetAxis` BoundFuncs behind `#ifdef ENABLE_AXES_API` (commented-off define); `Attachment::prop_Locked("Locked", category_Behavior, UI)` behind `#ifdef RBX_ATTACHMENT_LOCKING`.

Constants: `sAttachment = "Attachment"`; static adorn sizing floats (`toolAdornHandleRadius = 0.2f` etc.).

Behavior:
- State: `axisDirectionInPart`(1,0,0), `secondaryAxisDirectionInPart`(0,1,0), `pivotPositionInPart`(1,0,0), visible(false), locked(false). Orientation matrix = columns [axis, secondary, axis×secondary].
- `setPivotInPart/setEulerAnglesInPart/setFrameInPart` all funnel into raising prop_Position/Rotation/World*/Frame as appropriate.
- Secondary-axis setter orthonormalizes: near-zero input ignored; parallel-to-axis input gets a deterministic fallback plane (Y-projection, else X/Z split by `axis.x+0.1 vs axis.z` comparison).
- `getParentFrame()` — parent Part's CF, or identity when locked or parent isn't a Part.
- `setLocked(true)` bakes current WORLD pose into the part-space fields (attachment freezes in world); unlock re-bakes back into the (new) parent frame.
- Hierarchy rules: `verifySetParent` — only NULL/PartInstance/Workspace ("Attachments can only be parented to parts or the workspace"); `verifyAddChild` — always throws "Attachments can't have children."
- Rendering: `render3dAdorn` green sphere when visible; `render3dToolAdorn` orange/green paired-handle with yellow major / red minor axis cylinders, hover highlight, hidden alpha 0.1; `intersectAdornWithRay` sphere pick.

## Usage / reflection touchpoints

Weld anchor for accessories ([Accoutrement](Accoutrement.md)) and constraint endpoints elsewhere; CFrame property cross-referenced by name in [Surface](Surface.md)-style descriptors.

## Gotchas

- setLocked only transitions false→true / true→false; redundant sets are silent no-ops that DON'T re-bake values.
- Setting Rotation raises Frame-changed but setting Position via setFrameInPart raises it once at end — event storms differ by entry path (scripts connecting to Changed see multiple fires per logical edit).
- WorldPosition/WorldRotation have no setters — writing them from scripts fails descriptor lookup.
- The whole file is wrapped in `#if 1` with intent to disable — flipping that define removes Attachment entirely from the build.
