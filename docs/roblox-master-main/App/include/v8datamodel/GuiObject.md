# App/include/v8datamodel/GuiObject.h

## Purpose

Core 2D GUI element base (`GuiObject`) plus its non-creatable intermediates `GuiButton` (clickable, styles, modal, verb hookup) and `GuiLabel` (leaf marker). GuiObject carries size/position as UDim2, rotation, colors/borders/transparency, clipping/dragging, tween engine, selection-image/gamepad navigation links, mouse/touch/gesture events with EventReplicator plumbing, and the render2d pipeline incl. scale-9 helpers.

## Declared API

`class GuiObject : public DescribedNonCreatable<GuiObject, GuiBase2d, sGuiObject>`

- Enums: `ImageScale {SCALE_STRETCH=0, SCALE_SLICED=1}`; `SizeConstraint {RELATIVE_XY=0, RELATIVE_XX=1, RELATIVE_YY=2}`; `TweenEasingDirection {EASING_DIRECTION_IN, EASING_DIRECTION_OUT, EASING_DIRECTION_IN_OUT}`; `TweenEasingStyle {EASING_STYLE_LINEAR, EASING_STYLE_SINE, EASING_STYLE_BACK, EASING_STYLE_QUAD, EASING_STYLE_QUART, EASING_STYLE_QUINT, EASING_STYLE_BOUNCE, EASING_STYLE_ELASTIC}`; `TweenStatus {TWEEN_CANCELED, TWEEN_COMPLETED}`.
- Tween structs: `Tween {UDim2 start/end; float elapsedTime/totalTime/delayTime; style+variance; callback<void(TweenStatus)>; isDone(); }`; `Tweens {scoped_ptr<Tween> sizeTween, positionTween; empty();}`
- Statics: `convertFontSize(TextService::FontSize)` inline mapping SIZE_8..SIZE_96 (RBXASSERT default 0).
- Ctor: `GuiObject(const char* name, bool active);` props `prop_Visible`, `prop_ZIndex`.
- Layout/appearance: Size/Position (UDim2), SizeConstraint, Rotation (float via RotationAngle) + AbsoluteRotation (Rotation2D, setter returns bool), BorderSizePixel, Draggable, Clipping, SelectionBox flag, BackgroundColor/BorderColor BrickColor views + Color3 twins, Visible/Active, Selectable ("whether a gamepad/keyboard can move the selection to this object"), BackgroundTransparency + legacy Transparency pair.
- Gamepad selection: NextSelection Up/Down/Left/Right get/set; SelectionImageObject get/set; `firstAncestorClipping()`.
- Dragging: handleDrag/handleDragging/handleDragBegin(Vector2|InputObject), private drag state + ended handler.
- Tween API: `tweenStep(double)`; tweenSizeAndPosition / tweenPosition ×3 overloads / tweenSize (style, variance, time, overwrite, Lua callback); Delay variants with raw callbacks (+optional TweenService*).
- Input: `canProcessMeAndDescendants() = getVisible()`; `process(InputObject)`; `processGesture(...)`; virtual pre-processors per device family — processTouchEvent/processMouseEvent(+Internal with fireEvents flag)/processKeyEvent/processGamepadEvent/preProcessMouseEvent — plus generic event firing and dedupe map `interactedInputObjects`.
- Signals: selection gained/lost; input began/changed/ended; gesture set — tap/pinch/swipe/longPress/rotate/pan; remote mouse events Enter/Leave/Moved/WheelForward/WheelBackward `(int,int)` each paired with DECLARE_EVENT_REPLICATOR_SIG; dragStopped `(int,int)` + dragBegin `(UDim2)` remotes with replicators.
- Overrides: askSetParent, onAncestorChanged, onPropertyChanged, `getPersistentDataCost() += 6`, recalculateAbsolutePlacement, getAbsolutePosition, render2d + legacyRender2d + renderSelectionFrame/renderStudioSelectionBox, process/processGesture, `virtual void checkForResize()`.
- Render internals: getRenderBackgroundAlpha/Color4, font-size scale helpers, render2dImpl ×2, render2dTextImpl ×2 (full alignment/wrap/stroke parameterization), render2dScale9Impl + Impl2, static Scale9Rect2D(rect, border, minSize), forceResize, mouseIsOver, isSelectedObject.
- Protected state: serverGuiObject flag (+virtual setServerGuiObject), clipping, guiState (WidgetState), size/position, rotation pair, constraint, border/colors/visible/active/selectable/transparency.

`class GuiButton : DescribedNonCreatable<..., GuiObject, sGuiButton>`

- `enum Style {CUSTOM_STYLE=0, ROBLOX_RED_STYLE, ROBLOX_GREY_STYLE, ROBLOX_BUTTON_ROUND_STYLE, ROBLOX_BUTTON_ROUND_DEFAULT_STYLE, ROBLOX_BUTTON_ROUND_DROPDOWN_STYLE};`
- Remote signals: MouseButton1Click/2Click `void()`, Down/Up ×2 `(int,int)`; matching replicators for all six.
- State: AutoButtonColor, Selected, Modal (prop_Modal), Style, Verb link (`setVerb(std::string)`, `getVerb()`), clicked flag + lastSelectedObjectEvent weak ref; scoped_array<GuiDrawImage> images (per-style skins).
- Overrides: isGuiLeaf → true, onPropertyChanged, all four process*Event handlers, getChildRect2D, setServerGuiObject, onServiceProvider; render2dButtonImpl; checkForSelectedObjectClick helper.

`class GuiLabel : DescribedNonCreatable<..., GuiObject, sGuiLabel>` — ctor + `isGuiLeaf() → true`.

## Gotchas

- Buttons are leaves: no GUI children under them by policy.
- Mouse-event replication only happens when scripts connect (EventReplicator count pattern).
- Drag state machine spans multiple objects/events (draggingEndedConnection) — leaks avoided only via that connection.
- getPersistentDataCost adds a flat 6 regardless of content.

## UNKNOWN

- Exact easing math per style (TweenInterpolate .cpp — see [GuiObject.md](../../v8datamodel/GuiObject.md)).

## Cross-links

- Implementation: [App/v8datamodel/GuiObject.md](../../v8datamodel/GuiObject.md).
- Base: [GuiBase2d.md](GuiBase2d.md); mixins [GuiMixin.md](GuiMixin.md), [GuiText.md](GuiText.md); concrete children Frame/TextBox/ImageButton/ImageLabel/ScrollingFrame docs; tweens consumer [TweenService.md] (T–Z half).
