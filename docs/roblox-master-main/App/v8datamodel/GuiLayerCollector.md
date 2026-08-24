# GuiLayerCollector.cpp

## Purpose

Implements `GuiLayerCollector` ("LayerCollector") — the DescribedNonCreatable GuiBase2d base for ScreenGui/BillboardGui-style containers. Maintains a per-GUIQueue × per-ZIndex matrix of visible GuiBase descendants (rebuilt lazily), renders them back-to-front with a background/texture split, dispatches input and gestures in reverse z order (topmost first), and supplies gamepad-selection candidates to GuiService.

## Key types and API

No descriptors of its own; constant `sLayerCollector = "LayerCollector"`. Flag: `DFFlag::FixClippedScrollingFrameNavigation(true)`.

State: `mGuiVectors[GUIQUEUE_COUNT][maxZIndex+1]` (GuiVector = vector<shared_ptr<GuiBase>>), `rebuildGuiVector` dirty flag, `propertyConnections` map Instance→connection for Visible/ZIndex tracking.

Behavior:
- ctor pre-sizes every queue/z bucket (RBXASSERT minZIndex==0); dtor logs FLog::GuiTargetLifetime.
- onDescendantAdded/Removing set dirty + (dis)connect propertyChange listeners; descendantPropertyChanged re-dirties only on [GuiObject](GuiObject.md) prop_Visible / prop_ZIndex (public static descriptors).
- LoadZ(instance, guiVectors) — recursive: GuiBase descendants pass only if canProcessMeAndDescendants(); their children recurse ONLY when the parent was enqueued (z<bucket size guard); Folder children always recursed (transparent containers). Comment: "Only render GuiBase objects that are below a PlayerGui".
- loadZVectors clears all buckets without realloc then walks children.
- render2d → render2dContext(adorn,NULL): rebuild if dirty, then for z=0..max render2dStandardGuiElements (two passes: backgrounds+borders, then textures) over GUIQUEUE_GENERAL and render2dTextGuiElements (single pass — comment: measuring text twice costs more than extra draw calls) over GUIQUEUE_TEXT. Visibility gated by isVisible(viewport).
- processGesture — reverse z, reverse queue order; delegates to GuiBase::processGesture via doProcessGesture; first sink wins.
- getGuiObjectsForSelection(out) — collects Selectable GuiObjects that are currently-visible OR live under the selected object's visible ancestor ScrollingFrame; under FixClippedScrollingFrameNavigation uses isCurrentlyVisible()||isDescendantOf(myAncestorScrollingFrame) instead of checking each candidate's own ScrollingFrame ancestor; skips the currently selected object.
- process(event, sinkIfMouseOver) — ignores TYPE_MOUSEIDLE; runs processDescendants; if mouse-only event wasn't sunk but hovered GUI and sinkIfMouseOver → returns sunk targeting the hover target ("sink it in the player gui").
- processDescendants — reverse iteration, calls each child's process(event); sunk answer gets default target = the child; tracks max-ZIndex hover target for notSunkMouseWasOver; tryReleaseLastButtonDown on every exit path: on mouse-up, if UserInputService's lastDownGuiObject (BUTTON1 or BUTTON2) is our descendant, resets its GuiState to NOTHING and clears lastDown (stuck-button cleanup).

## Usage / reflection touchpoints

Base of ScreenGui-family collectors (see [ScreenGui](ScreenGui.md), [PlayerGui](PlayerGui.md)); consumes [GuiService](GuiService.md) selection state and [ScrollingFrame](ScrollingFrame.md) visibility; Folder passthrough ([Folder](Folder.md)); input events arrive as [InputObject](InputObject.md).

## Gotchas

- Children of a GuiBase whose own ZIndex bucket was full/out-of-range are silently NOT rendered or hit-tested (the recursion happens inside the enqueue branch).
- Rebuild is lazy — mutations between frames are invisible until next render/process call; propertyConnections keyed by raw Instance*, disconnected in onDescendantRemoving.
- processDescendants returns on FIRST sink even if a higher-z element would later claim it (order is authoritative).
- The stuck-button release only handles BUTTON1/BUTTON2 and only when the down-object is still a descendant at release time.
- getGuiObjectsForSelection legacy path (flag off) treats ANY visible ancestor ScrollingFrame as sufficient, including ones unrelated to the candidate's own chain — fixed by DFFlag::FixClippedScrollingFrameNavigation (default true here).
