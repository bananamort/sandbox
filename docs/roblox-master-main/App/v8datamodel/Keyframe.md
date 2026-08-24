# Keyframe.cpp

## Purpose

Implements `Keyframe` ("Keyframe") — one time-positioned node of a KeyframeSequence holding child Pose tree: Time float prop, GetPoses/AddPose/RemovePose wrappers over children, and cache invalidation bubbling to the parent sequence on time change.

## Key types and API

Descriptors (no Security:: arguments):
- `prop_Time("Time", category_Data)` — float, default 0; setter raises + `invalidate()`.
- Funcs: `GetPoses()` → children Instances; `AddPose(pose)`/`RemovePose(pose)` — setParent wrappers with null/parent checks.

Constants: `sKeyframe = "Keyframe"`.

Behavior: `invalidate()` — if parent is a KeyframeSequence, calls invalidateCache(). verifySetAncestor override is a pass-through.

## Usage / reflection touchpoints

Child of [KeyframeSequence](KeyframeSequence.md); poses documented in [Pose](Pose.md); keyframe-crossing events fired from [AnimationTrackState](AnimationTrackState.md) using these names/times.

## Gotchas

- AddPose does NOT validate the child is actually a Pose — any Instance parents cleanly and breaks cache assumptions downstream.
- Time changes invalidate the sequence cache but do NOT re-sort live CachedKeyframes until next cacheData.
