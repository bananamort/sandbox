# App/include/v8datamodel/TweenService.h

## Purpose

`TweenService` — non-creatable service driving the legacy GuiObject tween system: keeps a set of weak_ptr<GuiObject> tweening targets, steps them on heartbeat/stepped, and queues status callbacks (fired with the TweenStatus they were registered for).

## Declared API

`class TweenService : public DescribedNonCreatable<TweenService, Instance, sTweenService>, public Service, public HeartbeatInstance, public IStepped`

- Ctor.
- Public: `void addTweeningObject(boost::weak_ptr<GuiObject> guiObject)`; `void addTweenCallback(boost::function<void(GuiObject::TweenStatus)>, GuiObject::TweenStatus tweenStatusForCallback)`.
- Protected: `typedef std::set<boost::weak_ptr<GuiObject>> TweeningObjectsList; TweeningObjectsList tweeningObjects;` overrides `onHeartbeat(const Heartbeat&)`, `onServiceProvider`.
- Private: `typedef std::vector<std::pair<callback fn, GuiObject::TweenStatus>> TweenCallbacks; TweenCallbacks tweenCallbacks;`; `void update(const double step)`; IStepped `virtual void onStepped(const Stepped&)`.

## Gotchas

- Targets held as weak_ptr in a std::set — ordering is by weak_ptr, not by gui identity; destroyed GUIs silently drop out.
- Callbacks are stored as (fn, expected-status) pairs and presumably invoked when update() produces the matching status — global queue shared by all tweens.
- Both onHeartbeat AND onStepped implemented — double-step integration; which one actually advances tweens is out-of-line.

## UNKNOWN

- GuiObject::TweenStatus enum values (declared in [GuiObject.md](GuiObject.md)'s header).

## Cross-links

- Implementation: [App/v8datamodel/TweenService.md](../../v8datamodel/TweenService.md).
- Tweened objects: [GuiObject.md](GuiObject.md); modern tween instances live elsewhere in this era.
