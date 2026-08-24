# ScrollingFrame.cpp

## Purpose

Implements `ScrollingFrame` ("ScrollingFrame"), the scrollable GuiObject container: CanvasSize/CanvasPosition model, live scrollbar geometry (vertical + horizontal with corner handling), mouse-wheel acceleration, touch drag with velocity-sampled inertia, gamepad thumbstick/dpad scrolling that hands off to selection navigation at scroll limits, auto-scroll-to-selected-GuiObject, and custom scrollbar rendering from Top/Mid/Bottom images.

## Key types and API

Descriptors (category "Scrolling"):
- `prop_scrollingEnabled("ScrollingEnabled")` — bool, default true.
- `prop_canvasSize("CanvasSize")` — UDim2, default (0,0,2,0) [200% of frame].
- `prop_canvasPosition("CanvasPosition")` — Vector2; Lua setter routes through clamping (`luaSetCanvasPosition` → setCanvasPosition(value) WITH warnings).
- `prop_absWindowSize("AbsoluteWindowSize")` — Vector2 read-only (visible rect minus scrollbar gutters).
- `prop_scrollBarThickness("ScrollBarThickness")` — int, default 12, negative values clamp to 0 with MESSAGE_WARNING.
- `prop_topImage/midImage/bottomImage("TopImage"/"MidImage"/"BottomImage")` — TextureId defaults rbxasset://textures/ui/Scroll/*.png.

Constants: WHEEL_SCROLL_DELTA 10, MAX_SCROLL_WHEEL_SCROLL_PERCENT 0.10, MIN_SCROLLBAR_SIZE 1.0 (+2×thickness floor), REALLY_BIG_SCROLL_DELTA 1e7 (drag-past-edge fling), MAX_MULTIPLY_TIME_MSEC 250 (wheel accel window), DECELERATION_RATE 0.9/frame, TOUCH_INERTIA_RESET_TIME_MSEC 500, GAMEPAD_THUMBSTICK_WAIT_PERIOD_MSEC 300, GAMEPAD_SCROLL_CONSTANT 80.

DFFlags: LimitScrollWheelMaxToHalfWindowSize(false), FixRotatedHorizontalScrollBar(false).

Core mechanics:
- Positioning: `calculateCanvasPositionClamped` NaN-guards then clamps to [0, canvas−window] (+thickness when both bars visible); setCanvasPosition warns when clamped (unless printWarnings=false). `getCanvasRectLocal` sizes canvas vs PARENT GuiBase2d rect if any.
- Scrollability: canScroll{Vertical,Horizontal} = canvas > rect per axis. Bars shrink visible/clipped rects by thickness (getVisibleRect2D, getClippedRect −1 fudge).
- Per-frame (IStepped Render): inertia integration (`stepScrollInertia`: sampledVelocity × step, decay ×0.9 until ≤1), gamepad scroll (`stepGamepadScroll`: delta×80; on limit `trySelectGuiObject(−direction)` and zero delta), `recalculateScroll()` (dirty-flagged bar Rect2Ds).
- Input dispatch in `process`: INPUT_STATE_CANCEL or !scrollingEnabled ⇒ notSunk; clipped-rect hit test for inputOver; touch→doProcessTouchEvent (BEGIN claims touchInput, CHANGE samples {delta,dt} into an UNCAPPED per-gesture list — cleared at drag start, push_back per move, no 4-slot cap despite the constructor's initial size of 4 — and the inertia average runs over every sample), sinks while owned; gamepad→doProcessGamepadEvent (only navigation pad events AND only while this frame is the selected object; dpad maps to unit deltas; thumbstick axis-dominates; non-scrollable axis unsinks and defers to selection after 300ms grace); mouse→doProcessMouseEvent (bar-hit begins bar drag Y/X; wheel scrolls with sink; drag via handleInputDrag honoring scrollingDirection gating and off-edge REALLY_BIG_DELTA flings).
- Wheel acceleration: repeated wheel within 250 ms multiplies multiplier ×4 (first step ×2), capped at 10% canvas height (and half window height under flag); idle resets to 1.
- Selection auto-scroll: watches GuiService prop_selectedGuiObject/selectedCoreGuiObject; scrolls minimal delta to reveal selected descendant (taller-than-window objects snap by full height).
- Rendering: border-colored scrollbar track lines + three-image bars; horizontal bar reuses vertical textures rotated −90°; clipping computes UV sub-rects (rotation-aware under DFFlag FixRotatedHorizontalScrollBar).
- `hasInteractableDescendants`: first GuiButton/TextBox child counts (non-GuiObject matches recurse deeper).

## Usage / reflection touchpoints

Fully script-facing GUI workhorse. Pairs with PlayerGui.md, GuiObject.md, UserInputService.md, GamepadService.md, TextBox.md, GuiService.md in this folder.

## Gotchas

- CanvasSize default 2,0 scale means EVERY new ScrollingFrame is vertically scrollable out of the box.
- Lua CanvasPosition writes warn on clamp but engine-internal writes pass false — log noise only from scripts.
- Touch inertia averages EVERY delta sampled during the gesture (no ring cap) and resets entirely if finger released >500 ms after last move; long drags accumulate unbounded samples into the list until release.
- doProcessMouseEvent's wheel branch scrolls even when NOT over a scrollbar — any wheel over the frame scrolls it (inputOver gate only).
- Horizontal scrollbar drawn from VERTICAL textures rotated −90° — swapping textures without accounting rotation breaks appearance.
- hasInteractableDescendants returns true only for the FIRST button/textbox found per level (loop continues though) — nested-only-button trees recurse correctly but sibling order matters for which wins.
- UNKNOWN: SDLK_GAMEPAD_* enum values header-side; IStepped registration details.
