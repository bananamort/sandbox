# GuiObject.cpp

## Purpose

Implements `GuiObject` ("GuiObject") — the base class of all interactive 2D elements: UDim2 size/position/rotation layout with SizeConstraint, absolute-placement recalculation, background/border/scale-9 (slice) rendering, text rendering helpers, the mouse/touch/key/gamepad state machine (Gui::WidgetState), Draggable handling, generic InputBegan/Changed/Ended dispatch, tweening (TweenSizeAndPosition family with full easing math), server-GUI event replication, and gamepad-selection overrides. Also defines `GuiButton` ("GuiButton") — click events, Style skins, Modal, verb binding under VMProtect — and `GuiLabel` ("GuiLabel", inert).

## Key types and API

### GuiObject descriptors
- BoundFuncs (Security::None): `TweenSizeAndPosition(endSize,endPosition,easingDirection=Out,easingStyle=Quad,time=1,override=false,callback=nil) -> bool`, `TweenPosition(endPosition,...)`, `TweenSize(endSize,...)`.
- Props category_Data: Size, Position, BorderSizePixel (clamped 0..MAX_BORDER_SIZE_PIXEL=100), ZIndex (public static; setter clamps to minZIndex for RobloxScript-permission callers else minZIndex2d; always ≤ maxZIndex2d), Rotation (float), SizeConstraint (enum RELATIVE_XY default / RELATIVE_XX / RELATIVE_YY), BorderColor (BrickColor, LEGACY_SCRIPTING) + BorderColor3, BackgroundColor (LEGACY) + BackgroundColor3, BackgroundTransparency, Visible (public static prop_Visible), Active (ctor arg), Selectable (STANDARD), Transparency (LEGACY_SCRIPTING getTransparencyLegacy/setTransparencyLegacy).
- Props category_Behavior: Draggable, ClipsDescendants, NextSelectionUp/Down/Left/Right (RefPropDescriptor→GuiObject, STANDARD), SelectionImageObject (category_Appearance).
- RemoteEvents (SCRIPTING|CLIENT_SERVER, replicated both directions via IMPLEMENT/CONSTRUCT_EVENT_REPLICATOR): MouseEnter/MouseLeave/MouseMoved/MouseWheelForward/MouseWheelBackward (x,y ints), DragStopped(x,y)/DragBegin(initialPosition UDim2).
- Local EventDescs: touch gestures TouchTap/TouchPinch(scale,velocity,state)/TouchSwipe(direction,numberOfTouches)/TouchLongPress(state)/TouchRotate(rotation,velocity,state)/TouchPan(totalTranslation,velocity,state); generic input InputBegan/InputChanged/InputEnded(input Instance); SelectionGained/SelectionLost.
- Enums registered here: EasingDirection{In,Out,InOut}, EasingStyle{Linear,Sine,Back,Quad,Quart,Quint,Bounce,Elastic}, TweenStatus{Canceled,Completed} (+Variant/StringConverter templates).
- Flags: DFFlag::ElasticEasingUseTwoPi(false), DFFlag::TurnOffFakeEventsForInputEvents(false), FFlag::TweenCallbacksDuringRenderStep(false), FFlag::FixSlice9Scale(true).

Behavior highlights:
- Layout: recalculateAbsolutePlacement composes parent rotation, applies getConstrainedSize(parentViewport,sizeConstraint) to scale part, rotates element CENTER around parent origin; checkForResize walks up through Folder chains ([Folder](Folder.md) transparent) to nearest GuiBase2d canvas; forceResize = handleResize(...,true).
- getAbsolutePosition subtracts [GuiService](GuiService.md) globalGuiInset.
- State machine processMouseEventInternal(fireEvents): fires enter/moved/wheel/leave from transitions; records lastDownGuiObject on BUTTON1/2 down-over into UserInputService; drives Gui::{NOTHING,HOVER,DOWN_OVER,DOWN_AWAY} table keyed by button type mismatch too; returns notSunkMouseWasOver when over+Active.
- fireGenericInputEvent: key events skipped ("todo"), non-public events skipped, fake-mouse-on-touch skipped when !mouseEnabled&&touchEnabled; BEGIN→InputBegan+track, CHANGE→synthesize Began if unseen else Changed, END→InputEnded+untrack (interactedInputObjects map keyed by event shared_ptr).
- Dragging (Active+Draggable): mouse path requires mouseEnabled&&!touchEnabled; touch path always; dragBeginSignal on down-over; draggingEnded (via UserInputService coreInputEndedEvent) emits dragStoppedSignal inset-corrected and clears state.
- Tweens: tweenPositionDelay/tweenSizeDelay create Tweens{start,end,totalTime,delayTime,style,variance,callback}; overwrite=false returns false if active; canceled callbacks deferred to Write-thread task or TweenService::addTweenCallback under TweenCallbacksDuringRenderStep; tweenStep driven by TweenService. TweenInterpolate implements all 8 styles ×3 directions inline; Elastic uses piHalf or twoPi per flag (IN_OUT period ×1.5).
- isCurrentlyVisible: visible AND nonzero rect AND survives firstAncestorClipping intersection AND intersects screen rect offset by guiInset AND parent chain recurses until ScreenGui (returns true) — anything else false. Comment shows author confusion ("-Erik").
- render2dImpl draws bg alpha>0 only, border via outlineRect2d; clipping ancestor forces intersect clip unless rotated; Scale9Rect2D/computeScale9Sizes(2) implement 9-slice with FixSlice9Scale fixing corner scaling formula; render2dTextImpl handles smooth-scaling autoScale binary-search font fit (getScaledFontSize) and alignment; renderStudioSelectionBox 1px-expanded blue outline when selectionBox set; renderSelectionFrame temporarily re-poses SelectionImageObject onto this object's rect (inset-aware both directions).
- setServerGuiObject: flips replication listeners ON only for events that have Lua listeners (server watches local listeners); called from onAncestorChanged when Network::Players::serverIsPresent.

