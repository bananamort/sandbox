# KeyframeSequence.cpp

## Purpose

Implements `KeyframeSequence` ("KeyframeSequence") — the animation clip container: Loop/Priority props, Keyframe children with pose trees, a lazily built sorted cache (duration, unique joints by parent/child NAME, per-keyframe pose slots), and the pose interpolation engine `apply()` with axis-angle shortest-path lerping plus easing styles (Constant/Elastic/Cubic/Bounce) behind flags. Also defines CachedPose math (getCFrame/setCFrame/interpolatePoses/blendPoses).

## Key types and API

Descriptors (no Security:: arguments):
- `prop_Loop("Loop", category_Data)` — bool, default TRUE.
- `prop_Priority("Priority", category_Data)` — enum "AnimationPriority": Idle, Movement, Action, **CORE** (default ACTION).
- Funcs: GetKeyframes/AddKeyframe/RemovePose-style Add/RemoveKeyframe — thin parenting wrappers.
Constants: sKeyframeSequence; IAnimatableJoint::sROOT="__Root" defined here. Flags: AnimationEasingStylesEnabled(false), CachedPoseInitialized(false).

Cache:
- Two-pass build (`cacheData`, const/mutable): pass0 collects duration=max keyframe time, unique (parentName,childName) joint pairs via string intern list, pose count; pass1 builds per-keyframe CachedKeyframe{time, poses[jointIndex]→CachedPose in allPoses}; sorted by time. Invalidated on any child add/remove or Keyframe Time change ([Keyframe](Keyframe.md)::invalidate).
- apply(jointposes, lastTime, time, trackweight): trackweight≤0 no-op; loops wrap time into [0,duration]; for each cached joint matches runtime joints BY NAME (parent+part); finds surrounding keyframes WITH a pose for that joint (masked gaps skipped); interpolates weights, then trackweight-fades weight toward 0 and maskWeight toward 1; blends into accumulator (first-write shortcut when CachedPoseInitialized).

CachedPose math:
- Stored as translation + rotaxisangle (axis·angle); getCFrame rebuilds Matrix3.
- lerpAxisAngle — shortest-path quaternion-ish lerp with flip handling when dot<0 ("i'm lazy" recursion branch).
- interpolatePoses — normalized w0/w1 then easing remap of the weights from p0's style/direction: Constant (step at .5 for IN_OUT), Elastic (damped sine overshoot), Cubic (in/out/inout power-3), Bounce (piecewise 7.5625t² parabolas); Linear/default untouched. Weighted sum of weight/maskWeight/translation + lerped rotation.
- blendPoses(p0,p1) — p1's maskWeight CAPS p0's via min ("don't want to double fade-out"), additive weights, min-combined maskWeights "only used at top level priority collapse".

## Usage / reflection touchpoints

Consumed by [AnimationTrackState](AnimationTrackState.md)::step and [Animator](Animator.md); easing styles shared conceptually with [AnimationTrack](AnimationTrack.md); [Pose](Pose.md) supplies per-node data.

## Gotchas

- Joint matching is by STRING NAMES — renamed parts silently unbind from animations.
- apply() linear-scans all keyframes PER JOINT PER FRAME (before/after search inside the joint loop) — O(joints×keyframes) every step.
- blendPoses uses min not multiply for mask collapse — double-masked layers keep higher weight than naive blending expects.
- Priority CORE is registered LAST but is the HIGHEST fold layer in Animator ordering — enum numeric order ≠ blend order.
