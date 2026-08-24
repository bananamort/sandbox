# App/include/v8datamodel/PartDragger.h

## Purpose

`RBX::PartDragger` — a `Tool`-derived creatable class ("Part Drag" style tool). In this drop the header is a **hollow shell**: every override, member, and helper is commented out; only ctor/dtor and the reflection tag survive.

## Declared API

- `extern char sPartDragger;` — note: declared as `char`, not `const char* const` (unusual for DescribedCreatable tags in this codebase).
- `class PartDragger : public DescribedCreatable<PartDragger, Tool, sPartDragger>`
  - `PartDragger(); ~PartDragger();`
  - Everything else is commented-out scaffolding: commented `hitTest(const G3D::Ray&, G3D::Vector3&)`, IRenderable3d trio (`shouldRender3dAdorn/render3dAdorn/render3dSelect`), commented propGrip BoundProp, `askSetParent/askAddChild`, child add/remove hooks, `onPartTouched/equip/unequip/drop`, grip member, `onServiceProvider`, script own/release pair.

## Gotchas

- No certified implementation doc exists for PartDragger (checked App/v8datamodel/ index) — the .cpp may or may not still implement behavior; the header alone proves nothing beyond registration intent.
- `extern char sPartDragger` type deviates from the usual `extern const char* const sXxx` pattern seen across v8datamodel headers.

## UNKNOWN

- Actual runtime behavior: whether the .cpp implements equip/drop or whether this tool is vestigial in this build. UNKNOWN pending .cpp audit (no certified doc to link).

## Cross-links

- Base: [Tool.md](Tool.md) (implementation: [App/v8datamodel/Tool.md](../../v8datamodel/Tool.md)).
- Related draggers: [PartDragger.md](PartDragger.md) (this file), [Handles.md](Handles.md), [ArcHandles.md](ArcHandles.md), [MouseCommand peers](MouseCommand.md).
