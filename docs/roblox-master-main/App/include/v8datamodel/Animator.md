# App/include/v8datamodel/Animator.h

## Purpose

`Animator` Instance ("Animator") — the engine animation coordinator: discovers animatable joints under its root (Motor6D-style `JointPair`s plus a synthetic root joint), runs active `AnimationTrackState`s each step, blends their poses, and replicates play/stop/speed/time-position commands through remote signals.

## Declared API

`class Animator : public DescribedCreatable<Animator, Instance, sAnimator>, public IStepped`

- Constructors: `Animator();` and `Animator(Instance* replicatingContainer)` — "use this to add Animator behavior to another Instance in the tree, like Humanoid".
- Public: `float getGameTime() const`; `shared_ptr<Instance> loadAnimation(shared_ptr<Instance> animation)`; `void reloadAnimation(shared_ptr<AnimationTrackState>)`; `std::string getActiveAnimation() const`; `shared_ptr<const Reflection::ValueArray> getPlayingAnimationTracks()`; `void tellParentAnimationPlayed(shared_ptr<Instance> animationTrack)`.
- Public test hook: `shared_ptr<PartInstance> testForServerLockPart;`
- Replication surface: remote signals `onPlaySignal<void(ContentId, float fadeTime, float weight, float speed)>`, `onStopSignal<void(ContentId, float)>`, `onAdjustSpeedSignal<void(ContentId, float)>`, `onSetTimePositionSignal<void(ContentId, float)>`; matching handlers `onPlay/onStop/onAdjustSpeed/onSetTimePosition(...)`; senders `replicateAnimationPlay/Stop/Speed/TimePosition(...)`; `passiveLoadAnimation(ContentId)`.
- Overrides: IStepped `onStepped(const Stepped&)`; `onServiceProvider(...)`; `verifySetParent(const Instance*) const`; `askSetParent` → true; `bool askAddChild(const Instance*) const`; `onAncestorChanged(const AncestorChanged&)`.
- Joint discovery: `typedef std::vector<JointPair> AnimatableJointSet; AnimatableJointSet animatableJoints;` built by `calcAnimatableJoints(Instance* rootInstance, shared_ptr<Instance> descendant = {})` and recursive `appendAnimatableJointsRec(shared_ptr<Instance>, shared_ptr<Instance> exclude)`; `scoped_ptr<AnimatableRootJoint> animatableRootJoint;` `Instance* getRootInstance();` `setupClumpChangedListener(Instance*)`.
- Tree tracking: scoped connections `descentdantAdded`, `descentdantRemoved`, `ancestorChanged`, `clumpChangedConnection` with handlers `onEvent_DescendantAdded/DescendantRemoving/AncestorModified/ClumpChanged`.
- Playback bookkeeping: `std::list<shared_ptr<AnimationTrackState>> activeAnimations;` `std::map<ContentId, shared_ptr<AnimationTrack>> animationTrackMap;` `std::string activeAnimation;` private stepper `onTrackStepped(shared_ptr<AnimationTrackState>, double time, KeyframeSequence::Priority, std::vector<PoseAccumulator>* poses)`.
- State: `RBX::Time serverLockTimer;`

## Gotchas

- Two construction modes: standalone Instance vs embedded-in-Humanoid via the `replicatingContainer` ctor — replication routing differs.
- Track map is keyed by ContentId: loading the same animation id twice reuses/mutates one track entry.
- Member name typos (`descentdantAdded/Removed`) are verbatim.
- Server-lock logic keys off `serverLockTimer` + `testForServerLockPart` — test-only member exposed publicly.

## UNKNOWN

- Blend/priority resolution order across overlapping tracks (implemented in .cpp — see [Animator.md](../../v8datamodel/Animator.md)).

## Cross-links

- Implementation: [App/v8datamodel/Animator.md](../../v8datamodel/Animator.md).
- Tracks/state: [AnimationTrack.md](AnimationTrack.md), [AnimationTrackState.md](AnimationTrackState.md), [KeyframeSequence.md](KeyframeSequence.md), root-joint adapter [AnimatableRootJoint.md](AnimatableRootJoint.md); legacy wrapper [AnimationController.md](AnimationController.md).
