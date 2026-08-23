# App/v8datamodel/AnimationTrack.cpp

## Purpose

Implements `AnimationTrack` ("AnimationTrack") — the Lua-facing handle over one playing animation. Wraps an `AnimationTrackState` (the actual fade/phase math and replication) plus the source `Animation`, exposing Play/Stop/AdjustWeight/AdjustSpeed/GetTimeOfKeyframe, properties, and the KeyframeReached/Stopped signals. Non-creatable: only `Animator::loadAnimation` produces these.

## API

Reflection:
- Functions: `"Play"(fadeTime=0.1, weight=1.0, speed=1.0)`, `"Stop"(fadeTime=0.1)`, `"AdjustWeight"(weight=1.0, fadeTime=0.1)`, `"AdjustSpeed"(speed=1.0)`, `"GetTimeOfKeyframe"(keyframeName:string):double` — all Security::None.
- Properties: `"Length"` (float, read-only, SCRIPTING), `"IsPlaying"` (bool, read-only, SCRIPTING), `"TimePosition"` (double, get/set, UI), `"Animation"` (ref to Animation, read-only, SCRIPTING), `"Priority"` (EnumPropDescriptor of `KeyframeSequence::Priority`, read/write).
- Events: `"KeyframeReached"(keyframeName:string)`, `"Stopped"()`.
- Reflection type singleton registered for `shared_ptr<AnimationTrack>` so tracks can cross the reflection/Lua boundary.

Key methods: ctor `(shared_ptr<AnimationTrackState>, weak_ptr<Animator>, shared_ptr<Animation>)` connects state signals → forwarders and calls `lockParent()`; `play/localPlay(fadeTime,weight,speed)` — local path does `animator->reloadAnimation(state); state->play(...)`, then replicates via `animator->replicateAnimationPlay(animation->getAssetId(), ...)`; symmetric `stop/localStop`, `adjustWeight`, `adjustSpeed` (only replicates if speed actually changed), `getTimePosition/setTimePosition/localSetTimePosition` (clamped keyframe time + `resetKeyframeReachedDetection`, replicates via `replicateAnimationTimePosition`); `getGameTime()` via animator; `getAnimationName()`; `getLength()` = state duration; `getTimeOfKeyframe(name)` scans the KeyframeSequence children for a Keyframe with that name, returns its Time, throws `runtime_error("Could not find a keyframe by that name!")`.

## Usage

Returned to scripts from LoadAnimation; every Play/Stop/etc. both mutates local state immediately and fires the matching REPLICATE_ONLY BROADCAST remote event on AnimationTrackState (`PlayAnimation`, `StopAnimation`, ...) so other peers converge by game time.

## Gotchas

- Replication is keyed on `animation->getAssetId()` (ContentId) — two different Animations pointing at the same asset share replication identity.
- `TimePosition` setter is UI security; reading is scripting.
- GetTimeOfKeyframe throws rather than returning nil on miss.
- Track forwards state signals but never re-fires them after disconnect in dtor.
