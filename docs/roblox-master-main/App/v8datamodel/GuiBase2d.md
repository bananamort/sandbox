# GuiBase2d.cpp

## Purpose

Implements `GuiBase2d` ("GuiBase2d") — the 2D GUI base: read-only AbsolutePosition/AbsoluteSize (float + rounded int twins), cascading resize/layout (`handleResize` propagates child rects only when own placement changed), recursive 2D rendering, and the rule that only GuiBase2d descendants may nest.

## Key types and API

Descriptors:
- `GuiBase2d::prop_AbsoluteSize("AbsoluteSize", category_Data, UI)` — Vector2 read-only.
- `prop_AbsolutePosition("AbsolutePosition", category_Data, UI)` — Vector2 read-only.
No Security:: arguments. Constants: `sGuiBase2d`; zIndex starts at `GuiBase::minZIndex2d()`, guiQueue=GUIQUEUE_GENERAL.

Behavior:
- `handleResize(viewport, force)` — recalcAbsolutePlacement (position THEN size, OR-ed); on change or force → children get `getChildRect2D()`.
- ResizeChildren special-cases Folder children by recursing THROUGH them ("no funny business" comment applies to askAddChild: GuiBase2d-only children) — Folders act as transparent layout pass-throughs.
- setAbsolutePosition/Size keep float + rounded copies; raise only when fireChangedEvent (default true).
- `recursiveRender2d` — render2d then visitChildren rendering GuiBase2d descendants.
- getRect2D uses INTS; getRect2DFloat exposes subpixel.

## Usage / reflection touchpoints

Ancestor of [GuiObject](GuiObject.md)/[ScreenGui](ScreenGui.md)/[SurfaceGui](SurfaceGui.md)/[BillboardGui](BillboardGui.md)-rendered trees; rendered from [PlayerGui](PlayerGui.md)/CoreGui pipelines.

## Gotchas

- Absolute props are computed during resize passes — reading them before first handleResize yields stale/identity values.
- Subpixel float values exist internally but scripts only ever see the ROUNDED ints via descriptors.
- A Folder between GUI nodes participates in resize but NOT in recursiveRender2d (only GuiBase2d children render) — GUI under a Folder inside a ScreenGui still renders because ResizeChildren recurses folders but RecursiveRenderChildren doesn't... actually rendering visits ALL children; the asymmetry is subtle and worth testing per-case.
