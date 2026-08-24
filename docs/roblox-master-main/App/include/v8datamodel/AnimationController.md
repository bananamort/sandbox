# App/include/v8datamodel/AnimationController.h

## Purpose

`AnimationController` Instance ("AnimationController") — legacy script-facing wrapper that lazily owns an internal `Animator`, forwarding `loadAnimation`/track queries to it and stepping it per frame. Predates the modern `Animator` API.

## Declared API

`class AnimationController : public DescribedCreatable<AnimationController, Instance, sAnimationController>, public IStepped`

- `AnimationController(); virtual ~AnimationController();`
- `shared_ptr<Instance> loadAnimation(shared_ptr<Instance> animation);`
- `shared_ptr<const Reflection::ValueArray> getPlayingAnimationTracks();`
- Local signal: `rbx::signal<void(shared_ptr<Instance>)> animationPlayedSignal;`
- Private: `shared_ptr<Animator> animator; Animator* getAnimator();` (lazy creation), overrides `askSetParent(const Instance*) const`, `onServiceProvider(ServiceProvider*, ServiceProvider*)`, IStepped `onStepped(const Stepped&)`.

## Gotchas

- The wrapper holds a shared_ptr to its Animator, so the engine object outlives script expectations unless the controller is destroyed.
- All real playback logic lives in [Animator](Animator.md); this class only delegates — no play/stop surface of its own in this drop.
- Commented-out forward declarations (`Workspace`, `Primitive`, `PartInstance`) hint at an older, larger interface.

## UNKNOWN

- Exact parent-placement rules enforced by `askSetParent` (.cpp).

## Cross-links

- Implementation: [App/v8datamodel/AnimationController.md](../../v8datamodel/AnimationController.md).
- Engine side: [Animator.md](Animator.md), [AnimationTrack.md](AnimationTrack.md).
