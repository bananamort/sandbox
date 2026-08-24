# App/include/v8datamodel/AnimationTrack.h

## Purpose

`AnimationTrack` Instance (non-creatable) — the Lua-facing controller around an engine `AnimationTrackState`: play/stop/weight/speed/time-position controls, keyframe-reached and stopped events, priority, and duration queries. Created by `Animator::loadAnimation`.

## Declared API

`class AnimationTrack : public DescribedNonCreatable<AnimationTrack, Instance, sAnimationTrack>`

- Constructor: `AnimationTrack(shared_ptr<AnimationTrackState>, weak_ptr<Animator>, shared_ptr<Animation> anim);`
- Playback: `void play(float fadeTime, float weight, float speed)`; `void stop(float fadeTime)`; non-replicating variants `localPlay(...)`, `localStop(float)`.
- Adjustments: `void adjustWeight(float weight, float fadeTime)`; `void adjustSpeed(float speed)`; `void localAdjustSpeed(float)`.
- Queries: `float getLength() const`; `bool getIsPlaying() const`; `Animation* getAnimation() const`; `double getTimePosition() const`; `const std::string getAnimationName() const`; `double getTimeOfKeyframe(std::string keyframeName)`.
- Time: `void setTimePosition(double)`; local variant `localSetTimePosition(double)`.
- Priority: `KeyframeSequence::Priority getPriority() const` / `setPriority(KeyframeSequence::Priority)`.
- Signals: `rbx::signal<void(std::string)> keyframeReachedSignal;` `rbx::signal<void()> stoppedSignal;`
- Protected plumbing: forwards state signals via `forwardKeyframeReached(std::string)` / `forwardStopped()`; keeps `shared_ptr<AnimationTrackState>` alive (restart support), `weak_ptr<Animator>`, `shared_ptr<Animation>`; `double getGameTime() const`.

## Gotchas

- `play/stop/adjustSpeed/setTimePosition` replicate through the Animator; the `local*` variants do not — mixing them changes network behavior.
- Holds a *weak* Animator: after the Animator is destroyed, restart-capable playback silently fails.
- The class comment states its role explicitly: wrap AnimationTrackState for Lua interaction.

## UNKNOWN

- Fade-time semantics defaults (resolved in [AnimationTrack.md](../../v8datamodel/AnimationTrack.md) implementation doc).

## Cross-links

- Implementation: [App/v8datamodel/AnimationTrack.md](../../v8datamodel/AnimationTrack.md).
- Engine side: [AnimationTrackState.md](AnimationTrackState.md), [Animator.md](Animator.md).
