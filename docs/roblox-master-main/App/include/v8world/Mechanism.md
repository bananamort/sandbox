# App/include/v8world/Mechanism.h

## Purpose

Top of the physical grouping hierarchy (Primitive → Assembly → Mechanism): a Mechanism is the whole moving structure — an assembly plus child assemblies connected by spring/kinematic joints. Participates in the pipeline and IndexedMesh bookkeeping like [Assembly.md](Assembly.md).

## Declared API

- `class Mechanism : public IPipelined, public boost::noncopyable, public IndexedMesh`
  - `Mechanism(); ~Mechanism();`
  - `Primitive* getMechanismPrimitive();` / const.
  - `Assembly* getRootAssembly();` / const.
  - Statics: `isMechanismRootPrimitive(const Primitive*)`; `getPrimitiveMechanism(Primitive*)` / const; `getRootMovingPrimitive(Primitive*)` / const; `isMovingAssemblyRoot(const Assembly*)`; `bool isComplexMovingMechanism(const Assembly*)` — "the assembly has children, connected by spring joints - complex networking issues"; `getMovingAssemblyRoot(Assembly*)` / const; private `assemblyHasMovingParent(const Assembly*)`.
  - Templates: `visitPrimitives(Func)` — visits root assembly's primitives then recurses into every child assembly.

## Gotchas

- Non-copyable.
- "Complex moving mechanism" is explicitly flagged as a networking hazard case — code paths around replication special-case it.

## UNKNOWN

- What defines "moving" vs static at this level (delegates to [Enum.md](Enum.md) states + implementation logic).

## Cross-links

- Hierarchy: [Assembly.md](Assembly.md), [IPipelined.md](IPipelined.md); stage between mechanisms and assemblies: [MechToAssemblyStage.md](MechToAssemblyStage.md).
