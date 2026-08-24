# RootInstance.cpp

## Purpose

Implements `RootInstance`, the Studio-side root container owning the physics `World` and orchestrating ALL insert/drag/paste flows: computing insert points (IDE grid vs character-relative), routing inserted instances to their proper services (Sky→Lighting, Team→Teams, HopperBin/Tool→StarterPack or backpack), moving part arrays via MegaDragger, focusing the camera on newly inserted parts, and creating undo waypoints. This is where "insert from toolbox" actually lands things in the world.

## Key types and API

No reflection descriptors — pure engine orchestration class.

State: owns `world(new World())`, `insertPoint` (grid-snapped), `viewPort` starting 800×600 ("updated on every render").

Insert-point math:
- `setInsertPoint(topCenter)` grid-snaps; `computeIdeInsertPoint()` clamps Y ≥ 0, clips into `computeExtentsWorld()`, never below world-extent min-Y, re-snaps.
- `computeCharacterInsertPoint(size|extents)`: 7-stud offset from local character's extents bottom-center along planar camera look vector + half model size; asserts and falls back to IDE point without a character.

Movement core:
- `moveSafe(MegaDragger&, move, moveType)`: startDragging → safeMoveYDrop/safeMoveNoDrop → finishDragging (always joins on finish for PartArray overload).
- `moveToPoint(pv, point, joinType)` (the PVInstance.md entry point): requires pv contained in root AND primaryPart; MegaDragger MOVE_NO_DROP.
- `movePartsToCameraFocus`, `moveToRemoteInsertPoint(point)`, `moveToCharacterInsertPoint`, `moveToIdeInsertPoint(insertPoint)` — all compute bottomCenter-based offsets through DragUtilities::toGrid with MOVE_DROP.
- Tool-plugin guard: when active plugin `isTool()`, moves/camera-focus are suppressed (`movePartsToCameraFocus`, `insert3dView`).
- `gatherPartExtents(PartArray)`: union of per-part local extents expressed into first part's frame; silently returns zero extents when weak_ptr locks fail.

Insert pipeline:
- `publicInsertRaw(instances, parent, partArray, joinPartsInInstancesOnly, suppressMove)`: collect parts → setParent all → studio-mode+parts+!suppress ⇒ movePartsToCameraFocus → DragUtilities::join or joinWithInPartsOnly.
- `insertToTree` adds a zero-move safe pass + focusCameraOnParts (frustum check → lerpToExtents in studio else zoomExtents ZOOM_OUT_ONLY).
- `insert3dView`: routes by context — positionHint ⇒ insertRemoteCharacterView; local character exists ⇒ insertCharacterView (single HopperBin goes to player backpack); else insertIdeView (single HopperBin always to StarterPackService; single Tool only when promptMode PUT_TOOL_IN_STARTERPACK). Then optional camera focus, then manual-joint auto-create when AdvArrowToolBase::advManualJointMode via stack ManualJointHelper (find pairs + createJoints) — see ManualJointHelper.md.
- `doInsertInstances(...)` the master dispatcher: non-workspace parent inserts directly (Services rejected with MESSAGE_ERROR "Do Menu Insert->Service…"); workspace path peels Sky→Lighting::replaceSky, Team→Teams, HopperBin→insertHopperBin, SpawnLocation→insertSpawnLocation (creates missing Team named "<Color> Team" unless neutral/duplicate) while KEEPING it in remaining; Decal parents then starts decal drag and RETURNS early; everything else stays for INSERT_RAW / INSERT_TO_TREE / INSERT_TO_3D_VIEW modes (3D-view suppresses move when selection non-empty); any action requests ChangeHistory waypoint "Insert".
- `insertPasteInstances` = doInsertInstances(forceSuppressMove=true); `insertInstances` = forceSuppressMove=false.
- Small helpers: `insertDecal(d, mode)` → Workspace::startDecalDrag; `removeInstances` is an EMPTY BODY (assert-only stub).

## Usage / reflection touchpoints

Studio plumbing consumed by InsertService, toolbox UI, clipboard paste. Pairs with Workspace.md, ManualJointHelper.md, ModelInstance.md, SpawnLocation.md, Team.md/Teams.md, Sky.md/Lighting.md in this folder; MegaDragger/DragUtilities under Tool/.

## Gotchas

- `removeInstances` does NOTHING — callers deleting instances must handle removal elsewhere.
- moveToPoint silently no-ops if pv lacks a primaryPart or isn't inside this root — no error.
- Services are rejected only with an error print in two separate code paths; the instance is silently dropped either way.
- insertCharacterView's HopperBin shortcut checks findLocalPlayer but not success of parenting; insertRemoteCharacterView's Tool check ignores HopperBin entirely (asymmetric special cases).
- focusCameraOnParts breaks out of its frustum loop on FIRST off-screen part but keeps checking subsequent parts' lock status — needsCameraAdjustment reflects last-checked part when earlier ones were in-frustum... actually it breaks immediately once true; parts after a true result are unchecked.
- UNKNOWN: PromptMode/InsertMode enum definitions header-side; viewPort update mechanism ("every render") lives outside this TU.
