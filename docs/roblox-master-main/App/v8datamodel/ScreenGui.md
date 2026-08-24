# ScreenGui.cpp

## Purpose

Implements `ScreenGui` ("ScreenGui", a DescribedCreatable GuiLayerCollector — the top-level 2D UI layer rendered against the viewport) and `GuiMain` ("GuiMain", trivial ScreenGui subclass). ScreenGui tracks renderability by ancestry (must descend from a BasePlayerGui), buffers the current viewport, replicates computed absolute size/position to server peers, and maintains the modal-button registry consulted for modal-dialog blocking.

## Key types and API

Descriptors (category_Data):
- `prop_ReplicateAbsoluteSize("ReplicatingAbsoluteSize")` / `prop_ReplicateAbsolutePosition("ReplicatingAbsolutePosition")` — Vector2int16, cap **REPLICATE_ONLY**; setters ignore the value payload and just call handleResize(getRect2D(), false) since arrival itself signals a remote resize.

Lifecycle/behavior:
- Ctors: bufferedViewport defaults 800×600 rect; second ctor takes custom name. Dtor clears modal list + connections.
- `onServiceProvider`: on detach clears modals/connections; on attach adopts CoreGui's RobloxGui viewport as its own buffered viewport (unless it IS that gui).
- `onPropertyChanged`: base AbsoluteSize/AbsolutePosition changes re-handleResize against bufferedViewport AND raise the matching Replicating* descriptor (server→client propagation hook).
- Renderability: `isAncestorRenderableGui()` walks ancestors for BasePlayerGui; recomputed in `onAncestorChanged`, flipping `renderable` + shouldRenderSetDirty.
- Viewport: `render2dContext(adorn, context)` refreshes bufferedViewport from `adorn->getUserGuiRect()` before Super render; `setBufferedViewport` no-ops when unchanged but still handleResizes.
- Absolute position getter SUBTRACTS GuiService globalGuiInset (topbar offset compensation).
- Parenting: `askSetParent` REFUSES any GuiBase2d parent ("main window parent can be any kind of non-GUI instance").
- Input: `canProcessMeAndDescendants()` returns false — each ScreenGui processes individually to avoid double-processing nested guis; process/processGesture pass through with a Mac HUD comment.
- Modal tracking: onDescendantAdded connects every descendant GuiButton's propertyChangedSignal → onModalButtonChanged (getModal ⇒ insert/removeModalButton); hasModalDialog() = any registered modal button currently visible. Connections keyed by raw Instance* in a map.

## Usage / reflection touchpoints

Core script-facing GUI container. Pairs with PlayerGui.md (BasePlayerGui host + CoreGuiService RobloxGui), GuiObject.md family, GuiService.md in this folder.

## Gotchas

- ReplicatingAbsoluteSize/Position setters DISCARD incoming values — they exist purely as change carriers; actual layout derives locally from viewport.
- connections map uses raw Instance* keys; erase happens only in onDescendantRemoving — an instance destroyed without that callback leaks its connection entry until provider detach.
- getAbsolutePosition inset subtraction applies ONLY through the getter path; internal absolutePosition stays inset-inclusive.
- askSetParent blocks ALL GuiBase2d parents including other ScreenGuis.
- GuiMain adds nothing over ScreenGui — pure named alias kept for legacy serialization.
