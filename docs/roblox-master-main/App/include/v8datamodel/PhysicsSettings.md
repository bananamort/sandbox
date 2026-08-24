# App/include/v8datamodel/PhysicsSettings.h

## Purpose

`PhysicsSettings` — GlobalAdvancedSettingsItem exposing the physics debug/throttle toggle board: FPS throttling, EThrottle mode, a dozen `Show*/Highlight*` visualization switches (backing the static bools on PartInstance), sleep/parallel-physics toggles, water viscosity, decomposition rendering, and a physics-analyzer state.

## Declared API

`class PhysicsSettings : public GlobalAdvancedSettingsItem<PhysicsSettings, sPhysicsSettings>`

- Getters/setters (all pairs unless noted): `ThrottleAt30Fps(bool)`, `EThrottle(EThrottle::EThrottleType)`, `ShowEPhysicsOwners`, `ShowEPhysicsRegions`, `ShowMechanisms`, `ShowAssemblies`, `ShowAnchoredParts`, `ShowUnalignedParts`, `ShowContactPoints`, `ShowJointCoordinates`, `HighlightSleepParts`, `HighlightAwakeParts`, `ShowBodyTypes`, `ShowPartCoordinateFrames`, `ShowModelCoordinateFrames`, `ShowWorldCoordinateFrame`, `AllowSleep`, `ParallelPhysics`, `ShowSpanningTree`, `ShowReceiveAge`, `WaterViscosity(float)`.
- `double getThrottleAdjustTime() const {return throttleAdjustTime;}` / `setThrottleAdjustTime(double)` — inline getter over private member.
- `bool getRenderDecompositionData()` / setter.
- Analyzer: `void setPhysicsAnalyzerState(bool enabled)`, `bool getPhysicsAnalyzerState() const { return physicsAnalyzerState; }` — private `physicsAnalyzerState` member.
- Private: `double throttleAdjustTime;`.

## Gotchas

- The Show* setters here almost certainly write the matching `static bool` fields on [PartInstance.md](PartInstance.md)/[ModelInstance](ModelInstance.md)-style globals — one settings object driving process-wide statics.
- Settings item pattern = FFlag-backed studio/debug surface; values may not round-trip in production builds.

## UNKNOWN

- Which of these are wired to FastLog/FFlag storage vs plain members (out-of-line).

## Cross-links

- Implementation: [App/v8datamodel/PhysicsSettings.md](../../v8datamodel/PhysicsSettings.md).
- Base: [GlobalSettings.md](GlobalSettings.md); consumers: [PartInstance.md](PartInstance.md), [Workspace.md](Workspace.md), [PhysicsInstructions.md](PhysicsInstructions.md).
