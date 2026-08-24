# App/include/tool/DropTool.h

## Purpose

Static factory for the "drop" flavor of drag interaction: like a DragTool but self-cancelling and with different mouseUp behavior. Comment block in-header: "Drop tool is like a drag tool, except it knows how to cancel itself, and has a different behavior on mouseUp."

## Declared API

- `class DropTool` (no ctor — static-only)
  - `static shared_ptr<MouseCommand> createDropTool(const Vector3& hitWorld, const std::vector<Instance*>& dragInstances, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag, bool suppressPartsAlign = false)`

## Gotchas

- `selectIfNoDrag`: if the drag set ends up empty, that instance gets selected instead — dual-purpose factory.
- `suppressPartsAlign = false` default keeps legacy snapping behavior; pass true to skip parts-alignment on drop.
- Forward declares `Workspace`, `PartInstance`, `PVInstance` though only `Workspace` and `Instance` appear in the signature (leftovers).
