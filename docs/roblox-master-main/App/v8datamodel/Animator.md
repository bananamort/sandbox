# Animator.cpp

## Purpose

Implements `Animator` ("Animator"), the per-character animation engine: owns AnimationTrackStates, steps them every frame in priority order (CORE → IDLE → MOVEMENT → ACTION), folds the pose stacks with mask weights, applies final poses to Motor joints, replicates play/stop/speed/timePosition as remote events keyed by ContentId, and (for NPC humanoids) grabs server network ownership while animating.

## Key types and API

Descriptors:
- `desc_LoadAnimation("LoadAnimation", "animation", Security::None)` — BoundFunc, non-Animation arg throws `RBX::runtime_error("Argument error: must be an Animation object")`. Source comment: "Keep this interface in sync with the proxy one on Humanoid."

Remote events (all **Security::None**, REPLICATE_ONLY, BROADCAST):
- `"OnPlay"` ("animation","fadeTime","weight","speed") → onPlay
- `"OnStop"` ("animation","fadeTime") → onStop
- `"OnAdjustSpeed"` ("animation","speed") → onAdjustSpeed
- `"OnSetTimePosition"` ("animation","timePosition") → onSetTimePosition

Flag: `DYNAMIC_FASTFLAGVARIABLE(ErrorOnFailedToLoadAnim, false)`; constant `sAnimator = "Animator"`. Debug toggle `Workspace::showActiveAnimationAsset` gates asset-name logging and `activeAnimation` string.

Behavior:
- `loadAnimation(Animation)` — resolves KeyframeSequence via parent context (warning "Object must be in Workspace before loading animation" if null), creates paired `AnimationTrackState` + `AnimationTrack`, names both after the Animation instance.
- `passiveLoadAnimation(ContentId)` — receiver-side lazy track creation from a replicated OnPlay for an unseen animation id; cached in `animationTrackMap<ContentId, AnimationTrack>`.
- `onStepped(Stepped&)` — recalc animatable Motors under `getRootInstance()` (grandparent!) every step; prune finished/stopped tracks; four per-priority PoseAccumulator vectors; fold core→idle→movement→action multiplying by maskWeight then `CachedPose::blendPoses`; apply to joints — even empty CachedPose() is applied ("to allow legacy animations to show").
- NPC server lock: if `testForServerLockPart` set and animations active, every 2.5 s calls `setNetworkOwnerAndNotify(NetworkOwner::Server())` + `resetNetworkOwnerTime(3.0f)`.
- Parenting rules: `verifySetParent` — only NULL/Humanoid/AnimationController parents allowed (else throw); `askAddChild` — only AnimationTrackState children.
- `tellParentAnimationPlayed` forwards to AnimationController OR Humanoid `animationPlayedSignal` depending on parent type.
- Clump tracking: listens rootPart `clumpChangedSignal`, marks new assemblies `setAnimationControlled(true)`, re-hooks when assembly root changes.

## Usage / reflection touchpoints

Central hub between [AnimationTrack](AnimationTrack.md)/[AnimationTrackState](AnimationTrackState.md)/[AnimatableRootJoint](AnimatableRootJoint.md) and Humanoid/AnimationController hosts; network-owner grab touches [Network](../../Network/) ownership APIs.

## Gotchas

- getRootInstance is PARENT->PARENT — Animator under Humanoid expects Humanoid's parent to be the character container; a differently-nested Animator computes joints from the wrong subtree.
- calcAnimatableJoints runs EVERY STEP (two full descendant visits) — O(n²)-ish cost on large models.
- OnPlay for an unknown ContentId silently passive-loads it — clients auto-fetch any replicated animation id (with ErrorOnFailedToLoadAnim flag present but unused in this TU).
- Priority folding order is fixed CORE<IDLE<MOVEMENT<ACTION; each higher layer's maskWeight scales the LOWER layer's weight before blending.
