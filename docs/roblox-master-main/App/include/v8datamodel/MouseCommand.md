# App/include/v8datamodel/MouseCommand.h

## Purpose

Non-Instance engine class implementing interactive mouse tools (Studio tools and legacy in-game tools): receives input events from the world, may *capture* the mouse exclusively, returns the next handler from each event (state-machine hand-off), and provides static ray/picking helpers used across Studio and game code.

## Declared API

`class MouseCommand : public INamed, public IAdornable, public boost::enable_shared_from_this<MouseCommand>`

- Design comment block: "captured()" state = exclusive handling; World feeds onMouseXXX(); handlers return the MouseCommand for subsequent events; capture()/releaseCapture() allowed inside.
- Constant: `#define MAX_SEARCH_DEPTH (2048.0f)` with `static float maxSearch()`; log group `MouseCommandLifetime`.
- Static picking: `getUnitMouseRay(inputObject, ICameraOwner*)`, `getSearchRay(...)` ×2 (from event or unitRay); `getPart(Workspace*, event, filter=NULL, Vector3& hitWorld=ignoreVector3)`; `getPartByLocalCharacter(...same...)`; `Surface getSurface(Workspace*, event, filter)` + overload out-paraming part+surfaceId; instance versions of ray getters; member pickers `getUnlockedPart` / `getUnlockedPartByLocalCharacter`; `Instance* getTopSelectable3d(PartInstance*) const`.
- Static `getMousePart(unitRay, ContactManager&, ignore Primitive* | vector<const Primitive*>, filter, hitPoint=ignoreVector3, maxSearchGrid=maxSearch())` ×2 overloads.
- Event contract (protected virtuals): onMouseDown/onRightMouseDown/onKeyDown/onKeyUp/onMouseUp/onRightMouseUp/onMouseWheelForward/onMouseWheelBackward return `shared_ptr<MouseCommand>` — most default to `shared_from(this)` (self); `onMouseWheelForward`/`onMouseWheelBackward` default to null like the Peek variants; `onMouseUp` alone releases capture and returns null — ends chain; void hooks onMouseIdle ("called on heartbeat regardless of capture"), onMouseHover, onMouseMove, onMouseDelta.
- Capture: `virtual void capture(); virtual void releaseCapture(); virtual void cancel(); bool captured() const;`
- Character reach helpers: `bool characterCanReach(const Vector3& hitPoint) const; float distanceToCharacter(const Vector3&) const;`
- Tool identity: `virtual shared_ptr<MouseCommand> isSticky() const` (null), `virtual bool drawConnectors() const` (false), `virtual TextureId getCursorId() const` ("called on draw"); deprecated `getCursorName()` returning "advCursor-default" when adv-arrow enabled else "ArrowCursor".
- Qt-vs-MFC switch: static `enableAdvArrowTool(bool)/isAdvArrowToolEnabled()` — comment says these exist to protect MFC arrow behavior until Qt Studio is default and also toggle hardware cursor rendering.
- Misc: `static void predelete(MouseCommand*){}` (no-op hook); `Workspace* getWorkspace();` protected ctor `(Workspace*)`, friend Workspace; members workspace, lastHoverPart, `rightMouseClickPart` ("TODO:: REMOVE ME -- flag UsedFixedRightMouseClickBehaviour in NullTool.cpp"), capturedMouse; statics ignoreVector3 (default hit out-param!), advArrowToolEnabled.

## Gotchas

- The event return value IS the control-flow mechanism: returning another MouseCommand hands off the whole input stream; null after mouse-up terminates the tool.
- `ignoreVector3` static is the default argument binding for hit outputs — callers sharing that default share one Vector3 object.
- Global advArrowToolEnabled flips cursor rendering engine-wide.
- Non-refcounted raw `Workspace*` plus shared_from_this mixing: lifetime managed by Workspace.

## UNKNOWN

- Full list of concrete MouseCommand subclasses in tree (Tools live under App/tool headers).

## Cross-links

- Implementation: [App/v8datamodel/MouseCommand.md](../../v8datamodel/MouseCommand.md).
- Consumers: [Mouse.md](Mouse.md), [Commands.md](Commands.md) TToolVerb, [HandlesBase.md](HandlesBase.md)/[ManualJointHelper.md](ManualJointHelper.md), filters [Filters.h](Filters.md).
