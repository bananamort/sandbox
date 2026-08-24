# App/include/v8world/Clump.h

## Purpose

A `Clump` is the *geometry-motivated* grouping above assemblies: primitives clustered for mesh/index bookkeeping (IndexedMesh) rather than simulation. Mirrors [Assembly.md](Assembly.md)'s root-primitive pattern but keyed by clump-root membership; also enumerates motors (joints) beneath its root.

## Declared API

- `class Clump : public boost::noncopyable, public IndexedMesh`
  - `Clump(); ~Clump();`
  - `Clump* getRootClump()` / const — via templated `getRoot<Clump>()` (IndexedMesh/IPipelined tree helper).
  - `Primitive* getClumpPrimitive()` / const — `rbx_static_cast` of the lower node.
  - `static Clump* getPrimitiveClump(Primitive* p);` / `getConstPrimitiveClump`; `static bool isClumpRootPrimitive(const Primitive* p);`
  - `void loadMotors(G3D::Array<Joint*>& load, bool nonAnimatedOnly);` / `loadConstMotors(...) const`.
  - `template<class Func> void visitPrimitives(Func func)` — recursion stops at children that are themselves clump roots (stays within this clump).

## Gotchas

- Non-copyable.
- Clump vs Assembly: both walk "root primitive + descendents until next root", but the root predicates differ (`isClumpRootPrimitive` vs `isAssemblyRootPrimitive`) — the same primitive tree can partition differently under each.
- `getClumpPrimitive` uses unchecked `rbx_static_cast`; caller must know the lower node really is a Primitive.

## UNKNOWN

- Where clump roots are decided (weld/cluster logic lives in Joint/World implementation, not here).

## Cross-links

- Grouping counterpart: [Assembly.md](Assembly.md); base: [IPipelined.md](IPipelined.md) tree helpers, [Joint.md](Joint.md).
