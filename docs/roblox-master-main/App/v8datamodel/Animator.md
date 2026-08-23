# App/v8datamodel/Animator.cpp

## Purpose

Implements `Animator` ("Animator") — the Instance that actually plays animations: it collects animatable Motor joints under its grandparent figure, steps active AnimationTrackStates each Stepped, folds poses through the CORE→IDLE→MOVEMENT→ACTION priority blend, applies them to joints, and replicates play/stop/speed/timePosition via REPLICATE_ONLY BROADCAST remote events keyed by animation ContentId. Also handles server lock of NPC assemblies during animation.

## API

Reflection:
- `BoundFuncDesc desc_LoadAnimation` — `"LoadAnimation"(animation:Instance)` → AnimationTrack (Security::None). Comment: "Keep this interface in sync with the proxy one on Humanoid."
- RemoteEvents: `"OnPlay"(animation:ContentId, fadeTime, weight, speed)`, `"OnStop"(animation, fadeTime)`, `"OnAdjustSpeed"(animation, speed)`, `"OnSetTimePosition"(animation, timePosition)` — all REPLICATE_ONLY/BROADCAST; ctor connects each to onPlay/onStop/onAdjustSpeed/onSetTimePosition which look the track up in `animationTrackMap` and call localPlay/localStop/localAdjustSpeed/localSetTimePosition.

Key methods/overrides:
- `loadAnimation(instance)` — requires an Animation; resolves KeyframeSequence through the parent context, creates AnimationTrackState + AnimationTrack pair named after the source instance; throws `runtime_error("Argument error: must be an Animation object")` for non-Animations.
- `passiveLoadAnimation(ContentId)` — synthesizes an Animation + track on receiving a replicated event for an unknown assetId.
- `getGameTime()` from RunService (`ServiceProvider::find<RunService>(getParent())->gameTime()`).
- `onStepped(const Stepped&)` — recollects animatable joints (`calcAnimatableJoints` over root = parent's parent), prunes finished states, optional server-lock block (`testForServerLockPart`, `resetNetworkOwnerTime(3.0f)`, `setNetworkOwnerAndNotify(NetworkOwner::Server())`, re-arm every 2.5s), then four priority buckets stepped in order CORE, IDLE, MOVEMENT, ACTION with pose blending: lower buckets fold into idle via `CachedPose::blendPoses` scaled by each higher bucket's maskWeight; final poses applied to every joint (empty result still applies default CachedPose to keep legacy animations visible).
- Parenting rules: `verifySetParent` allows only NULL, Humanoid, or AnimationController ("Animator has to be placed under Humanoid or AnimationController!"); `askAddChild` only accepts AnimationTrackState children.
- Replication senders used by tracks: `replicateAnimationPlay/Stop/Speed/TimePosition`; `getPlayingAnimationTracks()` builds ValueArray from activeAnimations; `tellParentAnimationPlayed(track)` fires `AnimationController::animationPlayedSignal` or `Humanoid::animationPlayedSignal` depending on parent type.
- Joint bookkeeping: `onEvent_AncestorModified` rewires descendantAdded/Removing + ancestryChanged + clumpChanged listeners; Motors found get `setIsAnimatedJoint(true)`; `onEvent_ClumpChanged` follows assembly root changes and sets `assembly->setAnimationControlled(true)`.
- Flag: `DFFlag::ErrorOnFailedToLoadAnim` (false).

## Usage

The animation pipeline heart: Humanoid/AnimationController own Animators; scripts LoadAnimation → Play → replication events converge all peers by game time; physics marks assemblies animation-controlled so motor transforms don't fight simulation.

## Gotchas

- Root lookup is `getParent()->getParent()` — Animator expects Humanoid(figure)/Model nesting; a bare Animator directly under a Model has root == NULL and animates nothing.
- On replicated OnPlay for an unknown ContentId the track is lazily fabricated (passiveLoadAnimation) — clients can start mid-stream without ever calling LoadAnimation.
- Poses are applied per-priority-bucket in fixed order; within a bucket multiple tracks just step into the same accumulator list.
- UNKNOWN: `Workspace::showActiveAnimationAsset` debug logging flag semantics defined elsewhere.
