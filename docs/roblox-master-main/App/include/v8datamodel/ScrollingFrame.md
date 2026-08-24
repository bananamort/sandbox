# App/include/v8datamodel/ScrollingFrame.h

## Purpose

`ScrollingFrame` — creatable `GuiObject` (+ IStepped) implementing a scrollable canvas: CanvasSize/CanvasPosition, custom scroll-bar textures (top/mid/bottom per axis), mouse-wheel/touch-drag/gamepad scrolling with inertia (circular velocity buffer), bar geometry computation, and its own render2d for scrollbar drawing.

## Declared API

`class ScrollingFrame : public DescribedCreatable<ScrollingFrame, GuiObject, sScrollingFrame>, public IStepped`

- `enum ScrollingDirection { X = 1<<0, Y = 1<<1, XY = 1<<2 }` (note: XY is a distinct bit, not X|Y).
- Public API: `Rect2D getVerticalBarRect()/getHorizontalBarRect()` (inline); `setScrollingEnabled(bool)` + inline getter; inline `UDim2 getCanvasSize()` / `setCanvasSize(UDim2)`; inline `Vector2 getCanvasPosition()` with TWO setters — `luaSetCanvasPosition(Vector2)` and `setCanvasPosition(Vector2, bool printWarnings=true)`; `getScrollBarThickness()/setScrollBarThickness(int)`; texture trio `get/setTopImage`, `get/setMidImage`, `get/setBottomImage` (TextureId); `Vector2 getAbsoluteWindowSize() const`; `bool processInputFromDescendant(const shared_ptr<InputObject>& event)`; `bool isTouchScrolling()`; `bool hasInteractableDescendants()`.
- Overrides: GuiObject `getClippedRect()`, `process(InputObject)`, `getCanvasRect()`; Instance `onPropertyChanged`; GuiBase2d `handleResize(viewport, force)`, `render2d(Adorn*)`; IStepped `onStepped(const Stepped&)`; `onServiceProvider`.
- Private state (extensive): selection timer; SIX cached GuiDrawImages (v/h × top/mid/bottom) "need to keep a reference to all images to stop flickering"; TextureId trio; `scrollingEnabled`, `scrollBarThickness`, `canvasSize(UDim2)`, `canvasPosition(Vector2)`; drag/touch state (`lastInputPosition`, `scrollDragging`, `touchScrolling`, `scrollingDirection`), bar rects, `sampledVelocity`, `boost::circular_buffer<pair<Vector2,float>> touchInputPositions`, touch InputObject ref, mouse-down flags, `needsRecalculate`, `scrollDeltaMultiplier`, `lastGamepadScrollDelta`; four Fast-timers (wheel up/down, touch delta, selection); five scoped connections (inputEnded, guiService property changed, selection gained/lost).
- Private methods: input handlers `doProcessGamepadEvent/doProcessTouchEvent/doProcessMouseEvent(event, inputOver)`, `handleInputDrag(pos, event=shared_ptr())`, `handleInputBegin(pos, direction)`, wheel helpers + `getScrollWheelDelta(bool)`, `scrollByPosition(delta, printWarnings=false)`, `resizeChildren()`, device probes `hasMouse()/isTouchDevice()`, inertia `stepScrollInertia(Stepped)/setScrollInertia` (actual name `setScrollingInertia()`), gamepad `stepGamepadScroll(Stepped)`, geometry helpers (`canScrollVertical/Horizontal`, `renderScrollbarSection(adorn, drawImage, image, context, imageRect, rotation=Rotation2D())`, vertical/horizontal bar renderers, `getFrameScrollingSize/getCanvasScrollingSize`, `calculateCanvasPositionClamped(desired)`, bar size getters, `getCanvasRectLocal`, `canScrollInDirection(Vector2)`, `getMinScrollBarSize`, `getMaxSize`), `globalInputEnded(shared_ptr<Instance>)`, selection callbacks (`selectionLost/Gained`, `selectedGuiObjectChanged(desc)`), `renderScrollbarLines(adorn, scrollVertical, scrollHorizontal)`, `getVisibleRect2D`.

## Gotchas

- Two setter paths for CanvasPosition: the Lua path and the C++ path differ by warning behavior — semantics can diverge.
- ScrollingDirection.XY is bit 2 (value 4), NOT the combination X|Y (3) — bitmask code must handle it explicitly.
- Touch inertia depends on the circular position/time buffer + timers; stepping order (onStepped vs process) matters.
- Bar images cached deliberately to avoid flicker — swapping textures mid-render is not safe.

## UNKNOWN

- Exact clamp policy in calculateCanvasPositionClamped (out-of-line math).

## Cross-links

- Implementation: [App/v8datamodel/ScrollingFrame.md](../../v8datamodel/ScrollingFrame.md).
- Base: [GuiObject.md](GuiObject.md), [GuiBase2d.md](GuiBase2d.md); siblings: [Frame.md](Frame.md); gamepad selection source: [PlayerGui.md](PlayerGui.md), [GuiService.md](GuiService.md).
