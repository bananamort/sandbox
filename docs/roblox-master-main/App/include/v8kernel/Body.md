# App/include/v8kernel/Body.h

## Purpose

The kernel's rigid-body node: a tree (IndexedTree) of bodies forming assemblies, with mass properties, per-assembly state versioning (`stateIndex`), lazy PV (position+velocity) updates, optional [Link.md](Link.md) joints, a pooled [Cofm.md](Cofm.md) for branch aggregates, and an owning [SimBody.md](SimBody.md] on assembly roots. Header carries the canonical World-Body/StateRoot/RigidRoot diagram.

## Declared API

- `class Body : public IndexedTree, public Allocator<Body>` — friends KernelData, Kernel, SimBody.
  - Diagram in header defines terms: StateRoot = body/joint holding latest state id; RigidRoot = clump root; COFM computed per rigid group; SimBody only on free (root) bodies.
  - Private state: `rbx::spin_mutex mutex;` ("for safe calls that require update"); `boost::uint64_t uid; int guidIndex;` ("solver inspector id between clients"); `int leafBodyIndex; int connectorUseCount;` `static Body* worldBody; static void initStaticData();` `Body* root; Cofm* cofm; SimBody* simBody;` ("Only present for parent && in kernel"); `Link* link;` defining vars `bool canThrottle; CoordinateFrame meInParent; Matrix3 moment; float mass; Vector3 cofmOffset;` resulting `unsigned int stateIndex; PV pv;`
  - Tree overrides: `onParentChanging/onParentChanged/onChildAdding/onChildAdded/onChildRemoved`.
  - Public lifecycle: `Body()`, `~Body()`, `static unsigned int getNextStateIndex();` `static Body* getWorldBody();`
  - Ids: `setUID/getUID`; `setGuidIndex/getGuidIndex`.
  - State dirt: `cofmIsClean()`, `makeCofmDirty()`, `advanceStateIndex()`, inline `makeStateDirty()` → `getRoot()->advanceStateIndex()`, `getStateIndex()` (updates PV), `getStateIndexNoUpdate() const`.
  - Hierarchy: `getChild(i)/getConstChild(i)/getParent()/getConstParent()/getLink()/getConstLink()/getRoot()` (slow assert vs calcRoot); `getMeInAncestor(ancestor)` recursive CF composition.
  - Inertia/mass: `getMass`, `getIBody` (+V3 diagonal), `getIBodyAtPoint(point)`, `getMoment`, `getPrincipalMoment`, `getIWorld`, `getIWorldAtPoint`; Branch twins via Cofm: `getBranchMass/getBranchIBody/getBranchIBodyV3/getBranchIWorld/getBranchIWorldAtPoint/getBranchCofmPos/getBranchCofmCoordinateFrame/getBranchCofmOffset`.
  - PV access ladder: `getPvFast()` (fishing assert up-to-date), **`getPvUnsafe()`** ("Current Job should hold the Data Model write lock or somehow have locked the Body::mutex"), **`getPV_Spin_Lock()`**, `getPvSafe() const` (const_cast + spin lock); position twins `getPosFast/getPos`, `getCoordinateFrameFast/getCoordinateFrame`, `getVelocity`.
  - Accumulators (all forward to root SimBody if present): impulse at branch cofm / linear at world pos / rotational; force at branch cofm (asserts called on Root) / force at world pos / torque; reset pairs; branch queries `getBranchForce/getBranchTorque/getBranchVelocity` ("velocity at the COFM of the assembly", zero fallbacks).
  - Setters: `setParent`, `setMeInParent(const CoordinateFrame&)` / `(Link*)`, `setMass/setMoment/setCofmOffset`; guarded quartet taking `const BodyPvSetter&`: **`setPv`, `setCoordinateFrame`, `setVelocity`, `setCanThrottle`** ("Only Primitive can set these" + ToDo asking for better gate than the tag class); `void updateBulletCollisionObject(btCollisionObject* object);`
  - Debug: `isLeafBody()`, `kineticEnergy()`, `potentialEnergy()`.

## Gotchas

- The PV ladder is load-bearing for thread safety: Fast variants are only valid inside the physics step; Unsafe requires external lock; Spin_Lock/PvSafe self-lock. Mixing them wrong is UB, not just stale data.
- `getConstMeInParent` asserts no link — const path only valid within a rigid clump.
- Mass properties split: own (`mass/moment/cofmOffset`) vs branch aggregates (via Cofm cache, dirty-propagated from children).
- `worldBody` is a process-wide singleton initialized via `initStaticData` — anchored bodies ultimately hang off it.

## UNKNOWN

- Exact Primitive↔Body coupling lives in v8world/V8Datamodel outside this tree.
