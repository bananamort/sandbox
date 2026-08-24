# App/include/v8datamodel/InputObject.h

## Purpose

`InputObject` Instance (INTERNAL) — the event payload for all script-visible input ("used in events found in UserInputService"): input type/state, position/delta, key codes (KeyCode + SDL scancode + mod codes + text), plus a large inline predicate family for event classification. Isolated node: forbids parents and children.

## Declared API

`class InputObject : public DescribedCreatable<InputObject, Instance, sInputObject, ClassDescriptor::INTERNAL>`

- `enum UserInputType` TYPE_MOUSEBUTTON1..3 (0–2), MOUSEWHEEL 3, MOUSEMOVEMENT 4, MOUSEIDLE 5 and MOUSEDELTA 6 (both commented "hold over from uievent, used internally (c++) only"), TOUCH 7, KEYBOARD 8, FOCUS 9, ACCELEROMETER 10, GYRO 11, GAMEPAD1..8 (12–19), TEXTINPUT 20, NONE 21 ("should always be last").
- `enum UserInputState { BEGIN=0, CHANGE=1, END=2, CANCEL=3, NONE=4 };`
- Constructors "for days": default, copy, and five typed ctors over (type, state, position[, delta|keycode|modcodes|scancode+inputText], DataModel*).
- Accessors: getUserInputType/setInputType; getSourceUserInputType/setSourceUserInputType (remapped-input provenance); getUserInputState/setInputState; getPosition/getRawPosition/get2DPosition/setPosition (position passes through GUI inset — private `getGuiInset()`); getDelta/setDelta; getKeyCode/setKeyCode; getScanCode/setScanCode; getInputText/setInputText; getModCodes/setModCodes; getWindowSize() → Vector2int16.
- Legacy public fields: `ModCode mod; char modifiedKey;` ("todo: remove these when we switch to other key struct").
- Classification (inline): isMouseEvent (+static IsMouseEvent), isKeyEvent, isTextInputEvent, isMouseDown/UpEvent, per-button Left/Right/Middle Down/Up, isMouseWheelEvent/Forward/Backward (sign of position.z), isKeyDownEvent/isKeyUpEvent (+KeyCode-filtered), isKeyPressedWithShift/CtrlEvent (+code), isTouchEvent, isGamepadEvent (.cpp), isScreenPositionEvent (mouse∪touch∪IDLE∪DELTA), isDPadEvent (gamepad D-pad KeyCodes), and .cpp text/navigation helpers: isTextCharacterKey, isCarriageReturnKey, isClearKey, isBackspaceKey, isDeleteKey, isEscapeKey, isUpArrowKey/isDownArrowKey/isLeftArrowKey/isRightArrowKey, isNavigationKey, isCtrlEvent, isAltEvent; also `bool isPublicEvent();`
- Tree rules: askSetParent false, askForbidParent true, askAddChild false, askForbidChild true.

## Gotchas

- Position is inset-adjusted; getRawPosition bypasses it — mixing them skews screen math.
- Mouse wheel direction rides position.z sign, not delta.
- MOUSEIDLE/MOUSEDELTA are internal-only types that still appear in classification helpers.
- Enum values are serialized/compared numerically across systems — append-only.

## UNKNOWN

- Exact GUI-inset source for position adjustment (.cpp).

## Cross-links

- Implementation: [App/v8datamodel/InputObject.md](../../v8datamodel/InputObject.md).
- Consumers: [UserInputService.md](UserInputService.md), [ContextActionService.md](ContextActionService.md), [Mouse.md](Mouse.md), [GuiService.md](GuiService.md).
