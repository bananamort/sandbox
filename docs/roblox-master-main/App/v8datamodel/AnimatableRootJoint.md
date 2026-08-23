# App/v8datamodel/AnimatableRootJoint.cpp

## Purpose

Implements `AnimatableRootJoint`, the `IAnimatableJoint` adapter for a character's root part: it lets the animation system (Animator pose stepping) move the physics-owned root part by applying per-frame *deltas* rather than absolute poses, so physics keeps acting on the part.

## API

- `AnimatableRootJoint(const shared_ptr<PartInstance>& part)` — ctor holds the target part; starts not animating.
- `void setAnimating(bool value)` — on transition into animating resets `lastCFrame` to identity.
- `const std::string& getParentName()` — returns `IAnimatableJoint::sROOT`.
- `const std::string& getPartName()` — returns the wrapped part's name.
- `void applyPose(const CachedPose& pose)` — the core: if `pose.weight > 0`, computes `delta = lastCFrame.toObjectSpace(pose.getCFrame())` and does `part->setCoordinateFrame(part->getCoordinateFrame() * delta)`; then records `lastCFrame = poseCFrame`.

## Usage

Registered with the Animator as one of its animatable joints (root-part slot, name "ROOT"); called each animation step from the pose-application loop in Animator::onStepped. Because only the delta is applied, an anchored or physics-moved part stays consistent: "if currentcframe == last ... then newcframe = pose" (source comment).

## Gotchas

- Blend weights are deliberately ignored unless zero ("we completely ignore blend weights unless they are zero"), and maskWeight is treated as 1 — no partial blending for the root joint.
- Poses with weight <= 0 still update `lastCFrame` without moving the part.
- No Instance/reflection registration here — this is a plain helper object, not a Lua-visible class.
