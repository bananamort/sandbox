# Commands.cpp

## Purpose

Implements the Studio verb/command layer: dozens of Verb subclasses driving toolbar/menu actions — selection toggles (bool props, anchor, lock), camera verbs (center/pan/tilt/zoom/zoom-extents), stats HUD toggles, Run/Pause/Reset state commands, delete with Cloud-Edit script-lock checks, rotate/tilt/move via MegaDragger, snap surfaces WELD→STUDS, select children, and Color/Material paint with static current-color/material state. No Instance descriptors at all — this is pure verb plumbing.

## Key types and API

No descriptors, no Security:: tiers (verbs are native-side). Consumed flags: `DebugDisplayFPS`, `UserAllCamerasInLua`.

Command families:
- **BoolPropertyVerb** — generic toggle of a named bool property across selection; isChecked = ANY selected true; doIt flips then requests ChangeHistory waypoint named after the property.
- **Camera**: CameraCenterCommand (FIXED type + focus on selection extents center, maintain-focus flag), CameraPan{Left,Right} → panUnits(±1), CameraTilt{Up,Down} → tiltUnits(∓1) gated by canTilt, CameraZoom{In,Out} → zoom(±1) gated by canZoom, CameraZoomExtentsCommand (union of selected extents — MegaClusterInstance terrain only counted when nonEmptyCellCount>0; falls back to camera zoomExtents() with no selection; disabled when local player not in FIXED under UserAllCamerasInLua).
- **Stats HUD**: StatsCommand/RenderStats/SummaryStats/CustomStats/NetworkStats/PhysicsStats (checks BOTH "PhysicsStats" and "PhysicsStats2" TopMenuBar names) all toggle via GuiBuilder; EngineStats runs ContactManager doStats.
- **RunStateVerb family**: RunCommand (enabled when no client present && not running), StopCommand (running→pause), ResetCommand (running/paused && NO local player → stop).
- **DeleteBase::doIt** — clears selection FIRST, deletes non-Workspace/non-Players/non-Service (and non-Player in CloudEdit) items; CloudEdit throws on locked LuaSourceContainer ("currently being edited by %s"); deleting the Camera immediately calls workspace->replenishCamera() so change history records correctly; waypoint requested after.
- **RotateAxisCommand** — MegaDragger startDragging/safeRotate/finishDragging; RotateSelectionVerb rotates about Y (`Math::matrixRotateY`), TiltSelectionVerb tilts by camera Y-quadrant.
- MoveUpSelectionVerb (+moveUpHeight)/MoveDownSelectionVerb (−1.2 studs) via safeMoveNoDrop.
- SnapSelectionVerb — recursive template `SurfaceSwap<WELD, STUDS>` over all 6 faces of every descendant PartInstance.
- SelectChildrenVerb — replaces selection with union of children (debug-asserts if called while disabled).
- AllCanSelect/CanNotSelect/UnlockAll — PartInstance::setLocked traversals.
- JoinCommand — exactly 2 selected && MotorFeature::canJoin → MotorFeature::join.
- FirstPersonCommand (enabled = local humanoid isFirstPerson), ToggleViewMode (doIt is an empty FASTLOG stub), ChatMenuCommand string builder ("Chat_m1_m2_m3").
- TurnOnManualJointCreation toggles static AdvArrowTool::advManualJointMode + sets advCreateJointsMode.
- Grid/manual-joint-strength verbs (SetDragGridToOne/OneFifth/Off, SetGridSizeTo{Two,Four,Sixteen}, SetManualJointTo{Weak,Strong,Infinite}) are EMPTY ctors — logic header-side.
- **ColorVerb/MaterialVerb/AnchorVerb** — static m_currentColor (brick_194) / m_currentMaterial (PLASTIC); applyColor/applyMaterial/applyAnchor recurse PartInstance or ModelInstance descendants; MaterialVerb::parseMaterial maps 20 material name strings (unknown → PLASTIC); AnchorVerb.isChecked uses AnchorTool::allChildrenAnchored.

## Usage / reflection touchpoints

Waypoint integration with [ChangeHistory](ChangeHistory.md); camera calls into [Camera](Camera.md); dragger mechanics in Tool/MegaDragger ([Base](../../Base/) adjacent); selection services shared with [Selection](Selection.md).

## Gotchas

- Many verbs carry "// TODO: Undo/Redo" comments yet DO request waypoints — the TODOs refer to missing granularity, not absence.
- DeleteBase clears the selection BEFORE deleting — undo restores instances but not the prior selection.
- MaterialVerb::parseMaterial silently maps ANY unknown material string to Plastic.
- ToggleViewMode is a no-op shell retained for keybinding compatibility.
