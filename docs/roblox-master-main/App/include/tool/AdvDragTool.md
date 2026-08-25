# App/include/tool/AdvDragTool.h

## Purpose

Static dispatcher that starts the *advanced* (Studio arrow-tool) drag: decides between part/group/drop variants from the current selection. Header carries the canonical tool-relationship diagram (identical comment block in [DragTool.md](DragTool.md)):

```
GameTool  (select top parts for dragging, close to character)
    -> PartDragTool
GrabTool (drag parts and models in game)
    -> DragTool
ArrowTool (powerpoint-style select, box select, shift select, drag)
    -> DragTool
// Auxiliary (private)
PartDragTool   (single part)
GroupDragTool  (group/model/selection)
DragTool -> PartDragTool | GroupDragTool
```

## Declared API

- `class AdvDragTool` — static-only:
  - `static shared_ptr<MouseCommand> onMouseDown(PartInstance* hitPart, const Vector3& hitWorld, const std::vector<Instance*>& dragInstances, const shared_ptr<InputObject>& inputObject, Workspace* workspace, shared_ptr<Instance> selectIfNoDrag)`

## Gotchas

- Leftover merge-review comments in-header: "TEMP COMMENT: verify merging..." / "Verifying merge..." — historical, not functional warnings.
- Signature mirrors [DragTool.md](DragTool.md)'s dispatcher; the implementation (`App/tool/AdvDragTool.cpp`) unconditionally wraps `dragInstances` into a `PartArray`, creates an [AdvLuaDragTool.md](AdvLuaDragTool.md), and returns the result of its `onMouseDown` — no adv/legacy switching happens inside this dispatcher itself.
