# App/include/v8datamodel/IAnimatableJoint.h

## Purpose

Animation-joint interface plus the `CachedPose` value type flowing through it: translation + rotation-axis-angle with weight/maskWeight and easing metadata, blend/interpolate helpers, and CFrame conversion.

## Declared API

`struct CachedPose`

- Default ctor: weight 0, maskWeight 1, uninitialized, LINEAR/IN easing; value ctor `(translation, rotaxisangle)`: weight 1, maskWeight 0, initialized.
- Fields: `Vector3 translation; Vector3 rotaxisangle; float weight, maskWeight; Pose::PoseEasingStyle easingStyle; Pose::PoseEasingDirection easingDirection; bool initialized;`
- Conversion: `CoordinateFrame getCFrame() const; void setCFrame(const CoordinateFrame&);`
- Statics: `interpolatePoses(p0, p1, w0, w1)`, `blendPoses(p0, p1)`.

`class IAnimatableJoint`

- Protected ctor sets `isAnimatedJoint = false`; statics `sNULL`, `sROOT` (sentinel names).
- Pure virtuals: `const std::string& getParentName(); const std::string& getPartName(); void applyPose(const CachedPose& pose);`
- Flag: `virtual void setIsAnimatedJoint(bool)` / `bool getIsAnimatedJoint() const`.

## Gotchas

- rotaxisangle encodes axis*angle in a Vector3 — not a quaternion or euler triple.
- Default-vs-value ctors invert the weight/maskWeight defaults (0/1 vs 1/0).
- No virtual destructor — deleting via this interface is UB by design (mixin-style).

## UNKNOWN

- Blend semantics distinction between interpolatePoses and blendPoses (.cpp consumers).

## Cross-links

- Implementer: [AnimatableRootJoint.md](AnimatableRootJoint.md); pose data [Pose.md](Pose.md); driver [Animator.md](Animator.md).
