# Selection.cpp

## Purpose

Implements `Selection` (instance "Selection"), the Studio selection service: an ordered Instance list with add/remove/clear/set/toggle operations, per-instance ancestry watching (auto-evicts instances that leave the DataModel root), filtered-selection extension points (ISelectionBase), and the plugin-facing Get/Set/SelectionChanged reflection surface.

## Key types and API

Descriptors:
- `func_getSelection("Get():Instances")` — **Security::Plugin**.
- `func_setSelection("Set(selection)")` — **Security::Plugin**.
- `desc_SelectionChanged("SelectionChanged()")` — event with NO security tier argument (descriptor default).
- Constant `sFilteredSelection = NULL` (no separate class descriptor).

Internal mechanics:
- Storage: shared-write-protected `selection` (Instances) + `connections` map of per-instance ancestryChangedSignal connections.
- `instanceCanLiveInSelection`: instance's root ancestor must equal this service's root ancestor — anything moved outside the tree auto-evicts via `onAncestryChanged`.
- Mutators assert DataModel write_requested (debug): `addToSelection`, `removeFromSelection`, `clearSelection` (pop-back loop, disconnect+raiseRemoved each), `toggleSelection(instance)`, batch overloads.
- `setSelection(Instances)`: early-out when both empty; DISCONNECTS its own lua propagation connection during mutation, reconnects after, then fires luaSelectionChanged once (avoids Lua event spam). NOTE: iterates with `break` on first non-livable instance — remaining candidates silently dropped.
- `setSelection(Instance*)`: keeps target, removes others; deliberately re-requests write() per iteration because raiseRemoved side effects may mutate selection (comment-documented); moves target to front when it was at back.
- Events fan out to `filteredSelections` (ISelectionBase list) FIRST, then general selectionChanged signal; SelectionChanged carries {added or removed}.
- Dtor asserts empty selection and no leftover connections.

## Usage / reflection touchpoints

Entirely Studio/plugin-facing. Pairs with RootInstance.md (insert3dView reads selection size), ManualJointHelper.md (selected primitives), PluginManager.md; GuiService selectedGuiObject is the GUI-side twin documented in PlayerGui.md.

## Gotchas

- setSelection(Instances) BREAKS out of the loop at the first invalid entry — valid entries AFTER it are never added.
- SelectionChanged event lacks explicit security tier unlike Get/Set — inherits descriptor default.
- toggleSelection(batch)/setSelection(Instances) re-fire luaSelectionChanged manually while the propagation connection is detached, so exactly ONE Lua event per batch — but raiseAdded/Removed still fire N internal events during the window.
- getRootAncestor comparison means two DataModels can't share a selection silently.
