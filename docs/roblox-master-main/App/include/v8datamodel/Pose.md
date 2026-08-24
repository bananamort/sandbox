# App/include/v8datamodel/Pose.h

## Purpose

`Pose` — creatable `Instance` node inside animation `Keyframe`s: per-joint transform (`CoordinateFrame`), weight/maskWeight, and easing style/direction controlling interpolation to the next pose; children must be Poses (sub-pose tree mirrors the character joint hierarchy).

## Declared API

`class Pose : public DescribedCreatable<Pose, Instance, sPose>`

- Enums: `PoseEasingStyle {POSE_EASING_STYLE_LINEAR=0, CONSTANT, ELASTIC, CUBIC, BOUNCE}`; `PoseEasingDirection {POSE_EASING_DIRECTION_IN, OUT, IN_OUT}`.
- Protected state: `CoordinateFrame coordinateFrame`, `float weight`, `float maskWeight`, `PoseEasingStyle easingStyle`, `PoseEasingDirection easingDirection`; helpers `Keyframe* findKeyframeParent()`, `void invalidate()`.
- Accessors: `const CoordinateFrame& getCoordinateFrame() const` (inline) / `setCoordinateFrame(const CoordinateFrame&)`; `getWeight/setWeight(float)`; `getMaskWeight/setMaskWeight(float)`; `getEasingStyle/setEasingStyle(PoseEasingStyle)`; `getEasingDirection/setEasingDirection(PoseEasingDirection)`.
- Sub-pose API: `shared_ptr<const Instances> getSubPoses()`, `addSubPose(shared_ptr<Instance>)`, `removeSubPose(shared_ptr<Instance>)`.
- Overrides: `askAddChild` inline — only accepts children castable to Pose; `onChildAdded/onChildRemoved` → `invalidate()`; `verifySetAncestor(newParent, instanceGettingNewParent)`.

## Gotchas

- Header includes ITSELF (`#include "V8DataModel/Pose.h"`) alongside V8Tree/Instance.h — harmless due to #pragma once but signals copy-paste origin.
- Any structural change invalidates cached data via invalidate(); weight/easing setters presumably also raise property-changed + invalidate out-of-line.
- askAddChild enforces Pose-only children — non-Pose parenting throws upstream.

## UNKNOWN

- What invalidate() flushes (Keyframe/animation runtime caches, out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/Pose.md](../../v8datamodel/Pose.md).
- Animation family: [Keyframe.md](Keyframe.md), [KeyframeSequence.md](KeyframeSequence.md), [AnimationTrack.md](AnimationTrack.md).
