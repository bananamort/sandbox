# CERTIFICATION — App/include/tool (final independent review)

Reviewer: last-pass independent reviewer (all prior in-flight edits on disk re-verified from scratch; nothing taken on trust).
Method: all 30 source headers read IN FULL via tool calls, each paired .md read IN FULL; every concrete claim checked against source (signatures, access levels, member lists, comments). Behavioral claims cross-checked against `App/tool/*.cpp` where the header could not decide them. Fixes applied only where mechanically certain.

| File | Verdict | Notes |
|---|---|---|
| AdvDragTool.md | FIXED (this pass) | Header diagram + static `onMouseDown` signature verified. Removed UNSUPPORTED gotcha "adv variants honoring `isAdvArrowToolEnabled`" — App/tool/AdvDragTool.cpp has no such gate; it unconditionally wraps instances into a PartArray, creates AdvLuaDragTool, and delegates to its `onMouseDown`. Rewritten accordingly. |
| AdvLuaDragger.md | PASS | DragPhase enum, full state list incl hitPointOffset comment and m_originalPositions, adv-only toggles verified; breakFreeDistance non-inline claim confirmed against LuaDragger.h line 40 (`{return 1.5f;}` inline there). |
| AdvLuaDragTool.md | PASS | Ctor signature exact; private fields; override set incl onKeyDown/setCursor; derives Named<AdvArrowToolBase,…> — verified. |
| AdvMoveTool.md | PASS | Prior fix verified: `drawConnectors()` → true is present here and **protected** in this header (line 63), header comment quoted. All protected/private state, snapRotationAngle capital-A param, transparency map pair (base's static + instance copy — confirmed via ToolsArrow.h lines 72–73), pure virtuals, AdvMoveTool orange/HANDLE_MOVE/isSticky — verified. |
| AdvRotateTool.md | PASS | mOverHandleNormalId(NORM_UNDEFINED) ctor init, getNormalMask declared-only, green/HANDLE_ROTATE virtuals, render overrides, derives-from-AdvMoveToolBase gotcha — verified. |
| AdvRunDragger.md | FIXED (this pass ×2) | Purpose said multi-drag "**hides** parts"; gotcha said mode "*removes real parts from the world*". Both WRONG per App/tool/AdvRunDragger.cpp: tempPart (lines 224–231) is created sized/gridded over group extents and becomes dragPart; real primitives stay in-world in savedPrimsForMultiDrag, are moved alongside (lines 811–818), with pre-drag poses cached in originalLocations and restored by findNoSnapPosition (lines 755–767). No removal/hiding exists anywhere in the TU. Purpose + gotcha rewritten; SnapInfo delta, state list, macro gate, initLocal asymmetry all verified. |
| AxisMoveTool.md | FIXED (this pass) | Prior method-name fix (onMouseIdle/onMouseHover/onMouseDown/onMouseMove/onMouseUp) verified correct. This pass fixed an access-level error: `drawConnectors()` → true is a **private** override in AxisToolBase (line 33, before `protected:` at 35), not protected as doc implied; moved to the private bullet. Screen-space hit-test gotcha confirmed in cpp (`downPoint2d = inputObject->get2DPosition()`). |
| AxisRotateTool.md | PASS | Thin Named<AxisToolBase> specialization; green/HANDLE_ROTATE; isSticky self-recreate — verified exactly. |
| CloneTool.md | PASS | Members/overrides verified; clone behavior confirmed in cpp (onMouseIdle captures part; onMouseDown clones, inserts, plays PING_SOUND, hands copy to PartDragTool). |
| Dragger.md | PASS | Prior fixes verified: _EXT twins' parameter asymmetry (world/others _EXT takes ignorePrimitives + movedSoFar; ground-plane _EXT does not) matches lines 98–108; computePrimaryPart overload pair exact. maxDragDepth −400 vs physics-cull −500 quote verbatim (lines 124–126); dragSnap (1,0.1,1); groundPlaneDepth 0; all safe-move comments; deprecation marker on Array computeExtents — verified. |
| DragTool.md | PASS | Signature exact; dispatch claims confirmed in cpp (PartDragTool vs GroupDragTool creation; selectIfNoDrag forwarded verbatim); header diagram shared with AdvDragTool.h. |
| DragTypes.md | PASS | All four typedef-enums member-for-member in order. |
| DragUtilities.md | PASS | Prior fix verified: three partsToPrimitives overloads, only the G3D::Array variant returns World* (lines 65–67); two hitObjectOrPlane overloads counted; PartArray typedef; every method name checked; toGrid zero-default sentinel noted. |
| DropTool.md | FIXED (this pass) | Gotchas contradicted App/tool/DropTool.cpp: empty partArray returns a **null** command (not "selectIfNoDrag gets selected instead" — that instance is merely forwarded to PartDropTool); suppressPartsAlign is forwarded **only** on the GroupDropTool path, never on the single-part PartDropTool path. Both rewritten with cpp evidence; unused forward-declares gotcha verified. |
| GameTool.md | FIXED (this pass) | Vague/incorrect predicate gloss "(prevents dragging anchored/locked parts)" replaced with the exact cpp criteria: `!part->getPartLocked() && !part->lockedInPlace() && characterCanReach(hitPoint)` (GameTool.cpp lines 29–34). Header API otherwise verified. |
| GrabTool.md | PASS | Cursor/idle/hover/down/getCursorName/drawConnectors(true)/isSticky — verified. |
| GroupDragTool.md | PASS | Ctor signature, protected members incl drawConnectors (protected here), cursor conditional GrabRotateCursor/DragCursor, MegaDragger ownership — verified. |
| GroupDropTool.md | PASS | Dual inheritance Named<GroupDragTool>+ICancelableTool, ctor w/ suppressPartsAlign default false, commented-out onMouseDelta, advClosed-hand/DropCursor cursor, onCancelOperation — verified. |
| HammerTool.md | PASS | hammerPart member, override set incl /*ovverrid*/ typo note, isSticky — verified. |
| ICancelableTool.md | PASS | Single pure virtual; missing virtual dtor UB gotcha mechanically correct. |
| INDEX.md | PASS | 30/30 roster across both tables matches directory exactly; row notes spot-checked accurate (maxDragDepth −400 vs −500; temp-part multi-drag; copy-paste twin). |
| LuaDragger.md | PASS | Enum/state/ops/public API param-for-param; inline breakFreeDistance 1.5f; DescribedCreatable reflection note — verified. |
| LuaDragTool.md | PASS | Ctor exact; boost/shared_ptr vs engine aliases mixed-era gotcha visible in header; weak part array — verified. |
| MegaDragger.md | PASS | Prior fix verified: safeMoveAlongLine2's `bool& out_isCollided` is feedback out-param; safeRotateAlongLine2's extra param is input `const float& angle`. Reference-member contactManager, UNJOIN_JOIN default, rotateDragParts doc-comment quote, all op groups — verified. |
| MoveResizeJoinTool.md | FIXED (this pass) | Gotcha claimed resizeFloat vs advResizeImpl "differ in intersection checking semantics" — WRONG per cpp: resizeFloat is `destroyJoints() → advResizeImpl(...) → join()` with the same checkIntersection flag; the impl grid-quantizes amount via moveIncrement(). Rewritten. Static scalingPart, ctor-init gaps (targetPV/localNormalId/hitPointGrid/down uninit), full state/override lists — verified. |
| NullTool.md | PASS | Inline onMouseUp `{releaseCapture(); return shared_from(this);}`, const bool& + triple-out getIndicatedPart, waypoint fields, ClickDetector hover, IAdornable true — verified. |
| PartDragTool.md | PASS | Protected dragger pair with header comments quoted ("does snapping"/"does join / unJoin"), onMouseDelta present, cursor conditional — verified. |
| PartDropTool.md | PASS | Bases, ctor, overrides incl commented-out onMouseUp, hitLocal private, adv cursor ternary — verified. |
| ResizeTool.md | PASS | Ctor initializes only overHandle/moveAxis/movePerp — uninitialized-set gotcha exact; capturedDrag(int axisDelta); protected state complete — verified. |
| RunDragger.md | PASS | SnapInfo fields (incl lastHitWorld), full private machinery list, public API, statics note, sentinel values — verified. |
| ToolsArrow.md | PASS | Both prior fixes verified: exact virtual names onMouseIdle/onMouseHover/onMouseDown; PartsTransparencyCollection typedef + **static** originalPartsTransparency are **protected** (lines 71–73). STUDIO_CAMERA_CONTROL_SHORTCUTS define, JointCreationMode values, 8 static mode flags, BoxSelectCommand members — verified. |

## Totals

- Files reviewed: 31 (30 header docs + INDEX.md) — full read, no sampling
- **PASS = 25 · FIXED = 6 (AdvDragTool, AdvRunDragger, AxisMoveTool, DropTool, GameTool, MoveResizeJoinTool) · FAIL = 0**
- Severity ledger (this pass): WRONG ×4 (AdvRunDragger world-removal/hiding ×2 spots counted once; DropTool empty-set selection; MoveResizeJoinTool resize-pair semantics; GameTool predicate detail), UNSUPPORTED ×1 (AdvDragTool isAdvArrowToolEnabled gating), STYLE/access ×1 (AxisMoveTool drawConnectors private-vs-protected), MISSING-GOTCHA ×0
- Prior reviewers' 6 in-flight tool fixes (AdvMoveTool, AxisMoveTool-names, DragUtilities, Dragger, MegaDragger, ToolsArrow) independently re-verified against source: all correct, retained.
