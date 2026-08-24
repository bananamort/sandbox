# SurfaceGui.cpp

## Purpose

Implements `SurfaceGui` ("SurfaceGui"), a GuiLayerCollector rendered onto one face of a PartInstance in 3D: Adornee (or parent-part fallback), Face, CanvasSize, Enabled/Active, ToolPunchThroughDistance gating for input. Builds a per-face projection matrix each frame, renders children through an AdornSurface view, unprojects 3D hit points into canvas coordinates for mouse processing, and maintains per-part SurfaceGui cookie lists for fast lookup.

## Key types and API

Descriptors (category_Data, no security tier ⇒ default):
- `prop_adornee("Adornee")` — RefPropDescriptor Instance.
- `prop_Enabled("Enabled")` — bool default true (setter render-dirty).
- `prop_Active("Active")` — bool default true (input gate only).
- `prop_CanvasSize("CanvasSize")` — Vector2 default 800×600 (setter handleResize).
- `prop_Surface("Face")` — EnumPropDescriptor NormalId, default NORM_Z_NEG.
- `prop_maxDistance("ToolPunchThroughDistance")` — float default 0.

Statics: s_numInstances counter; FFlag GUIZFighterGPU(true) declared here.

Rendering:
- `shouldRender3dSortedAdorn`: enabled AND part resolvable AND still inside a DataModel.
- `getPart()`: adornee weak_ptr else PARENT if that is usable (comment: easy world-insertion replication).
- `buildGuiMatrix`: part rendering CF + XML size; frustum visibility early-out; face→(yaw,pitch) tables {90,90,0,-90,90,180}/{0,90,0,0,-90,0}; projection = scale(size) · rot · translate(-0.5,0.5,0.5) · scale(1/canvas); writes proj into a CoordinateFrame.
- `render3dSortedAdorn`: skips when disabled or `isYetAnotherSpecialCase()` (= local player exists AND gui descends from StarterGui — template copies must not render); renders Super::render2d into AdornSurface(part·proj).
- `isYetAnotherSpecialCase()` name preserved from source.

Input:
- `process()` flatly returns notSunk — 3D guis never consume normal 2D pipeline events.
- `process3d(event, point3d, ignoreMaxDistance)`: builds matrix, unprojects (part-space → canvas coords with Y flip), rejects when !enabled/!active or beyond ToolPunchThroughDistance from local character (unless ignoring); mouse events get position REWRITTEN to canvas coords, dispatched via Super::process(event,false), then restored.
- `canProcessMeAndDescendants()` false — processed individually like ScreenGui.md.
- `unProcess()`: synthesizes CANCEL mousemove + focus events at (-1e4) to clear hover/focus state.

Cookie tracking: setAdornee removes self from old part's SurfaceGui weak list, prunes expired entries, appends to new; static `findSurfaceGui(part, face)` checks cookies then direct children, skipping special-case StarterGui instances.

Analytics: first ancestor change under server presence fires once "SurfaceGui" GA event; first non-TextLabel descendant added fires once "SurfaceGuiNonText".

## Usage / reflection touchpoints

Fully script-facing. Pairs with PlayerGui.md/ScreenGui.md (processing model), GuiObject family in this folder, BillboardGui.md sibling.

## Gotchas

- Active=false blocks INPUT but the gui still RENDERS; Enabled=false stops rendering but process3d also checks enabled.
- Face yaw/pitch tables are positional (index by enum) — enum order changes silently break orientation.
- process3d rewrites the SHARED InputObject position then restores — not thread-safe against concurrent readers of the same event.
- getPart() parent fallback means deleting Adornee silently reparents rendering to whatever parent exists (even non-parts return then fail buildGuiMatrix).
- UNKNOWN: AdornSurface depth/clip behavior header-side; TypedMemItem-style cookie storage on PartInstance.
