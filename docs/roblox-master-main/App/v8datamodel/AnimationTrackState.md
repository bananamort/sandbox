# App/v8datamodel/AnimationTrackState.cpp

## Purpose

Implements `AnimationTrackState` ("AnimationTrackState") — the engine-side playback state machine for one animation track: fade curves, speed/phase, keyframe-crossing detection, and the REPLICATE_ONLY BROADCAST remote events that keep track state consistent across peers. Non-creatable; created only by Animator.

## API

Reflection (all Security::None, REPLICATE_ONLY, BROADCAST):
- `"PlayAnimation"(gameTime, fadeTime, weight, speed)` → internalPlaySignal → onPlay.
- `"StopAnimation"(gameTime, fadeTime)` → onStop.
- `"AdjustAnimationWeight"(gameTime, weight, fadeTime)` → onAdjustWeight.
- `"AdjustAnimation"(gameTime, speed)` → onAdjustSpeed.
- `"KeyframeReached"(keyframeName)` — replicated from keyframe detection.
- `"Stopped"()` — fired inside onStop.

State/maths: ctor `(shared_ptr<const KeyframeSequence>, weak_ptr<const Animator>)` initializes fades to 0, speed 1.0, priority CORE (`priorityOverridden=false`) and calls `lockParent()`; `play/stop/adjustWeight/adjustSpeed` are thin wrappers firing the corresponding event with current game time; `onPlay` resets phase=0, sets fade window `[startTime, startTime+fadeTime]`, marks isPlaying, and if playing in reverse immediately fires KeyframeReached for the last child; `isStopped(time)` = past fadeEnd and fuzzy-equal zero end weight; `getWeightAtTime` linear-lerp fade interpolation; `getKeyframeAtTime(time)` = `(time-startTime)*speed+phase` (reverse formula negated); `setKeyframeAtTime(gameTime, kfTime)` adjusts phase by delta; `getDuration()` from KeyframeSequence; `getPriority()/setPriority()` — override semantics: explicit set wins forever (`priorityOverridden=true`), else sequence's priority, else CORE; `step(vector<PoseAccumulator>& jointposes, double time)` — applies the sequence pose deltas via `kfs->apply(...)`, auto-stops non-looping animations at the last frame with `autoStopFadeTime = 0.3f` (firing the final KeyframeReached first); for loops normalizes time modulo duration; then `detectKeyframeReached(normKeyframeTime, lastKeyframeTime)`: fires wrap-around keyframe pairs on loop crossing, then at most one mid keyframe per step in traversal order (dedup via `preKeyframe` index).

## Usage

Owned by Animator (`activeAnimations` list); stepped once per Stepped per priority bucket. AnimationTrack forwards these signals outward to Lua as its own KeyframeReached/Stopped.

## Gotchas

- All replication is by absolute game time — receivers ignore stale events (`if(gameTime >= startTime)` guard in onPlay).
- Auto-stop fires Stopped *and* mutates local fade state through onStop directly (not the replicated event), so the final fade-out is deterministic locally.
- Only one mid keyframe fires per step even if several were crossed (break after first hit).
- If the animator weak ref dies, getGameTime resets the keyframeSequence ("We've lost our animator, shut.it.down") and returns 0.
