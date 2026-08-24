# App/include/tool — Index

Drag/drop/selection tooling: MouseCommand tools (classic grab/clone/game, advanced Studio arrow/move/rotate/resize), the dragger engines they drive (MegaDragger / RunDragger / AdvRunDragger / LuaDragger family), static placement math (Dragger, DragUtilities), and shared enums (DragTypes).

## Tool MouseCommands & dispatchers

| File | Doc | Notes |
|---|---|---|
| DragTypes.h | [DragTypes.md](DragTypes.md) | JoinType / MoveType / ManualJointType / DraggerGridMode enums (RBX::DRAG). |
| ICancelableTool.h | [ICancelableTool.md](ICancelableTool.md) | onCancelOperation() interface. |
| GameTool.h | [GameTool.md](GameTool.md) | In-game drag tool with draggablePart filter. |
| GrabTool.h | [GrabTool.md](GrabTool.md) | Classic grab tool. |
| CloneTool.h | [CloneTool.md](CloneTool.md) | Classic clone-on-click tool. |
| HammerTool.h | [HammerTool.md](HammerTool.md) | Legacy 2005 hammer tool. |
| NullTool.h | [NullTool.md](NullTool.md) | NewNullTool — default tool + click-to-move + ClickDetector hover. |
| DropTool.h | [DropTool.md](DropTool.md) | Static createDropTool factory. |
| DragTool.h | [DragTool.md](DragTool.md) | Static dispatcher → Part/GroupDragTool; hosts tool-tree diagram. |
| AdvDragTool.h | [AdvDragTool.md](AdvDragTool.md) | Advanced variant of that dispatcher. |
| PartDragTool.h | [PartDragTool.md](PartDragTool.md) | Single-part drag (RunDragger + MegaDragger). |
| PartDropTool.h | [PartDropTool.md](PartDropTool.md) | Single-part drop phase; ICancelableTool. |
| GroupDragTool.h | [GroupDragTool.md](GroupDragTool.md) | Multi-part drag base owning a MegaDragger. |
| GroupDropTool.h | [GroupDropTool.md](GroupDropTool.md) | Multi-part drop phase; ICancelableTool. |
| LuaDragTool.h | [LuaDragTool.md](LuaDragTool.md) | MouseCommand wrapper over LuaDragger. |
| AdvLuaDragTool.h | [AdvLuaDragTool.md](AdvLuaDragTool.md) | Advanced-arrow wrapper over AdvLuaDragger. |
| ToolsArrow.h | [ToolsArrow.md](ToolsArrow.md) | ArrowToolBase / AdvArrowToolBase (+static mode flags) / AdvArrowTool / BoxSelectCommand. |
| AxisMoveTool.h | [AxisMoveTool.md](AxisMoveTool.md) | Declares AxisToolBase gizmo base only. |
| AxisRotateTool.h | [AxisRotateTool.md](AxisRotateTool.md) | Green rotate gizmo on AxisToolBase. |
| AdvMoveTool.h | [AdvMoveTool.md](AdvMoveTool.md) | AdvMoveToolBase + orange AdvMoveTool. |
| AdvRotateTool.h | [AdvRotateTool.md](AdvRotateTool.md) | Green adv rotate gizmo on AdvMoveToolBase. |
| ResizeTool.h | [ResizeTool.md](ResizeTool.md) | Face-handle resize tool. |
| MoveResizeJoinTool.h | [MoveResizeJoinTool.md](MoveResizeJoinTool.md) | Modern adv move/resize/join tool with ghost preview. |

## Dragger engines & math

| File | Doc | Notes |
|---|---|---|
| Dragger.h | [Dragger.md](Dragger.md) | All-static safe-move/rotate/Y-drop placement math; maxDragDepth −400 vs physics cull −500. |
| DragUtilities.h | [DragUtilities.md](DragUtilities.md) | PartArray typedef; ray hits, join/unjoin, conversions, grid math. |
| MegaDragger.h | [MegaDragger.md](MegaDragger.md) | Multi-part drag engine with join/unjoin and safe ops. |
| RunDragger.h | [RunDragger.md](RunDragger.md) | Single-part snap dragger. |
| AdvRunDragger.h | [AdvRunDragger.md](AdvRunDragger.md) | Snap dragger with grid modes, joint-create, temp-part multi-drag. |
| LuaDragger.h | [LuaDragger.md](LuaDragger.md) | Script-facing drag controller Instance. |
| AdvLuaDragger.h | [AdvLuaDragger.md](AdvLuaDragger.md) | Copy-paste advanced twin of LuaDragger. |

30 of 30 headers documented. No .inl files in this directory.
