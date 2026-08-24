# App/include/v8datamodel/ToolsSurface.h

## Purpose

Legacy Studio surface-painting mouse commands: abstract `SurfaceTool` (resolves hovered part face into a `Surface` and calls pure-virtual doAction) plus concrete per-SurfaceType tools — DecalTool (cancelable decal placement), Flat/Glue/Weld/Studs/Inlet/Universal/SmoothNoOutlines (surface type setters, sticky), Hinge/RightMotor (sticky, static isStickyVerb flag), LeftMotor/OscillateMotor.

## Declared API

`class SurfaceTool : public MouseCommand`
- Private: overrides `onMouseDown`, `render3dAdorn(Adorn*)`; state `int surfaceId; std::string name;`
- Protected: pure `virtual void doAction(Surface* surface) = 0`; `onMouseHover` override; state `shared_ptr<PartInstance> partInstance; Surface surface;`
- Ctor/dtor `(Workspace*)`.

Concrete tools (all `Named<SurfaceTool, sX>` unless noted):
- `DecalTool : Named<SurfaceTool, sDecalTool>, public ICancelableTool` — holds `shared_ptr<Decal> decal`, `RBX::InsertMode insertMode`, `bool parentIsPart`; cursor "ArrowCursorDecalDrag"; doAction is EMPTY `{}`; overrides onMouseHover/onMouseUp/onKeyDown; ctor takes `(Workspace*, Decal*, InsertMode)`; implements `virtual shared_ptr<MouseCommand> onCancelOperation()`; commented-out isSticky.
- Sticky surface-type tools: `FlatTool` ("FlatCursor"), `GlueTool` ("GlueCursor"), `WeldTool` ("WeldCursor"), `StudsTool` ("StudsCursor"), `InletTool` ("InletCursor"), `UniversalTool` ("UniversalCursor"), `SmoothNoOutlinesTool` ("FlatCursor") — each with private doAction + inline `isSticky() {return Creatable<MouseCommand>::create<X>(workspace);}`.
- Motor/hinge family: `HingeTool` ("HingeCursor", `static bool isStickyVerb;`, out-of-line isSticky()), `RightMotorTool` ("MotorCursor", static isStickyVerb, out-of-line isSticky()), `LeftMotorTool` ("MotorCursor", NOT sticky), `OscillateMotorTool` ("MotorCursor", NOT sticky).

## Gotchas

- DecalTool's doAction is deliberately empty — decal insertion happens through its own hover/up/key path + cancel support (ICancelableTool), not the surface-type mechanism.
- Hinge/RightMotor stickiness is gated by a static bool (isStickyVerb) — global toggle affecting all instances.
- SmoothNoOutlinesTool reuses the flat cursor name.

## UNKNOWN

- What isStickyVerb toggles from (verb/checkbox wiring out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/ToolsSurface.md](../../v8datamodel/ToolsSurface.md).
- Base: [MouseCommand.md](MouseCommand.md); surface model: [Surface.md](Surface.md); siblings: [ToolsPart.md](ToolsPart.md), [ToolsModel.md](ToolsModel.md); decal target: [Decal.md](Decal.md).
