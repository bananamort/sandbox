# App/include/v8datamodel/ToolsPart.h

## Purpose

Legacy Studio part-editing mouse commands: base `PartTool` (hover/adorn over a PartInstance), `FillTool` + static `FillToolColor` (paint parts, signal-notified color), `DropperTool` (pick color), `MaterialTool` + static material. Fill and Material tools are sticky by creating fresh instances.

## Declared API

`class PartTool : public MouseCommand`
- Private: `shared_ptr<PartInstance> partInstance`.
- Overrides: `render3dAdorn(Adorn*)`, `onMouseHover(InputObject)`. Ctor/dtor.

`class FillToolColor`
- Holds `BrickColor color`; `rbx::signal<void(BrickColor)> brickColorSignal`; ctor; inline `get()`; inline `set(newColor)` fires signal only on change.

`class FillTool : public Named<PartTool, sFillTool>`
- `static FillToolColor color;` — process-global paint color.
- Overrides: virtual `onMouseDown`, `getCursorName() {return "FillCursor";}`; `isSticky() const {return Creatable<MouseCommand>::create<FillTool>(workspace);}` — sticky via NEW instance.
- Inline ctor.

`class DropperTool : public Named<PartTool, sDropperTool>`
- Overrides onMouseDown + cursor "DropperCursor"; inline ctor. (Not sticky.)

`class MaterialTool : public Named<PartTool, sMaterialTool>`
- `static PartMaterial material;` — process-global.
- Same pattern as FillTool: onMouseDown, cursor "MaterialCursor", isSticky creates new instance.

## Gotchas

- Paint/material state lives in CLASS STATICS shared across all tool instances and workspaces — no per-document isolation.
- Two stickiness idioms coexist (self-return in ToolsModel vs new-instance here); behavior differs for command identity.

## UNKNOWN

- What onMouseDown does on empty space (deselect? nothing).

## Cross-links

- Implementation: [App/v8datamodel/ToolsPart.md](../../v8datamodel/ToolsPart.md).
- Base: [MouseCommand.md](MouseCommand.md); siblings: [ToolsModel.md](ToolsModel.md), [ToolsSurface.md](ToolsSurface.md); materials: Util/PartMaterial.h via [PartInstance.md](PartInstance.md).
