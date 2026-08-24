# Pose.cpp

## Purpose

Implements `Pose` ("Pose"), a node of the animation pose tree parented under a Keyframe (or another Pose) describing one joint's transform: CFrame, blend Weight, MaskWeight, and easing style/direction. Mutations invalidate the owning Keyframe so re-evaluation happens on next playback.

## Key types and API

Descriptors (no security tier ⇒ descriptor default; category_Data):
- `prop_CFrame("CFrame")` — CoordinateFrame.
- `prop_Weight("Weight")` — float, default 1.0.
- `prop_MaskWeight("MaskWeight")` — float, default 0.0.
- Funcs **Security::None**: "GetSubPoses():Instances" (= getChildren2), "AddSubPose(pose)" (parents under self), "RemoveSubPose(pose)" (unparents only when direct child).
- Easing descriptors COMMENTED OUT behind DFFlag::AnimationEasingStylesEnabled: prop_EasingStyle/prop_EasingDirection never registered in this build.

Enums registered regardless of flag gating: `PoseEasingStyle` {Linear, Constant, Elastic, Cubic, Bounce}; `PoseEasingDirection` {Out, InOut, In}. Internal defaults: LINEAR / IN.

Internals:
- `findKeyframeParent()`: walks Pose chain up to owning Keyframe (NULL otherwise).
- `invalidate()`: forwards to Keyframe::invalidate.
- All setters raise property change then invalidate; setEasingStyle/Direction mutate + invalidate but skip raisePropertyChanged (flag disabled).
- `verifySetAncestor` delegates to Super (no extra rules).

## Usage / reflection touchpoints

Script-facing at Security::None for the three funcs; properties default-tier. Consumers: Keyframe.md/KeyframeSequence.md/AnimationTrack.md in this folder (animation pipeline), Studio animation editor.

## Gotchas

- Easing style/direction exist as internal state and enums but are INVISIBLE to reflection in this build (flag-gated descriptors commented out) — serialized only if the XML layer references them header-side.
- Default easingDirection is IN while enum listing order suggests Out first.
- AddSubPose accepts ANY Instance (only NULL-checked, not type-checked) — non-Pose children corrupt GetSubPoses consumers.
- setEasing* don't raise change events even when applied — replication/UI won't observe those mutations.
