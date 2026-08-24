# App/include/v8datamodel/AnimatableRootJoint.h

## Purpose

`IAnimatableJoint` adapter that makes a character's root part (HumanoidRootPart-style) addressable by the animation system: it reports the owning part and parent names and applies cached poses directly to the part's CFrame when "animating" is enabled.

## Declared API

`class AnimatableRootJoint : public IAnimatableJoint`

- `AnimatableRootJoint(const shared_ptr<PartInstance>& part)` — holds the shared_ptr for lifetime.
- `PartInstance* getPart() const { return part.get(); }`
- Overrides: `void setAnimating(bool value)`; `const std::string& getParentName()`; `const std::string& getPartName()`; `void applyPose(const CachedPose& pose)`.
- Private state: `bool isAnimating; shared_ptr<PartInstance> part; CoordinateFrame lastCFrame;`

## Gotchas

- Header-only class (22 lines): all override bodies are inlined here except `setAnimating`/`applyPose`/name getters, which resolve in the .cpp.
- `lastCFrame` is bookkeeping for pose application; stale if the part moves through other systems while animating.

## UNKNOWN

- Exact `applyPose` semantics (rotation-only vs full CFrame; see [AnimatableRootJoint.md](../../v8datamodel/AnimatableRootJoint.md)).

## Cross-links

- Implementation: [App/v8datamodel/AnimatableRootJoint.md](../../v8datamodel/AnimatableRootJoint.md).
- Interface: [IAnimatableJoint.md](IAnimatableJoint.md); pose consumers live under Animation ([AnimationTrack.md](AnimationTrack.md), [Animator.md](Animator.md)).
