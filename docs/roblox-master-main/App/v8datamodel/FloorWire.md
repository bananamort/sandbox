# FloorWire.cpp

## Purpose

Implements `FloorWire` ("FloorWire") — a GuiBase3d adornment drawing a textured wire/cable between two parts' surfaces: raycast-based pathfinding that hugs the ground and routes around obstacles (max 7 segments), animated texture flow (Velocity/StudsBetweenTextures/CycleOffset) via TextureTrail, ball joints at bends.

## Key types and API

Descriptors:
- `FloorWire::prop_From("From", STANDARD)` / `prop_To("To", STANDARD)` — RefPropDescriptor<PartInstance>.
- `prop_Texture("Texture", category_Appearance)` — TextureId; `prop_TextureSize("TextureSize")` Vector2 (default 1,1).
- `prop_Velocity("Velocity")` float default 2; `prop_StudsBetweenTextures("StudsBetweenTextures")` default 4 (setter rejects ≤0 but STILL raises changed); `prop_CycleOffset("CycleOffset")`; `prop_WireRadius("WireRadius")` default 0.0625.
No Security:: arguments. Note: most setters store WITHOUT raising (only From/To/StudsBetweenTextures raise).

Constants: `sFloorWire`, `kMinDistanceFromBlocks = 0.2f`, `kMaxSegments = 7`.

Behavior:
- `render3dAdorn` — requires both endpoints alive AND still in a DataModel; builds then draws segments.
- `computeSurfacePosition` — ray from other endpoint to part center picks the hit face, offsets by half size +0.2 studs outward.
- `buildTrailSegments` — drop-ray from start approximates ground height (+0.2); recursive `incrementalBuildSegments` alternates X/Z axis moves toward target, shortening at obstacles by kMinDistanceFromBlocks, giving up on >7 segments / blocked axes; X-first then Z-first retry; failure degrades to straight line from→(ground)→to.
- `drawSegments` — per-segment cylinder along axis + sphere joints at interior bends; TextureTrail::renderInternal carries cumulative slack so textures flow continuously across segment boundaries (`lastOffset = fmod(lastOffset+distance, spacing)`), plus global cycleOffset.

## Usage / reflection touchpoints

Sibling adornment of [TextureTrail](TextureTrail.md) (shared renderInternal); occlusion filters from [Filters](Filters.md).

## Gotchas

- Most setters don't raise PropertyChanged — scripts watching Texture/Velocity/etc. changes get no signal.
- Path recomputes EVERY FRAME in the render adorn pass (raycasts ×2 + recursion) — expensive for many wires.
- If either endpoint leaves the DataModel the wire vanishes entirely rather than drawing stale.
