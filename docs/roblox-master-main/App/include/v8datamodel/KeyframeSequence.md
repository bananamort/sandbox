# App/include/v8datamodel/KeyframeSequence.h

## Purpose

`KeyframeSequence` Instance — the animation asset: an ordered set of [Keyframe](Keyframe.md)s with loop/priority, a lazily built mutable playback cache (sorted keyframes → per-joint pose tables), and `apply()` producing blended poses for a time window.

## Declared API

Free types:
- `typedef std::pair<weak_ptr<Instance>, IAnimatableJoint*> JointPair;`
- `struct PoseAccumulator { JointPair joint; CachedPose pose; };`

`class KeyframeSequence : public DescribedCreatable<KeyframeSequence, Instance, sKeyframeSequence>`

- `enum Priority { CORE=1000 /*lowest — reflection forbids negatives*/, IDLE=0, MOVEMENT=1, ACTION=2 };` — note CORE numerically highest but semantically lowest.
- Loop/priority: `getLoop/setLoop(bool)`, `getPriority/setPriority(Priority)` (protected members).
- Tree rules: askSetParent false (asset node); askAddChild allows only Keyframe.
- Playback: `void apply(std::vector<PoseAccumulator>& jointposes, double lastkeyframetime, double keyframetime, float trackweight) const;` duration `float getDuration() const;`
- Keyframe management: getKeyframes/addKeyframe/removeKeyframe; `copyKeyframeSequence(KeyframeSequence* other); invalidateCache();`
- Overrides: onChildAdded/onChildRemoved (invalidate), verifySetAncestor.
- Cache internals (mutable): `Cache { bool isValid; float duration; namedParts[]; animatedJoints[] (index pairs into namedParts); allPoses[] ("here mostly for memory management"); poseCount; sorted CachedKeyframes {time, vector<CachedPose*> with operator<} }`; builders cacheData()/getCachedData()/AppendPosePass0/Pass1/cacheKeyframePass0/Pass1/makeKeyframe.

## Gotchas

- Cache is mutable + built lazily in const apply() — thread-hostile if applied concurrently.
- Priority encoding is inverted-feeling: CORE(1000) is *lowest* priority by comment.
- Pose counts must match animatedJoints count (asserted by comment).

## UNKNOWN

- Exact blend math across keyframes/weights (.cpp — see [KeyframeSequence.md](../../v8datamodel/KeyframeSequence.md)).

## Cross-links

- Implementation: [App/v8datamodel/KeyframeSequence.md](../../v8datamodel/KeyframeSequence.md).
- Children: [Keyframe.md](Keyframe.md)/[Pose.md](Pose.md); consumers [AnimationTrackState.md](AnimationTrackState.md), [Animator.md](Animator.md); resolver [KeyframeSequenceProvider.md](KeyframeSequenceProvider.md).
