# App/include/v8world/Edge.h

## Purpose

Base class for every pairwise link in the world graph — `Joint` and `Contact`. An Edge pins two Primitives, participates in the pipeline as an `IPipelined` node, carries sim/throttle state, and maintains per-primitive intrusive-list indices used by the stages.

## Declared API

- `class RBXBaseClass Edge : public IPipelined`
  - `typedef enum {JOINT, CONTACT} EdgeType;` — "purely to eliminate dynamic casts".
  - `Edge(Primitive* prim0, Primitive* prim1);`
  - Virtual inline dtor asserts full unlink: `index0 == -1`, `index1 == -1`, both prims NULL — then stamps them with `Debugable::badMemory()`.
  - `virtual EdgeType getEdgeType() const = 0;`
  - `virtual void generateDataForMovingAssemblyStage(void) {}` — default no-op hook.
  - State: `Sim::EdgeState get/setEdgeState(...)`, `Sim::ThrottleType get/setThrottleType(...)`.
  - `template<class Type> Type* fastCast(EdgeType edgeType)` — enum-checked static_cast with a very-fast assert that the cast matches `dynamic_cast`.
  - Primitive access (adjacency trick): `Primitive* getPrimitive(int i)` / const → `(&prim0)[i]`; `otherPrimitive(const Primitive*)`, `otherPrimitive(int i)` = `(&prim0)[(i+1)%2]`; const variants; Graphics overload `otherPrimitive(const CullableSceneNode*)` = RBXASSERT(NULL), returns NULL.
  - List indices: `int getPrimitiveId(const Primitive*)` (0/1), `int getIndex(const Primitive*)`, `void setIndex(Primitive*, int)`; protected `virtual void setPrimitive(int i, Primitive* p);`
  - Membership tests: `bool links(const Primitive*)`, `bool links(Primitive*, Primitive*)` (order-insensitive).

## Gotchas

- `getPrimitive(i)` reads `(&prim0)[i]` — relies on prim0/prim1 being adjacent members; any reordering of those two fields silently corrupts every accessor.
- Edges must be removed from all primitive lists **before** destruction; the dtor asserts enforce it and poison pointers after.
- `fastCast` trusts `getEdgeType()` over RTTI in release — an edge lying about its type yields a bad static_cast.

## Cross-links

- Subclasses: [Joint.md](Joint.md), [Contact.md](Contact.md); tree plumbing: [IPipelined.md](IPipelined.md); state enums: [Enum.md](Enum.md).
