# TextBox.cpp

## Purpose

Implements `TextBox` ("TextBox"), the editable text GuiObject: buffered-text editing model (cursor position, repeat-key state machine, word-backspace, paste), focus lifecycle with Humanoid typing state and nav-key suppression, mobile/touch/scroll-frame interop, gamepad A-button selection toggling, ContentFilter-gated rendering with blinking cursor.

## Key types and API

Descriptors:
- `prop_MultiLine("MultiLine")` — bool default false.
- `prop_ClearTextOnFocus("ClearTextOnFocus")` — bool default true.
- Funcs **Security::None**: "CaptureFocus()", "ReleaseFocus()", "IsFocused():bool".
- Events: "FocusLost(enterPressed:bool, inputThatCausedFocusLoss)", "Focused()".

DFFlags: DisplayTextBoxTextWhileTypingMobile(false), PasteWithCapsLockOn(false), TextBoxIsFocusedEnabled(false). CURSOR_BLINK_RATE_SECONDS 0.3. Text mixin via IMPLEMENT_GUI_TEXT_MIXIN; ctor names mixin "TextBox" with black text.

Focus model:
- `gainFocus(event)`: cursor→end, clear-on-focus wipes buffer; left-mouse-UP gain places cursor by click (`getCursorPos` half-split fallback); sets local Humanoid setTyping(true), DataModel gui target + `setSuppressNavKeys(true)`, fires Focused + UserInputService::textBoxGainFocus.
- `captureFocus()` (Lua): same as gainFocus minus the event — it sets `shouldCaptureFocus = true` and then IMMEDIATELY calls `gainFocus(nil)` anyway, so focus is taken now; the stale flag just causes a redundant second `gainFocus(event)` when the next key event arrives (processKeyEvent consumes it).
- `releaseFocus(enterPressed, input, contextCharacter)`: commits bufferedText → setText, typing(false), restores nav keys, FocusLost + textBoxReleaseFocus. externalReleaseFocus (from UserInputService mobile path) takes EXTERNAL text as final buffer.
- Ancestry change releases focus against the OLD parent context.

Input routing (preProcess): Workspace-descendant boxes return EMPTY response ("textbox on SurfaceGUIs under workspace won't accept user input"); TYPE_FOCUS END releases; mouse → preProcessMouseEvent (click-in gains, click-outside releases, sinks while focused); key → processKeyEvent (Escape releases; Enter releases-or-newline per MultiLine/selected-state; arrows/delete/backspace/clear/paste via keyDown/keyUp repeat machine; shift cancels repeat; un-focused-but-selected + RETURN captures); text-input events feed new-keyboard path; touch coordinates through ancestor ScrollingFrame first (suppresses focus when touch-scrolling); gamepad A on selected object toggles focus.

Edit engine (`doKey`): backspace deletes char or ctrl+word-walk (whitespace-skip then non-whitespace-skip); delete forward; character insert gated by Typesetter::isStringSupported; paste from UserInputService::getPasteText (non-repeating); arrows move cursorPos clamped. All mutations flush setText only when buffer changed.

Repeat machinery: onHeartbeat advances DEPRESSED→REPEATING after 0.5 s then 20 Hz repeats — SKIPPED ENTIRELY under UserInputService::IsUsingNewKeyboardEvents().

Rendering: blink toggle at 0.3 s; focused renders getTextWithCursor (buffered text + \1 sentinel inserted at clamped cursor).

## Usage / reflection touchpoints

Fully script-facing. Pairs with ScrollingFrame.md (processInputFromDescendant/isTouchScrolling), UserInputService.md, PlayerGui.md processing, SurfaceGui.md (workspace-descendant block).

## Gotchas

- IsFocused ERRORS to output and returns false unless its DFFlag is enabled — reflected but intentionally crippled in this build.
- Buffered-vs-committed split means scripts reading .Text during editing see the LAST COMMITTED text except under DisplayTextBoxTextWhileTypingMobile.
- doKey CHARACTER branch has duplicated `(cursorPos >= 0)` condition (second likely meant a length check).
- Word-backspace treats '\n' as whitespace for skipping but the whitespace scan can walk past string start guarded only by i>=0.
- captureFocus before provider attach leaves shouldCaptureFocus pending forever if no key event ever arrives.
