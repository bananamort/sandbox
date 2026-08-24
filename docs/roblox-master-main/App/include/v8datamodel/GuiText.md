# App/include/v8datamodel/GuiText.h

## Purpose

`GuiTextMixin` — reusable text state + getters for text-bearing GUI elements, plus the `DECLARE_GUI_TEXT_MIXIN()`/`IMPLEMENT_GUI_TEXT_MIXIN(Class)` macro pair stamping in the full Text property surface (Text, FontSize, Font, TextColor/3, TextTransparency, Wrapped/legacy TextWrap, TextScaled, X/YAlignment, read-only TextBounds/TextFits, stroke color/transparency) with guarded setters, profanity/content-filter gating, bounds invalidation, and typesetter-backed measurement helpers.

## Declared API

`class GuiTextMixin`

- Ctor `(const std::string& text, const Color3& textColor)` defaults: SIZE_8, transparency 0, no wrap/scale, filterState Waiting, center alignment ×2, FONT_LEGACY, stroke transparency 1.0 black.
- Getters: getText (const ref), getFontSize/getFont (enums), getTextColor → BrickColor::closest(textColor), getTextColor3, getTextTransparency, getTextStrokeTransparency, getTextStrokeColor3, getTextWrap, getTextScale, getXAlignment, getYAlignment.
- Protected render helpers: `getRenderTextAlpha(transparency)` = clamp(1−t), `getRenderTextColor4()`, `getRenderTextStrokeColor4()`.
- State: filterState (ContentFilter::FilterResult), text, fontSize, textColor, textTransparency, textStrokeColor/Transparency, textWrap/textScale, x/yAlignment, font.

Macro-declared per class (`DECLARE_GUI_TEXT_MIXIN()`): checkForResize override; setters setText/setFontSize/setFont/setTextColor(BrickColor)/setTextColor3/setTextTransparency/setTextStrokeTransparency/setTextStrokeColor3/setTextWrap/setTextScale/setXAlignment/setYAlignment; queries `int getPosInString(Vector2 cursorPos) const`, `Vector2 getTextBounds() const`, `bool getTextFits() const`; setTransparencyLegacy override; getPersistentDataCost override.

Macro-implemented behavior (`IMPLEMENT_GUI_TEXT_MIXIN(Class)`):
- REFLECTION_BEGIN/END registers: prop_Text ("Text"), prop_FontSize, prop_Font, prop_TextColor (LEGACY_SCRIPTING), prop_TextColor3, prop_TextTransparency, prop_TextWrapped + deprecated alias prop_depTextWrap ("TextWrap", UI-deprecated), prop_TextScale ("TextScaled"), prop_TextXAlignment/prop_TextYAlignment, read-only UI props prop_TextBounds and prop_TextFits, stroke pair.
- setText truncates beyond ContentFilter::MAX_CONTENT_FILTER_SIZE, skips when ProfanityFilter::ContainsProfanity unless RobloxLocked, resets filterState to Waiting on change, raises Text/TextBounds (+TextFits only when fit flips).
- All setters no-op when unchanged; layout-affecting ones also raise TextBounds (and conditionally TextFits).
- setTextScale(true) force-enables wrapping; disabling re-raises bounds/fits.
- setTextColor(BrickColor) forwards to setTextColor3.
- setTransparencyLegacy forwards to both text and Super (background).
- getTextBounds/getTextFits/getPosInString run only under frontend processing (`Network::Players::frontendProcessing`) via `ServiceProvider::create<TextService>(this)` → `getTypesetter(font)` measuring against rect (wrap-aware); return zero/false/−1 otherwise. getPosInString seeds cursor origin from alignment then calls `typesetter->getCursorPositionInText(... absoluteRotation ...)`.
- getPersistentDataCost = super + computeStringCost(getText()).

## Gotchas

- Text changes are *silently dropped* if the profanity filter flags them (except engine-locked objects) — no error channel.
- Measurement returns zeros off the main/frontend path — server-side reads of TextBounds are meaningless.
- Deprecated "TextWrap" descriptor coexists with "TextWrapped" pointing at the same storage.

## UNKNOWN

- Where async content filtering completes and updates filterState (.cpp consumers).

## Cross-links

- Kin mixin: [GuiMixin.md](GuiMixin.md); base [GuiObject.md](GuiObject.md); measurement infra [TextService.md](TextService.md).
