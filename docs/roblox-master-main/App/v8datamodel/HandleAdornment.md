# HandleAdornment.cpp

## Purpose

Implements `HandleAdornment` ("HandleAdornment") — the DescribedNonCreatable PVAdornment base for scriptable 3D drag handles (2015, Tyler Berg): adornee-relative CFrame + SizeRelativeOffset placement, mouse hit-testing per shape, and MouseEnter/Leave/Down/Up replication. Defines creatable shapes `BoxHandleAdornment`, `ConeHandleAdornment`, `CylinderHandleAdornment`, `SphereHandleAdornment`, `LineHandleAdornment`, `ImageHandleAdornment`.

## Key types and API

### HandleAdornment base
- Props (public statics, category_Data): SizeRelativeOffset (Vector3 — offset scaled by ½ part size), CFrame (CoordinateFrame, local to adornee), ZIndex (int, default −1; setter silently ignores values > Adorn::maximumZIndex AND unchanged values — note: no lower clamp), AlwaysOnTop (bool). Color/transparency inherited from PVAdornment (color default white for Image variant only).
- RemoteEvents (Security::None, SCRIPTING|CLIENT_SERVER): MouseEnter, MouseButton1Down, MouseButton1Up, MouseLeave — all argument-less.
- getWorldCoordinateFrame: PartInstance adornee → pvCFrame·CFrame with world offset = pointToWorldSpace(SizeRelativeOffset × partSizeUi × 0.5); ModelInstance adornee → computePart().gridSize equivalent; no adornee → identity.
- process(event): visible+mouse only; MOUSEMOVEMENT toggles mouseOver and fires enter/leave; falls through (no break!) into TYPE_MOUSEBUTTON1 case: down-over sinks and fires Down; up fires Up when over. Hit test via per-shape isCollidingWithHandle.

### Shape subclasses (all DescribedCreatable<..., HandleAdornment>)
- BoxHandleAdornment: Size Vector3 (1,1,1); render box(cframe, size/2, color4(1−transparency), zIndex, alwaysOnTop). Hit: G3D ray-vs-local-box.
- ConeHandleAdornment: Radius(0.5)/Height(2.0); cframe pre-rotated +90° about Y (fromEulerAnglesXYZ(0,π/2,0)); hit = ray vs billboarded triangle (camera-facing) OR ray vs base-plane disc ≤ radius.
- CylinderHandleAdornment: Radius(1.0)/Height(1.0); same +90° Y pre-rotation; hit = ray vs side rectangle (camera-facing) OR either end-cap disc.
- SphereHandleAdornment: Radius(1.0); hit = ray vs sphere; renders via adorn->sphere.
- LineHandleAdornment: Length(5.0)/Thickness(1.0); hit projects both endpoints to SCREEN space and tests a camera-facing rectangle of width thickness (vertical-degenerate fallback when Δy==0); render line3dAA along local lookVector × Length.
- ImageHandleAdornment: Size Vector2(1,1) + Image TextureId (default "rbxasset://textures/SurfacesDefault.png"); ctor forces color=white; hit = ray vs world-space quad of Size in local XY plane; render creates texture proxy (createTextureProxy(image,...,getFullName()+".Image")), binds, draws quad with UV 0..1, unbinds; skips draw while texture still loading (`waiting`).

## Usage / reflection touchpoints

Base class PVAdornment ([Adornment](Adornment.md)-family); rays from [MouseCommand](MouseCommand.md)::getUnitMouseRay through [Workspace](Workspace.md)::findWorkspace + Camera; consumers build plugin/core-script gizmos (e.g. surface tooling); sibling legacy system [Handles](Handles.md)/[HandlesBase](HandlesBase.md).

## Gotchas

- process() switch is MISSING a break after the MOUSEMOVEMENT case — every movement event also runs the MouseButton1 block (harmless today since it checks isLeftMouseDown/UpEvent, but any future code there runs on every move).
- setZIndex accepts negatives unclamped (default −1) but rejects > maximumZIndex SILENTLY — no propertyChanged, no warning.
- Cone/Cylinder hit-tests depend on live Workspace::getCamera() — no camera → potential NULL deref inside getCamera()->coordinateFrame() path before any guard.
- ImageHandleAdornment render allocates a texture proxy EVERY frame (no caching) — churn under animated scenes.
- ZIndex ordering vs GuiObject ZIndex systems is separate (Adorn::maximumZIndex domain).
- UNKNOWN: which pipeline enumerates adornments for input (PVAdornment collection outside this TU); whether SizeRelativeOffset uses partSizeUi vs gridSize intentionally differs between Part and Model paths.
