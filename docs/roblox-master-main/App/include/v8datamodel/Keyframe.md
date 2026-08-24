# App/include/v8datamodel/Keyframe.h

## Purpose

`Keyframe` Instance — one time-stamped frame of an animation: holds `time` and a set of child [Pose](Pose.md) objects (only Poses may be added); any pose-tree change invalidates the parent sequence's cache.

## Declared API

`class Keyframe : public DescribedCreatable<Keyframe, Instance, sKeyframe>`

- `float getTime() const { return time; } void setTime(float value);` (protected member `time`)
- Pose management: `shared_ptr<const Instances> getPoses(); void addPose(shared_ptr<Instance>); void removePose(shared_ptr<Instance>);`
- `void invalidate();`
- Overrides: askAddChild allows only Pose; onChildAdded/onChildRemoved call invalidate; `verifySetAncestor(newParent, instanceGettingNewParent)` guard.

## Gotchas

- Children must be Pose instances — anything else is rejected.
- Cache invalidation propagates upward on every structural change (cheap edits, frequent invalidation).

## UNKNOWN

- verifySetAncestor's allowed ancestors (.cpp — presumably KeyframeSequence only).

## Cross-links

- Implementation: [App/v8datamodel/Keyframe.md](../../v8datamodel/Keyframe.md).
- Parent: [KeyframeSequence.md](KeyframeSequence.md); children: [Pose.md](Pose.md).
