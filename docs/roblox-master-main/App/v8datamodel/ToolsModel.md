# ToolsModel.cpp

## Purpose

Implements THREE legacy Studio MouseCommands: `ModelTool` (hover-highlight of the top-level instance under the cursor), `AnchorTool` ("Anchor", toggles anchored across ALL parts of the hovered top instance with cursor feedback and undo waypoint), and `LockTool` ("Lock", toggles PartInstance lock similarly).

## Key types and API

Extends MouseCommand (see MouseCommand.md). Constants sAnchorTool/sLockTool.

- ModelTool::onMouseHover resolves `Workspace::findTopInstance(hitPart)` into topInstance; render3dAdorn delegates SELECT_NORMAL to its IAdornable.
- AnchorNode functor: sets anchored on direct PartInstance children, recursing otherwise; `HasUnAnchoredNode` recursive scan; allChildrenAnchored = no unanchored node found.
- AnchorTool: hover recomputes allAnchored when hover target CHANGES (stale flag if anchoring state changes externally mid-hover); cursor names "AnchorCursor"/"UnAnchorCursor"; mouse-down toggles + ChangeHistoryService waypoint "Anchor" (only when target not locked).
- LockTool: cursor Lock/Unlock variants; toggles static PartInstance::get/setLocked on the top INSTANCE (not just parts) + waypoint "Lock".

## Usage / reflection touchpoints

Pure Studio tooling. Pairs with MouseCommand.md, Surface.md descriptors consumers, ChangeHistory docs in this folder.

## Gotchas

- AnchorTool's allAnchored only refreshes on hover-target CHANGE — anchoring via another path leaves a stale cursor until re-hover.
- LockTool applies lock to ANY Instance (Model too) though cursor naming implies parts.
- Both tools keep capturing (return shared_from(this)) on click.
