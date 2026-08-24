# AnimatableRootJoint.cpp

## Purpose

Implements `AnimatableRootJoint`, a non-Instance `IAnimatableJoint` adapter that lets the animation system pose a root part (typically HumanoidRootPart) as if it were joint-driven, while still letting physics act on it.

## Key types and API

No descriptors, no class-name constant — plain C++ object holding `shared_ptr<PartInstance> part`.

- ctor `AnimatableRootJoint(const shared_ptr<PartInstance>&)` — starts `isAnimating(false)`.
- `setAnimating(bool)` — on transition to true resets `lastCFrame = CoordinateFrame()` (delta baseline).
- `getParentName()` — returns `IAnimatableJoint::sROOT`; `getPartName()` — part's name.
- `applyPose(const CachedPose& pose)` — delta-only application: `delta = lastCFrame.toObjectSpace(pose.getCFrame())`, then `part->setCoordinateFrame(part->getCoordinateFrame() * delta)`; stores `lastCFrame = poseCFrame`. Pose weight must be > 0 to apply; blend weights and maskWeight are deliberately ignored ("pretend it is 1").

## Usage / reflection touchpoints

Consumed by the animation pipeline wherever joints implement IAnimatableJoint; kinematics math mirrors [Base](../../Base/) CoordinateFrame conventions. Siblings: [AnimationTrack](AnimationTrack.md), [AnimationTrackState](AnimationTrackState.md).

## Gotchas

- Because only the DELTA from last frame is applied, physics can keep moving the part between poses — an anchored part snaps exactly onto the pose (current == last ⇒ newcframe == pose).
- Weight ≤ 0 skips application but STILL updates lastCFrame — a zero-weight frame re-baselines the delta chain.
- maskWeight ignored entirely: root posing cannot be masked per-bone.
