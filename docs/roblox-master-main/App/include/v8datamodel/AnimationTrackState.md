# App/include/v8datamodel/AnimationTrackState.h

## Purpose

Engine-side playback state for one running animation (non-creatable Instance): owns the resolved `KeyframeSequence`, fade/weight/speed/phase math, keyframe-reached detection, priority, and per-frame pose accumulation via `step()`.

## Declared API

`class AnimationTrackState : public DescribedNonCreatable<AnimationTrackState, Instance, sAnimationTrackState>`

- Constructor: `AnimationTrackState(shared_ptr<const KeyframeSequence>, weak_ptr<const Animator> animator);` — sequence is "either set directly for solo/debugging or replicated by the AssetId".
- Playback: `void play(float fadeTime, float weight, float speed)`; `void stop(float fadeTime)`; `void adjustWeight(float weight, float fadeTime)`; `void adjustSpeed(float speed)`.
- Internal replication surface (comment: "Should be private"): six public `rbx::remote_signal`s — `internalPlaySignal<void(float,float,float,float)>`, `internalStopSignal<void(float,float)>`, `internalAdjustWeightSignal<void(float,float,float)>`, `internalAdjustSpeedSignal<void(float,float)>`, `keyframeReachedSignal<void(std::string)>`, `stoppedSignal<void()>`.
- Queries: `const KeyframeSequence* getKeyframeSequence() const`; `double getWeightAtTime(double)`; `double getKeyframeAtTime(double)`; `double getSpeed()`; `float getDuration()`; `bool isStopped(double time)`; `bool getIsPlaying() const`; `KeyframeSequence::Priority getPriority()/setPriority(...)`.
- Time/phase: `void setKeyframeAtTime(double gameTime, double keyframeTime)` ("adjust phase to get animation on a specific keyframe"); `double getDurationClampedKeyframeTime(double)`; `void resetKeyframeReachedDetection(double)`.
- Stepping: `void step(std::vector<PoseAccumulator>& jointposes, double time)` — the per-frame pose producer.
- Track binding: `void setAnimationTrack(shared_ptr<AnimationTrack>)` / `shared_ptr<AnimationTrack> getAnimationTrack() const`.
- Sequence swap: `void setKeyframeSequence(shared_ptr<KeyframeSequence>)`.

Protected state: `startTime, speed, phase` (speed-independent keyframe-time adjustment), `fadeStartTime/fadeStartWeight/fadeEndTime/fadeEndWeight`, `isPlaying`, `priority` + `priorityOverridden`, `lastKeyframeTime`, `int preKeyframe`; helpers `getGameTime()`, `onPlay/onStop/onAdjustWeight/onAdjustSpeed(float gameTime, ...)`, `inReverse()`, `detectKeyframeReached(double animationTime, double lastAnimationTime)`, `triggerKeyframeReachedSignal(const shared_ptr<Instance>& child, double minKeyframeTime, double maxKeyframeTime)`.

## Gotchas

- The internal* remote signals are the replication path; they are public in this drop despite the "Should be private" comment.
- Fade model is start/end weight+time pairs — weight interpolation happens between them during `step()`.
- Priority can be overridden (`priorityOverridden`) — setter semantics depend on that flag (.cpp).

## UNKNOWN

- Exact fade curve and weight-at-time formula (see implementation doc [AnimationTrackState.md](../../v8datamodel/AnimationTrackState.md)).

## Cross-links

- Implementation: [App/v8datamodel/AnimationTrackState.md](../../v8datamodel/AnimationTrackState.md).
- Lua wrapper: [AnimationTrack.md](AnimationTrack.md); owner: [Animator.md](Animator.md); data: [KeyframeSequence.md](KeyframeSequence.md), [Pose.md](Pose.md).