### GuiButton descriptors
- `SetVerb(verb)` — Security::RobloxScript. RemoteEvents MouseButton1Click/MouseButton2Click (no args), MouseButton1Down/Up, MouseButton2Down/Up (x,y). Props: AutoButtonColor, Selected, Modal (public static prop_Modal), Style enum {Custom, RobloxButtonDefault(red), RobloxButton(grey), RobloxRoundButton, RobloxRoundDefaultButton, RobloxRoundDropdownButton} (EnumDesc "ButtonStyle").
- ctor sets selectable=true. render2dButtonImpl picks btn_grey/red/newGrey/newBlue/newWhite (+Glow variants) textures by style/state with scale-9 corners (8×8 min36 for classic, 6×6 min20 round); AutoButtonColor CUSTOM lerps toward black(0.3 hover/down-away)/white(down-over).
- checkForSelectedObjectClick: if this == GuiService selected object, Enter key or gamepad A synthesizes Down/Up/Click at rect center; click executes bound Verb via Verb::doItWithChecks under VMProtectBeginMutation.
- setVerb: VMProtect-wrapped; Studio build uses workspace->getVerb, client uses getWhitelistVerb; a whitelist verb with getVerbSecurity() true trips RBX::Security::setHackFlagVmp<LINE_RAND4>(hackFlag10, HATE_VERB_SNATCH) and nulls the verb (anti-cheat: memory-tamper detection). Deferred via verbToSet until onServiceProvider.
- processMouseEvent: click semantics require wasDownOver && shouldFireClickedEvent; GuiButton::processTouchEvent defers to ancestor ScrollingFrame::processInputFromDescendant and suppresses Click during touch scrolling.

GuiLabel: DescribedNonCreatable<...,GuiObject>("GuiLabel", active=false), no members/descriptors.

## Usage / reflection touchpoints

Base of Frame/TextLabel/TextBox/ImageLabel/ImageButton/ScrollingFrame etc.; collector layer in [GuiLayerCollector](GuiLayerCollector.md); selection state owned by [GuiService](GuiService.md); tweens ticked by [TweenService](TweenService.md) (TweenService.h include); insets from GuiService::getGlobalGuiInset; verbs from [Workspace](Workspace.md); includes VMProtect SDK.

## Gotchas

- ZIndex clamp asymmetry: RobloxScript context may use level 0..maxZIndex2d? No — script tier gets minZIndex() floor (can go LOWER than user tier's minZIndex2d()); both cap at maxZIndex2d().
- Transparency (legacy float) coexists with BackgroundTransparency — LEGACY_SCRIPTING hides it from new scripts but serialization still hits it.
- GuiButton::render2dButtonImpl calls setBackgroundTransparency(0.0f) as a side effect of RENDERING skinned buttons — a skin silently overrides authored transparency every frame.
- mouseEnter/Leave coordinates are raw event positions; dragStoppedSignal subtracts guiInset but dragBeginSignal(getPosition()) does not add it back — mixed coordinate spaces across the pair.
- shouldFireClickedEvent is reset at the top of EVERY processTouchEvent; only ScrollingFrame-scrolling suppresses clicks.
- computeScale9Sizes (v1, used by legacy render2dScale9Impl) assumes texture thirds (0.33333f UVs) regardless of actual slice size; v2 (FixSlice9Scale) is the corrected slice-aware path used by render2dScale9Impl2.
- fireGenericInputEvent has a redundant nested guard (`!DFFlag::TurnOffFakeEventsForInputEvents || event->isPublicEvent()` inside an already-public-only function) — flag currently cannot change behavior there.
- GuiObject::processKeyEvent/processGamepadEvent base implementations are no-op notSunk; only GuiButton adds Enter/A handling.
- UNKNOWN: where selectionBox is set true (Studio tooling outside this file); exact listener-mode wire format of the event replicators (macro-defined elsewhere).
