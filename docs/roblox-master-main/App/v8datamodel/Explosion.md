# Explosion.cpp

## Purpose

Implements `Explosion` ("Explosion") — the one-shot blast Instance: on its first stepped tick it collects primitives within BlastRadius, raises Hit per part, unjoins joints inside DestroyJointRadiusPercent (skipping ForceField-protected parts), applies radial impulse+torque scaled by BlastPressure, craters terrain (voxel sphere-carve + autowedge or smooth fillBall AIR), then schedules its own removal after a size-dependent lifetime.

## Key types and API

Descriptors:
- `propBlastRadius("BlastRadius", category_Data)` — float, clamped 0..100, default 4.
- `propDestroyJoints("DestroyJointRadiusPercent", category_Data)` — clamped 0..1, default 1.0.
- `Explosion::propBlastPressure("BlastPressure", category_Data)` — BoundProp float, default 500000.0f.
- `Explosion::propPosition("Position", category_Data)` — BoundProp Vector3.
- `prop_ExplosionType("ExplosionType", category_Data)` — enum "ExplosionType": **NO_EFFECT→"NoCraters"**, NO_DEBRIS→"Craters" (default), WITH_DEBRIS→"CratersAndDebris" — enum names are INVERTED vs display strings.
- `event_Hit("Hit", "part","distance")` — fires only when a script listener exists.

Flag: `FASTFLAGVARIABLE(RenderNewExplosionEnable, true)` (lifetime 3 s instead of 1 s). No Security:: arguments.

Behavior:
- Radii: visualRadius=blastRadius; killRadius=0 (doKill therefore DEAD unless subclass overrides); blastMaxObjectRadius=2×blastRadius; killMaxObjectRadius=blastRadius.
- doBlast: gated on blastPressure>0 and in-workspace; partial joint destruction queries ContactManager for primitives touching the unlink extents; impulse = normal·pressure·radius²/4560 ("normalizing factor") with arbitrary torque ×0.5×radius; humanoids get setActivatePhysics(true, impulse); terrain crater: smooth → fillBallInternal(AIR, skipWater) with try/catch, voxel → per-cell sphere test setting empty-cell/Water then autoWedgeCellsInternal.
- onStepped: stopStepping() first (fires exactly ONCE), signalBlast → doBlast → doKill; lifetime = (new-render? 3:1) − 1/blastRadius, self-unparent via TimerService delay (immediate if no TimerService).
- render3dAdorn draws adorn->explosion sphere; askSetParent allows ANY parent.

## Usage / reflection touchpoints

Terrain damage via [MegaCluster](MegaCluster.md) grids; protection via [ForceField](ForceField.md)::partInForceField; delayed cleanup via [TimerService](TimerService.md).

## Gotchas

- The blast runs on the NEXT stepped tick after insertion, not at creation — scripts reading affected parts immediately after parenting see pre-blast state.
- Hit signal only fires when connected BEFORE the step (signalBlast checks empty()).
- ExplosionType mapping is a trap: NO_EFFECT renders as "NoCraters" but ALSO gates terrain carving (`!= NO_EFFECT` carves) — "NoCraters" is the no-crater value despite naming both ways.
- killRadius()==0 makes doKill unreachable in this TU — any kill behavior requires a subclass override (UNKNOWN whether any exists in-tree).
