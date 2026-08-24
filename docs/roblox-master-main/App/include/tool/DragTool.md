# App/include/tool/DragTool.h

## Purpose

Static dispatcher that starts a standard drag: given the hit part and drag-instance list it instantiates the right auxiliary MouseCommand (PartDragTool for one part, GroupDragTool for many/model). Hosts the shared tool-hierarchy comment diagram (see [AdvDragTool.md](AdvDragTool.md) for the full tree).

## Declared API

- `class DragTool` — static-only:
  - `static shared_ptr<MouseCommand> onMouseDown(PartInstance* hitPart, const Vector3& hitWorld, const std::vector<Instance*>& dragInstances, const shared_ptr<InputObject>& inputObject, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag)`

## Gotchas

- Called by GrabTool and ArrowTool per the header diagram; GameTool bypasses it via PartDragTool.
- Selection-vs-drag fallback (`selectIfNoDrag`) is forwarded verbatim to the created tool.
