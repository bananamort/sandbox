# App/include/v8datamodel/Filters.h

## Purpose

Reusable `HitTestFilter` predicates for raycasts/picking: unlocked-only, exclude local character, visibility/collision filters, descendant scoping (single instance or list), composite merging, character-occlusion and humanoid-name occlusion, and same-assembly tests.

## Declared API

All derive from `HitTestFilter` (`Result filterResult(const Primitive*) const`, values like INCLUDE_PRIM / STOP_TEST). File also re-exposes `typedef std::vector<shared_ptr<Instance>> Instances;`

- `class Unlocked : HitTestFilter` — `static bool unlocked(const Primitive*)`; filter: include if unlocked else STOP_TEST.
- `class PartByLocalCharacter : HitTestFilter` — "exclude the user character from the hit test"; ctor `(Instance* root)` caches character+head; override filter.
- `class UnlockedPartByLocalCharacter : PartByLocalCharacter` — both conditions.
- `class FilterInvisibleNonColliding : HitTestFilter` — default ctor; skips invisible/non-collidable prims.
- `class FilterDescendents : HitTestFilter` — ctor `(shared_ptr<Instance>)`; restricts hits to that subtree.
- `class FilterDescendentsList : HitTestFilter` — ctor `(const Instances*)`; any of several subtrees (borrows pointer).
- `class MergedFilter : HitTestFilter` — ctor `(const HitTestFilter* a, const HitTestFilter* b)`; combines two borrowed filters.
- `class FilterCharacterOcclusion : HitTestFilter` — ctor `(float headHeight)`.
- `class FilterHumanoidParts : HitTestFilter` — stateless.
- `class FilterHumanoidNameOcclusion : HitTestFilter` — ctor `(shared_ptr<Humanoid>)`.
- `class FilterSameAssembly : HitTestFilter` — ctor stores part ("checking if Prim is in same assembly").

## Gotchas

- FilterDescendentsList/MergedFilter hold *raw pointers* to caller-owned state — lifetime must outlive the raycast.
- STOP_TEST semantics (vs mere EXCLUDE) matter: some filters abort the whole test rather than skip a prim.

## UNKNOWN

- Exact Result vocabulary/precedence (Util/HitTestFilter.h outside this slice).

## Cross-links

- Implementation: [App/v8datamodel/Filters.md](../../v8datamodel/Filters.md).
- Consumers: [MouseCommand.md](MouseCommand.md), [Camera.md](Camera.md) (isPartVisibleFast takes HitTestFilter*).
