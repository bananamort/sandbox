# App/include/tool/DropTool.h

## Purpose

Static factory for the "drop" flavor of drag interaction: like a DragTool but self-cancelling and with different mouseUp behavior. Comment block in-header: "Drop tool is like a drag tool, except it knows how to cancel itself, and has a different behavior on mouseUp."

## Declared API

- `class DropTool` (no ctor — static-only)
  - `static shared_ptr<MouseCommand> createDropTool(const Vector3& hitWorld, const std::vector<Instance*>& dragInstances, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag, bool suppressPartsAlign = false)`

## Gotchas

- Dispatch (per `App/tool/DropTool.cpp`): empty drag set → returns a **null** command; exactly one part → `PartDropTool` (which receives `selectIfNoDrag` verbatim); more than one → `GroupDropTool`.
- `suppressPartsAlign = false` default keeps legacy snapping behavior — but it is **only** forwarded on the multi-part `GroupDropTool` path; the single-part `PartDropTool` path never sees it.
- Forward declares `Workspace`, `PartInstance`, `PVInstance` though only `Workspace` and `Instance` appear in the signature (leftovers).
