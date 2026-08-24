# PhysicsSettings.cpp

## Purpose

Implements `PhysicsSettings` (Instance name "Physics"), the singleton settings object backing the legacy Studio physics-debug property grid. Most properties are pass-through setters/getters onto static debug flags owned by OTHER classes (PartInstance/Model/Workspace/Primitive/RunService/BuoyancyContact), wired via a `SET_GET` macro. Also owns EThrottle override, throttle-adjust timing, 30fps throttling, and the CSG decomposition-geometry render toggle.

## Key types and API

Descriptors (all plain PropDescriptors, no security tier ⇒ descriptor default; categories shown):
- Display: "AreAnchorsShown", "ArePartCoordsShown", "AreUnalignedPartsShown", "AreModelCoordsShown", "AreWorldCoordsShown", "AreOwnersShown" (E-physics owners), "AreRegionsShown", "AreAwakePartsHighlighted", "AreBodyTypesShown", "IsReceiveAgeShown", "AreContactPointsShown", "AreJointCoordinatesShown", "AreMechanismsShown", "AreAssembliesShown", "IsTreeShown" (spanning tree) — all category "Display".
- Performance: "AllowSleep" (→ Primitive::allowSleep), "ParallelPhysics" (→ RunService::parallelPhysicsUserEnabled), "PhysicsEnvironmentalThrottle" (EnumPropDescriptor EThrottle::EThrottleType → global `EThrottle::globalDebugEThrottle`), "ThrottleAdjustTime" double default 1.0.
- "ShowDecompositionGeometry" — Display; hand-written get/set on static `PartOperation::renderCollisionData` (see PartOperation.md).
- "PhysicsAnalyzerEnabled" — category_Data, read-only (NULL setter), cap UI, **Security::Plugin**.
- `RBX_TEST_BUILD || RBX_PLATFORM_IOS` only: "Is30FpsThrottleEnabled" → `DataModel::throttleAt30Fps`, also mirroring into `TaskScheduler::singleton().DataModel30fpsThrottle` when cyclic executive is active; raiseChanged compiled only under MEMORY_PROFILE.

Secret block (`__RBX_SECRET_DEBUGGING` = _DEBUG or _NOOPT builds only): descriptors in category "Secret Display"/"Simulation": "AreSleepPartsHighlighted" (PartInstance::highlightSleepParts) and "WaterViscosity" (BuoyancyContact::waterViscosity).

Ctor sets name "Physics", throttleAdjustTime=1.0, physicsAnalyzerState=false. Header comment: tree hidden in release because it exposes ROBLOX assembly secrets.

## Usage / reflection touchpoints

Studio/plugin-facing settings surface (one Plugin-security property); not intended for game scripts. Consumers: Studio property grids, Workspace/PartInstance debug rendering, [Base TaskScheduler](../../Base/rbx/TaskScheduler.cpp.md) for the 30fps mirror. Pairs with `FastLogSettings.md`, `GlobalSettings.md`-style singletons and `PhysicsInstructions.md` (consumes ThrottleAdjustTime) in this folder.

## Gotchas

- Nearly every property writes a STATIC on another class — the settings object is stateless for those keys; changing them affects ALL instances globally and persists nowhere per-instance.
- The secret WaterViscosity/sleep-highlight descriptors exist ONLY in debug/no-opt builds — release reflection tables lack them entirely.
- setEThrottle mutates a GLOBAL EThrottle variable, not any instance's throttle mode.
- Is30FpsThrottleEnabled raises change events only under MEMORY_PROFILE builds despite always applying the value.
- TODO left in source: showWorldCoordinateFrame should move out of Workspace.
- UNKNOWN: EThrottle::EThrottleType enum members (V8World header); whether ParallelPhysics setter triggers RunService reconfiguration beyond the flag store.
