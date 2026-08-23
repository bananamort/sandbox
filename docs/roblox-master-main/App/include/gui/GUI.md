# App/include/gui/GUI.h

## Purpose

Declares the immediate-mode 2D GUI framework used for in-engine menus/HUDs (Studio-era UI drawn via `Adorn`): `GuiItem` — the Instance-derived base with focus handling, layout, and input dispatch (`process`); `GuiRoot` — top-level container registered as INTERNAL_LOCAL/LocalUser security; `TopMenuBar`, `RelativePanel`; the state-machine-driven `UnifiedWidget` (menu/button hybrid, ancestor of ChatButton etc.); and `TextDisplay` for labeled text. Complements the datamodel GuiObjects (GuiObject.h) — these classes are engine-internal chrome, not scriptable place content.

## Declared API

- `extern const char* const sGuiItem;` `class GuiItem : DescribedNonCreatable<GuiItem, Instance, sGuiItem>`
  - Focus: private `shared_ptr<GuiItem> focus`, `getFocus()`, `loseFocus()`, virtuals `onLoseFocus()`, `bool canLoseFocus()` (default false), `switchFocus(item)`; `onDescendantRemoving` clears stale focus.
  - Layout: `Rect getMyRect(Canvas)` / `getMyRect2D(Canvas)`; virtual `Vector2 getPosition(Canvas)` (asks gui parent), virtual `getChildPosition(child, canvas)` (asserts if used unoverridden), virtual `getSize(Canvas)` = guiSize, `setGuiSize/getGuiSize`.
  - Virtuals: `int getFontSize()` (12), `bool isVisible()` (true), `std::string getTitle()` (=name), `virtual void render2d(Adorn*) {}`, `virtual GuiResponse process(const shared_ptr<InputObject>&)`.
  - Helpers: `label2d(adorn, label, fill, border, XAlign=LEFT)`; static colors `disabledFill()`, `translucentBackdrop()`, `translucentDebugBackdrop()`, `menuSelect()`.
  - Tree: `addGuiItem(shared_ptr<GuiItem>)` (parents it), `getGuiParent()` ×2 const-ness, `getGuiItem(index)` ×2.
  - Rules: `askAddChild` accepts only other GuiItems; `getClassName()` returns null name (noncreatable).
- `extern sGuiRoot; class GuiRoot : Reflection::Described<GuiRoot, sGuiRoot, GuiItem, INTERNAL_LOCAL, Security::LocalUser>` — `render2d(Adorn*)`, `render2dItem(adorn, item)`, getSize asserts (top-level), `askSetParent` always true.
- `class TopMenuBar : GuiItem` — ctors `()`, `(title, Layout::Style, translucentBackdrop=false)`, `(title, style, Color4 backdropColor)`; fields `backdropColor`, `layoutStyle`, `visible`; overrides `getChildPosition/process/render2d/getSize/isVisible`; `setVisible(bool)`.
- `class RelativePanel : TopMenuBar` — `xLocation/yLocation (Rect::Location)`, `Vector2int16 offset`; ctor from `Layout`; virtual `getPosition(Canvas)`.
- `class UnifiedWidget : GuiItem` — `enum MenuState {NOTHING, HOVER, SHOWN_APPEARING, SHOWN}`; per-state input processors (`processNothing/processHover/processShown*/processKey`), `render2dChildren`, protected `showChildren()`, hooks `onMenuStateChanged()`, `firstChildPosition(Canvas)`, `childOffset()`, `render2dMe(Adorn*)` (render your own body); public `getMenuState/setMenuState`, `process`, `render2d`; canLoseFocus true; fontSize 8.
- `class TextDisplay : GuiItem` — protected fields `label`, `fontSize`, `fontColor`, `borderColor`, `align (Text::XAlign)`, `visible`; setters `setLabel/setFontSize (resizes to fontSize*10 × fontSize*2)/setFontColor/setBorderColor/setAlign/setVisible`; overrides `render2d`, `getSize`.

## Usage notes

- Build UI trees by adding GuiItem children under a GuiRoot, override `render2dMe`/`process` for custom widgets, and route all InputObjects through the root's `process`.

## Gotchas

- `getChildPosition` base implementation RBXASSERTs — any composite widget must override it or child positioning is invalid.
- `UnifiedWidget::setMenuState` drives hover/appear animation states; direct manipulation outside process() can fight the state machine.
