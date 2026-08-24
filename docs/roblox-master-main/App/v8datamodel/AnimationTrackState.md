# AnimationTrackState.cpp

## Purpose

Implements `AnimationTrackState` ("AnimationTrackState") — the DescribedNonCreatable per-track engine object that actually plays a KeyframeSequence: fade/weight interpolation, speed/phase bookkeeping, keyframe-crossing detection, loop/reverse handling, and replication of every play/stop/adjust as remote events.

## Key types and API

Remote events (all **Security::None**, REPLICATE_ONLY, BROADCAST):
- `"PlayAnimation"` ("gameTime","fadeTime","weight","speed") → onPlay
- `"StopAnimation"` ("gameTime","fadeTime") → onStop
- `"AdjustAnimationWeight"` ("gameTime","weight","fadeTime") → onAdjustWeight
- `"AdjustAnimation"` ("gameTime","speed") → onAdjustSpeed
- `"KeyframeReached"` ("keyframeName"), `"Stopped"` () — notifications.

Constants: `sAnimationTrackState`; local `autoStopFadeTime = 0.3f`.

Core state: startTime, fadeStart/EndTime, fadeStart/EndWeight, speed (1.0 default), phase, lastKeyframeTime, preKeyframe dedupe index, isPlaying, priority + priorityOverridden (default KeyframeSequence::CORE). Ctor locks parent (`lockParent()`).

Math:
- `getWeightAtTime(t)` — clamped linear lerp between fadeStart/EndWeight across [fadeStartTime, fadeEndTime].
- `getKeyframeAtTime(t)` — forward `(t-startTime)*speed+phase`; reverse uses duration-mirrored formula.
- `setKeyframeAtTime` nudges phase so speed changes never skip position (`onAdjustSpeed` reverses this to preserve keyframetime).
- `isStopped(t)` — past fade end AND fuzzy-equal zero weight.

Playback:
- `play/stop/adjustWeight/adjustSpeed` fire the matching replicated event with current game time; on* handlers mutate state (onPlay only accepts gameTime >= startTime — stale events ignored).
- `step(jointposes, time)` — `kfs->apply(jointposes, lastKeyframeTime, keyframetime, trackweight)`; non-looping tracks auto-stop with 0.3 s fade after firing the boundary keyframe name; looping tracks normalize time via `getDurationClampedKeyframeTime`.
- `detectKeyframeReached(animationTime, lastAnimationTime)` — loop-wrap fires last+first names in order; then scans mid keyframes direction-aware, one fire per step max (`break` after first hit), `preKeyframe` suppresses repeats.
- Reverse-play quirk: onPlay immediately fires the LAST keyframe's name ("automated animation detection does not detect the first keyframe" otherwise).
- Losing the Animator weak_ptr makes `getGameTime()` nuke the keyframeSequence ("shut.it.down") and return 0.

## Usage / reflection touchpoints

Driven by [AnimationTrack](AnimationTrack.md) (script façade) and [Animator](Animator.md) stepping; poses feed PoseAccumulator consumed like [Pose](Pose.md)/[KeyframeSequence](KeyframeSequence.md).

## Gotchas

- detectKeyframeReached fires at most ONE mid keyframe per step — fast-forwarded animations coalesce crossings into the single latest one.
- Stopped event fires inside onStop BEFORE isPlaying=false matters to callers; non-loop finish reuses the INTERNAL stop path deliberately ("easier to notice a problem with a non-stopped animation than a double fire").
- duration <= 0 disables auto-stop entirely (guard against empty sequences).
