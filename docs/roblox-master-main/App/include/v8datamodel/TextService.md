# App/include/v8datamodel/TextService.h

## Purpose

`TextService` — INTERNAL_LOCAL non-creatable service wrapping the GfxBase typesetter layer: font/alignment enums (the Lua-facing FontSize/Font tables), conversion helpers to Text:: enums, per-font Typesetter registration, and the `GetTextSize` measurement entry point.

## Declared API

`class TextService : public DescribedNonCreatable<TextService, Instance, sTextService, Reflection::ClassDescriptor::INTERNAL_LOCAL>, public Service`

- Enums: `XAlignment {XALIGNMENT_LEFT=0, RIGHT=1, CENTER=2}`; `YAlignment {TOP=0, CENTER=1, BOTTOM=2}`; `FontSize {SIZE_8..SIZE_48 (0–9 contiguous), then SIZE_28=10, SIZE_32=11, SIZE_42=12, SIZE_60=13, SIZE_96=14; SIZE_SMALLEST=SIZE_8; SIZE_LARGEST=SIZE_96}` — in-header comment "ADD NEW FONT SIZES ABOVE HERE"; `Font {FONT_LEGACY=0, ARIAL=1, ARIALBOLD=2, SOURCESANS=3, SOURCESANSBOLD=4, SOURCESANSLIGHT=5, SOURCESANSITALIC=6, FONT_LAST=7}`.
- Static converters: `static Font FromTextFont(Text::Font)`; `static Text::Font ToTextFont(Font)`, `static Text::XAlign ToTextXAlign(XAlignment xalign)` (param named xalign even for Y variant), `static Text::YAlign ToTextYAlign(YAlignment xalign)`.
- Registry: `void registerTypesetter(Font font, shared_ptr<RBX::Typesetter>)`, `void clearTypesetters()` over private `boost::scoped_array<shared_ptr<Typesetter>> m_typesetters`; `Typesetter* getTypesetter(Font font)`.
- Measurement: `Vector2 getTextSize(std::string text, int fontSize, Font font, Vector2 frameSize)`.
- Ctor.

## Gotchas

- FontSize enum values are NOT proportional indices after SIZE_48 — 28/32/42/60/96 were appended later with explicit values (10–14); arithmetic on enum values is unsafe.
- getTextSize takes fontSize as raw int while registry is keyed by Font only.
- scoped_array sized by FONT_LAST presumably — adding a font requires updating FONT_LAST.

## UNKNOWN

- Behavior when no typesetter registered for a font (fallback vs assert).

## Cross-links

- Implementation: [App/v8datamodel/TextService.md](../../v8datamodel/TextService.md).
- Consumers: [GuiText.md](GuiText.md), [TextBox.md](TextBox.md), [TextLabel.md](TextLabel.md); typesetter engine: GfxBase/Typesetter.h.
