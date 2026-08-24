# Filters.cpp

## Purpose

Implements the HitTestFilter family used by ray/occlusion queries: FilterInvisibleNonColliding (billboard ray filter), Unlocked, PartByLocalCharacter (+UnlockedPartByLocalCharacter), FilterDescendents/List, FilterCharacterOcclusion, FilterHumanoidParts, FilterHumanoidNameOcclusion, MergedFilter, and FilterSameAssembly. Pure predicate logic over Primitives→PartInstances.

## Key types and API

No descriptors. Flag: `FASTFLAGVARIABLE(UseFixedTransparencyNonCollidableBehaviour, true)` — adds a ClickDetector-presence exception to the invisibility test.

Filter semantics (Result: INCLUDE_PRIM / IGNORE_PRIM / STOP_TEST):
- **FilterInvisibleNonColliding** — ignore when transparency >0.95 AND !CanCollide; with flag on, parts bearing a ClickDetector are ALWAYS included.
- **Unlocked** — unlocked() helper: !getPartLocked.
- **PartByLocalCharacter** — ctor captures local character+head; character-descendant prims IGNORE while head transparent, else STOP_TEST (early-out).
- **UnlockedPartByLocalCharacter** — composes above + Unlocked as STOP_TEST.
- **FilterDescendents(List)** — IGNORE self-or-descendants of instance(s) (ignore-lists).
- **FilterCharacterOcclusion(headHeight)** — ignores "walkable" moving bricks below head height without auto-joints, non-colliding, >0.95 transparent, humanoid body parts, dragging bricks.
- **FilterHumanoidParts** — ignores any humanoid body part.
- **FilterHumanoidNameOcclusion(humanoid)** — keeps ONLY that humanoid's head among humanoid parts; non-humanoid parts ignored at transparency >0.99.
- **MergedFilter(a,b)** — first non-INCLUDE result wins; null filters skipped.
- **FilterSameAssembly(assemblyPart)** — ignores non-colliding prims and anything in the SAME assembly.

## Usage / reflection touchpoints

Consumed by [BillboardGui](BillboardGui.md) hit tests and [Camera](Camera.cpp) visibility/name-occlusion paths ([Base](../../Base/) ContactManager).

## Gotchas

- Transparency thresholds differ per filter (0.95 vs 0.99) — occlusion behavior isn't uniform across systems.
- PartByLocalCharacter caches character/head at CONSTRUCTION — stale after respawn unless recreated.
- STOP_TEST halts the whole query branch — order of filter composition changes results (MergedFilter mitigates but preserves first-wins).
