# App/include/v8datamodel/GuiBase2d.h

## Purpose

Base for all Lua-bound 2D GUI ("A set of base functionality used by all Lua bound Gui objects"): absolute position/size bookkeeping with int+float twins, rect math, resize/recalculate traversal hooks, z-index + queue defaults, and recursive 2D rendering.

## Declared API

`class GuiBase2d : public DescribedNonCreatable<GuiBase2d, GuiBase, sGuiBase2d>`

- Reflection: `static PropDescriptor<GuiBase2d, Vector2> prop_AbsoluteSize; prop_AbsolutePosition;`
- Leaf test: `virtual bool isGuiLeaf() const { return false; }`
- Placement: `Vector2 getAbsolutePosition() const` / `bool setAbsolutePosition(const Vector2&, bool fireChangedEvent = true)`; same pair for AbsoluteSize; `Rect2D getRect2D() const` (comment muses about storage as Rect), `getRect2DFloat()`, virtuals `getChildRect2D()` (= float rect) and `getCanvasRect()` (= child rect).
- Layout: `virtual void handleResize(const Rect2D& viewport, bool force);` `virtual bool recalculateAbsolutePlacement(const Rect2D& viewport);`
- Instance override: `askAddChild(const Instance*)`.
- GuiBase implements: `canProcessMeAndDescendants() → true`, `getZIndex() → zIndex`, `getGuiQueue() → guiQueue`.
- IAdornable: `shouldRender2d() → false` ("explicit render traversal by ScreenGui or other"); `isVisible(rect) = rect.intersects(getRect2D())`.
- Protected: `recursiveRender2d(Adorn*)`, `setGuiQueue(GuiQueue)`, state `absolutePosition/absolutePositionFloat/absoluteSize/absoluteSizeFloat` (Vector2), `int zIndex`, `GuiQueue guiQueue`; private static `RecursiveRenderChildren(shared_ptr<Instance>, Adorn*)`.

## Gotchas

- Int vs Float absolute pairs coexist — rounding happens between them (.cpp); getRect2D uses ints, float variant for precision.
- shouldRender2d false at base: rendering is driven top-down by collectors, not per-instance.

## UNKNOWN

- Exact recalculation triggers/ordering on tree changes (.cpp — see [GuiBase2d.md](../../v8datamodel/GuiBase2d.md)).

## Cross-links

- Implementation: [App/v8datamodel/GuiBase2d.md](../../v8datamodel/GuiBase2d.md).
- Base: [GuiBase.md](GuiBase.md); children: [GuiObject.md](GuiObject.md), [ScreenGui.md](ScreenGui.md) (S–Z half), [BillboardGui.md](BillboardGui.md).
