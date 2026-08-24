# App/include/v8datamodel/ScreenGui.h

## Purpose

`ScreenGui` — creatable `GuiLayerCollector`: a top-level 2D screen-space window (viewport-sized) that renders its GUI descendants, processes input/gesture routing, tracks a buffered viewport, and maintains modal-button bookkeeping. Also defines deprecated legacy `GuiMain` (a ScreenGui subclass).

## Declared API

`class ScreenGui : public DescribedCreatable<ScreenGui, GuiLayerCollector, sScreenGui>`

- Ctor/dtor; protected `ScreenGui(const char* name)` variant for subclasses.
- Replication shims: `void setReplicatingAbsoluteSize(Vector2int16)`, `setReplicatingAbsolutePosition(Vector2int16)` — push absolute geometry to replicas.
- Instance overrides: `askSetParent`, `onPropertyChanged(descriptor)`, `onDescendantAdded`, `onDescendantRemoving`, `onAncestorChanged(AncestorChanged&)`.
- IAdornable: inline `bool shouldRender2d() const { return renderable; }`, `render2d(Adorn*)`, `render2dContext(Adorn*, const Instance* context)`.
- GuiTarget: `/*override*/ GuiResponse process(const shared_ptr<InputObject>& event)`, `processGesture(UserInputService::Gesture, shared_ptr<const ValueArray> touchPositions, shared_ptr<const Tuple> args)`.
- GuiBase2d: `/*override*/ Vector2 getAbsolutePosition() const`.
- Viewport/modal: inline `const Rect2D& getViewport() const` (buffered); `bool hasModalDialog()`; `void onModalButtonChanged(const PropertyDescriptor*, GuiButton*)`; `bool canProcessMeAndDescendants() const`; `void setBufferedViewport(Rect2D newViewport)`.
- Private: `isAncestorRenderableGui()`, modal insert/remove helpers; state — `Rect2D bufferedViewport` ("grab on render (const - don't take action), resize on process"), `bool renderable`, `std::vector<GuiButton*> modalGuiObjects`, `boost::unordered_map<Instance*, rbx::signals::scoped_connection> connections`; `onServiceProvider` override.
- Header comment: "todo: remove HeartbeatInstance when FFlag::ResizeGuiOnStep is true" (HeartbeatInstance include retained).
- `extern const char* const sGuiMain;` + `class GuiMain : public DescribedCreatable<GuiMain, ScreenGui, sGuiMain>` — "Legacy GuiMain object, deprecated", ctor only.

## Gotchas

- Buffered-viewport discipline is explicit in the comment: render path must treat it as const; only process/input may resize.
- Modal tracking keeps raw GuiButton* plus per-instance scoped connections in a map — removal ordering bugs leak connections or dangling buttons.
- renderable depends on ancestor chain (isAncestorRenderableGui) — reparenting changes visibility.
- GuiMain is deprecated but still creatable/registered.

## UNKNOWN

- Which property changes trigger the replicating-absolute-size/position pushes (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/ScreenGui.md](../../v8datamodel/ScreenGui.md).
- Base chain: [GuiLayerCollector.md](GuiLayerCollector.md), [GuiObject.md](GuiObject.md), [GuiBase2d.md](GuiBase2d.md); containers: [PlayerGui.md](PlayerGui.md), [SurfaceGui.md](SurfaceGui.md).
