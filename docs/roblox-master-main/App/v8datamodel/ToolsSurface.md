# ToolsSurface.cpp

## Purpose

Implements the legacy surface-paint Studio tool family: `SurfaceTool` base (hover resolves part+face, click applies doAction + undo waypoint) with subclasses FlatTool/GlueTool/WeldTool/StudsTool/InletTool/UniversalTool/HingeTool/RightMotorTool/LeftMotorTool/OscillateMotorTool/SmoothNoOutlinesTool — each rewriting one face's SurfaceType/Input/Params and rejoining implicit joints — plus `DecalTool`, a drag-to-place decal applicator with 3D-view and tree insert modes.

## Key types and API

Extends MouseCommand via SurfaceTool (hover: getSurface → surface + partInstance + surfaceId; render3dAdorn highlights the face via DrawAdorn::partSurface). Constants for all twelve tool names.

doAction patterns:
- Paint tools (Flat/Glue/Weld/Studs/Inlet/Universal/SmoothNoOutlines): destroyImplicitJoints → flat() [except Smooth sets type directly] → setSurfaceType(…) → join(). Hinge: ROTATE + NO_INPUT + params 0 (NO flat first). Motors (Right/Left/Oscillate): ROTATE_V + CONSTANT_INPUT or SIN_INPUT + paramA −0.1 / paramB 0.1.
- HingeTool & RightMotorTool are STICKY verbs: static isStickyVerb=true gates isSticky() which re-creates a fresh tool command after each use (Left/Oscillate lack the override despite identical behavior).

DecalTool(workspace, decal, insertMode):
- Captures whether decal's parent was already a Part.
- Hover in INSERT_TO_3D_VIEW with non-part parent: re-parents decal onto hovered part live + sets face; no part ⇒ unparent. Otherwise only adjusts face when decal already descends from hovered part.
- Delete/Escape cancels: releaseCapture + unparent decal.
- MouseUp: non-3D modes finish (waypoint); 3D mode transitions to INSERT_TO_TREE state once parented to a real part (keeps capture).

## Usage / reflection touchpoints

Studio-only plumbing. Pairs with Surface.md (the descriptor machinery these mutate), MouseCommand.md, Decal docs in this folder.

## Gotchas

- Motor tools write IDENTICAL params for left vs right — direction differentiation lives in legacy joint semantics elsewhere.
- Sticky-verb asymmetry (Hinge/RightMotor sticky, Left/Oscillate not) looks like an oversight preserved by inertia.
- Every doAction destroys ALL implicit joints on the part then rejoins — painting one face rewrites the part's whole auto-joint set.
