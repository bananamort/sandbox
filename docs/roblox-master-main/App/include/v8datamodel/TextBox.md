# App/include/v8datamodel/TextBox.h

## Purpose

`TextBox` — creatable `GuiObject` + GuiTextMixin + HeartbeatInstance implementing editable text: focus capture/release, cursor position + blink (heartbeat), key repeat state machine (backspace/delete/paste/character/arrows), multiline support, clear-text-on-focus, buffered text, and the full input-event override set.

## Declared API

`class TextBox : public DescribedCreatable<TextBox, GuiObject, sTextBox>, public GuiTextMixin, public HeartbeatInstance`

- Signals: `rbx::signal<void(bool, const shared_ptr<Instance>)> focusLostSignal`, `rbx::signal<void()> focusGainedSignal`.
- Focus API: `void captureFocus()`; `void externalReleaseFocus(const char* externalReleaseText, bool enterPressed, const shared_ptr<InputObject>&)`; `void releaseFocusLua()`; `void releaseFocus(bool enterPressed, const shared_ptr<InputObject>&, Instance* contextLocalCharacter=NULL)`; `bool getFocused()`.
- Text: inline `std::string getBufferedText() const`; `void setBufferedText(std::string value, int newCursorPosition)`; inline `getMultiLine()/setMultiLine(bool)`; inline `getClearTextOnFocus()/setClearTextOnFocus(bool)`; `onPropertyChanged(desc)`.
- Overrides: GuiObject `process/preProcess(InputObject)`; protected input split `processTextInputEvent/processKeyEvent/processGamepadEvent/processMouseEvent/processTouchEvent/preProcessMouseEvent` (all → GuiResponse); IRenderable `render2d(Adorn*)`; HeartbeatInstance `onHeartbeat(const Heartbeat&)`; Instance `onServiceProvider/onAncestorChanged`.
- Private machinery: focus flags (`shouldCaptureFocus/iAmFocus/showingCursor/clearTextOnFocus/shouldFocusFromInput`), `bufferedText`, blink timer `lastSwap`, `int cursorPos` ("character the cursor should be drawn after"); nested `RepeatKeyState {enum KeyType{TYPE_BACKSPACE,TYPE_DELETE,TYPE_PASTE,TYPE_CHARACTER,TYPE_LEFTARROW,TYPE_RIGHTARROW}; KeyType; KeyCode; char character; enum RepeatState{NONE,DEPRESSED,REPEATING}; double stateWallTime; state}`; doKey ×2 / keyUp/keyDown/textInput; hit-testing `getCursorPos(Vector2 mousePos)`; focus handlers gainFocus/setFocusLost(enterPressed, input); render helpers `getTextWithCursor()/getTextWithBlankCursor()`; paste detection `isPasteCommand(event)`; `selectionToggled(event)`; textBoxFinishedEditingConnection.
- Macro tail: `DECLARE_GUI_TEXT_MIXIN();`

## Gotchas

- Text edits land in `bufferedText` first — commit semantics to the Text property are event-driven (focus loss/enter), so property reads may lag typing.
- RepeatKeyState is a hand-rolled OS-style key-repeat engine with wall-clock timing — behavior differs from native text fields.
- externalReleaseFocus carries a replacement text parameter — callers can inject final text on forced blur.

## UNKNOWN

- Which property changes reset buffering in onPropertyChanged (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/TextBox.md](../../v8datamodel/TextBox.md).
- Base: [GuiObject.md](GuiObject.md); text mixin: [GuiText.md](GuiText.md); button sibling: [TextButton.md](TextButton.md).
