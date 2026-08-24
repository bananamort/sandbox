# App/include/v8kernel/KernelData.h

## Purpose

The kernel's SoA registries: IndexArrays of SimBodies bucketed by simulation class (free-fall / real-time / joint / contact), leaf Bodies needing PV updates, kernel Points, and Connectors bucketed per pass (humanoid / second-pass / real-time / joint / buoyancy / contact). Fully header-defined insertion/removal logic that decides, per connector type and throttle-ability, which lists bodies land in and at what dt.

## Declared API

All inline in-header (`class KernelData`):

- Public arrays (IndexArray keyed by member index getters):
  - `freeFallBodies` — "bodies with no connectors".
  - `realTimeBodies` — "humanoid bodies that are not throttle-able" (i.e. `!getCanThrottle()`).
  - `jointBodies` — bodies with joint connectors.
  - `contactBodies` — contact connectors but no joint connectors.
  - `leafBodies` (of **Body**, not SimBody) — "need update PV every step, NOT in kernel!" (non-root children with connectors).
  - `points` ([Point.md](Point.md)).
  - `humanoidConnectors`, `secondPassConnectors` ("kernel joints"), `realTimeConnectors` ("connectors on humanoid body parts"), `jointConnectors`, `buoyancyConnectors`, `contactConnectors`.
- `KernelData()`; dtor asserts every array empty.
- `void addLeafBodies(Body*)` — recursive; only children with `connectorUseCount > 0`.
- `void insertBody(Body*)` — asserts root & not already in kernel; routes via `addBodyToNewList(simBody)`.
- `void removeBody(Body*)` — removes from current list, clears sym-state, sets `dt = 0`.
- **`void addConnector(Connector* c, bool pgsOn)`** — the routing brain:
  1. Early-out: neither simBody in kernel AND type not HUMANOID/JOINT/KERNEL_JOINT → not added.
  2. HUMANOID → humanoidConnectors; KERNEL_JOINT → secondPassConnectors; `pgsOn && JOINT` → jointConnectors; `pgsOn && BUOYANCY` → buoyancyConnectors.
  3. Either body non-throttleable → realTimeConnectors.
  4. `!pgsOn && (JOINT || BUOYANCY || either side isJointBody)` → jointConnectors ("Contact connectors in touch with joint bodies are considered joint connectors").
  5. Else asserts CONTACT → contactConnectors.
  Each branch increments matching counters on both SimBodies; finally attaches to both bodies' connector lists.
- `void removeConnector(Connector*)` — mirrors by `isHumanoid/isSecondPass/isRealTime/isJoint/isBuoyancy`, else contact + a symmetry-detection unwind (`getReordedSimBody` + `applyContactPointForSymmetryDetection(..., −1.0f)`); decrements counts; detaches from bodies.
- Private: `addLeafBody/removeLeafBody/removeLeafBodies`; `removeBodyFromCurrentList(SimBody*)` (real-time/joint removal also strips leaf bodies; free-fall removal calls `updateAngMomentum()`; all paths zero dt); `addBodyToNewList(SimBody*)` priority ladder: non-throttle → realTimeBodies @ `Constants::kernelDt()`; joint-count>0 → jointBodies @ kernelDt (+leaf bodies); contact-count>0 → contactBodies @ **freeFallDt**; no connectors → freeFallBodies @ freeFallDt (clears sym state); else jointBodies @ kernelDt. `addConnectorToBody/removeConnectorFromBody` maintain `connectorUseCount`, re-bucket the root's list, and add leaf bodies when root is in a spring-solved list.

## Gotchas

- List membership is *derived state*: it changes as connectors attach/detach and as canThrottle flips — nothing keeps buckets valid except disciplined add/remove through this class.
- Contact-only assemblies run at **freeFallDt**, not kernelDt — timing bugs between contact and joint paths usually trace here.
- `pgsOn` flag changes bucket semantics for JOINT/BUOYANCY connectors (legacy path folds contacts-touching-joints into jointConnectors).
- The dtor asserts are the only leak detection: destroying KernelData with members still registered aborts in checked builds only.
- Cross-link: solver-side consumption of these arrays is [Kernel.md](Kernel.md) + solver docs ([../solver/Solver.md](../solver/Solver.md)); physics implementation write-ups live under App/script and Base doc roots where present.
