# App/include/gui — Index

Legacy (2003–2008) in-engine 2D GUI layer: the `GuiItem`/`Adorn` rendering base (`GUI.h`/`GuiDraw.h`), input-processing widgets (`Widget`, `ChatWidget`, chat bubbles via `ChatOutput`), layout/scaling helpers, and the profanity filter. This is distinct from the DataModel-side GuiObject hierarchy under `v8datamodel/` — these classes render and consume input; they are not replicated instances.

## Files

- [ChatOutput.md](ChatOutput.md) — ChatLine records + ChatOutput GuiItem: FIFO log and per-character billboard chat bubbles.
- [ChatWidget.md](ChatWidget.md) — unified image/text widgets for chat entry UI.
- [EquationDisplay.md](EquationDisplay.md) — widget for rendering equations.
- [GUI.md](GUI.md) — GuiItem base class, focus/state machinery.
- [GuiDraw.md](GuiDraw.md) — 2D drawing primitives on Adorn canvases.
- [GuiEvent.md](GuiEvent.md) — input event plumbing for GUI items.
- [Layout.md](Layout.md) — plain struct: anchors, offset, flow style, backdrop color.
- [ProfanityFilter.md](ProfanityFilter.md) — encrypted word list + scoped-singleton ContainsProfanity check.
- [ScoreHud.md](ScoreHud.md) — empty aggregation header (no declarations).
- [Widget.md](Widget.md) — standard interactive widget base routing process() into overridable hooks.

## Related

- `../script/` — Lua-facing GUI APIs live with the scripting subsystem.
- `../../v8datamodel/` — replicated GuiObject/ScreenGui instance classes.
