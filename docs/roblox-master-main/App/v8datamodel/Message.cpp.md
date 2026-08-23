# Message.cpp

## Purpose

Implements the legacy `Message` and `Hint` Instances — the pre-GuiObject way for scripts to put text on screen. `Message` renders as translucent gray overlay covering the whole screen minus a 100-pixel inset, with centered white text; `Hint` renders as a 20-pixel black strip across the top of the screen with centered white text. Both are `DescribedCreatable` classes registered under the names "Message" and "Hint".

## Key types and API

- `class Message : public DescribedCreatable<Message, Instance, sMessage>` where `sMessage = "Message"`; `class Hint` declared in the header (registered as `sHint = "Hint"`).
- Reflection block: single property `Text` (string, category_Appearance) backed by `getText`/`setText`.
- `void setText(const std::string& value)`: rejects text containing profanity outright (`ProfanityFilter::ContainsProfanity` — no change happens, not even truncation); otherwise truncates to `ContentFilter::MAX_CONTENT_FILTER_SIZE`, and if changed, updates `text`, resets `filterState` to `ContentFilter::Waiting`, raises `desc_Text` changed signal, and invokes the optional `gMessageSetTextCallback` hook.
- `const std::string& getText() const`: returns stored text, first invoking optional `gMessageGetTextCallback(text)` hook.
- `~Message()`: invokes optional `gMessageDtorCallback(this)`.
- `void render2d(Adorn*)` (Message): if text is non-empty, lazily resolves content-filter state via `ServiceProvider::create<ContentFilter>(this)->getStringState(text)`; only when state is `Succeeded` does it call `renderFullScreen(adorn)`.
- `void renderFullScreen(Adorn*)`: asserts filter Succeeded; draws a `Color4(0.5,0.5,0.5,0.5)` rect over `getUserGuiRect()` inset by 100 px and the text centered at 14pt FONT_LEGACY, XALIGN_CENTER/YALIGN_CENTER, white on black shadow.
- `void Hint::render2d(Adorn*)`: draws an opaque black 20px-tall strip along the top edge and centered 14pt white text; notably Hint performs NO content-filter wait/profanity recheck at render time beyond what setText already enforced.

Global function-pointer hooks (file-scope linkage, set by some other module): `gMessageSetTextCallback(const RBX::Message*)`, `gMessageGetTextCallback(const std::string& text)`, `gMessageDtorCallback(const RBX::Message*)`.

## Usage / reflection touchpoints

Standard descriptor pattern: `REFLECTION_BEGIN()/REFLECTION_END()` wrapping a `Reflection::PropDescriptor<Message, std::string> desc_Text("Text", category_Appearance, ...)`. That makes `Message.Text` / `Hint.Text` directly readable and writable from Lua scripts and serializable into place files. The class itself has no methods exposed to Lua beyond the property; rendering is engine-driven whenever the instance lives in a rendered container (historically placed under Workspace or Players as children). The callback pointers let an embedding app intercept text get/set/destruction without subclassing.

## Gotchas

- Setting Text to profane content is a silent no-op: no exception, no changed signal, old text remains.
- Message only paints after the asynchronous ContentFilter reaches Succeeded state; while Waiting it renders NOTHING (not even the gray box), so freshly-set text can flash late.
- The gray area is inset exactly 100 pixels from the full user GUI rect — not a proportionally scaled element.
- Hint trusts that setText already filtered; it never consults ContentFilter at draw time.
- These classes derive straight from `Instance` (not GuiBase2d), so they have none of the modern GuiObject properties (Position/Size/etc.); placement is hard-coded full-screen/top-strip.
- UNKNOWN: which module installs the three gMessage* callbacks and what they do (defined elsewhere; likely client UI plumbing).

UNKNOWN markers: callback install sites are outside this translation unit.
