# App/include/v8kernel/Cofm.h

## Purpose

Lazy cache of a [Body.md](Body.md)'s center-of-mass data: COM offset in body space, total mass, and moment (inertia matrix). Recomputed only when dirtied by the owning body.

## Declared API

- `class Cofm : public Allocator<Cofm>` (pooled allocation via Util/Memory.h)
  - `Cofm(Body* body)`.
  - `bool getIsDirty() const;` `void makeDirty()` inline.
  - `const Vector3& getCofmInBody()`, `float getMass()`, `const Matrix3& getMoment()` — each calls `updateIfDirty()` first (non-const methods).
  - Private: `Body* body; bool dirty; Vector3 cofmInBody; float mass; Matrix3 moment;` `void updateIfDirty();`

## Gotchas

- Getters are **non-const** because they mutate the cache — holding a `const Cofm&` blocks them; callers in hot loops should fetch once per step.
- Comment on updateIfDirty says "true if was dirty" but the declared return type is void — doc drift; treat as void.
- `moment` is the full 3×3 inertia about the COM in body space, not the diagonal.
