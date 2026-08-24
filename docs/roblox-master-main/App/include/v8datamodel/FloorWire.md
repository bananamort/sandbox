# App/include/v8datamodel/FloorWire.h

## Purpose

`FloorWire` Instance — decorative animated "wire" hugging surfaces between two parts (From/To part refs), rendered as a textured trail with velocity scroll, radius, and spacing controls.

## Declared API

`class FloorWire : public DescribedCreatable<FloorWire, GuiBase3d, sFloorWire>`

- Part endpoints: `static RefPropDescriptor<FloorWire, PartInstance> prop_From/prop_To;` accessors `setFrom(PartInstance*)/getFrom()`, `setTo(...)/getTo()`; weak storage `from`, `to`.
- Appearance props: `prop_Texture` (TextureId), `prop_TextureSize` (Vector2), `prop_Velocity` (float scroll speed), `prop_StudsBetweenTextures`, `prop_CycleOffset`, `prop_WireRadius` — full getter/setter pairs for each.
- Statics: `kMinDistanceFromBlocks`, `kMaxSegments`.
- Rendering: IAdornable override `render3dAdorn(Adorn*)`; protected pipeline: `setPartInstance(weak_ptr<PartInstance>&, PartInstance*, const PartProp&)`, static `computeSurfacePosition(part, RbxRay, Vector3* out)`, `bool incrementalBuildSegments(workspace, contactManager, dest, bool moveInX, std::vector<Vector3>* out)`, `buildTrailSegments(workspace, from, to, out)`, `drawSegments(workspace, camera, segments, adorn)`.

## Gotchas

- Endpoint parts are weak refs — deleting From/To silently kills the wire.
- Segment building consults ContactManager/workspace geometry: wires path around obstacles up to kMaxSegments.
- Purely visual: no physics body.

## UNKNOWN

- Exact constants of kMinDistanceFromBlocks/kMaxSegments (.cpp — see [FloorWire.md](../../v8datamodel/FloorWire.md)).

## Cross-links

- Implementation: [App/v8datamodel/FloorWire.md](../../v8datamodel/FloorWire.md).
- Base: [GuiBase3d.md](GuiBase3d.md); kin: [SelectionLasso.md](SelectionLasso.md)-style trail renderers.
