# App/include/solver/Solver.h

## Purpose

`PGSSolver`: the public face of the PGS constraint solver. Owns SimBody registration, pure constraints, contact manifolds, per-body warm-start caches, the inconsistent-constraint ("physics analyzer") detector, and a battery of phase profilers. Orchestrates island solving via the free functions in [SolverKernel.md](SolverKernel.md); drives `Constraint` subclasses from [Constraint.md](Constraint.md).

## Declared API

- `typedef std::pair<boost::uint64_t, boost::uint64_t> BodyUIDPair;`
- `class InconsistentBodyPair { Body* bodyA; Body* bodyB; BodyUIDPair bodyPair; Constraint::Convergence convergence; bool operator<(const InconsistentBodyPair&) const (compares bodyPair); }`
- `class OrderedConnector { ContactConnector* connector; bool swap; }`
- `class BadConnector { Vector3 position; Constraint::Convergence convergence; }`
- `class PGSSolver`
  - `PGSSolver()`.
  - Bodies: `void addSimBody(SimBody* body, bool highPriority)`, `void removeSimBody(SimBody*)` — "high priority bodies will be simulated even if throttled".
  - Constraints: `void addConstraint(Constraint*)`, `void removeConstraint(Constraint*)`.
  - Solves: `void solve(const std::vector<ContactConnector*>& connectors, float dt, boost::uint64_t debugTime, bool throttled)`; `void solvePositions(const std::vector<ContactConnector*>&)`; `void solveLegacy(const std::vector<ContactConnector*>&, float dt, boost::uint64_t debugTime, bool throttled)` — "exactly like it was before the physics analyzer (sleeping islands) were submitted".
  - Manifolds: `void addContactManifold(boost::uint64_t uidA, boost::uint64_t uidB)`, `void removeContactManifold(uidA, uidB)` — uids of both Object instances; `void clearBodyCache(boost::uint64_t uid)`.
  - Analyzer: `setInconsistentConstraintDetectorEnabled(bool)`, `setPhysicsAnalyzerBreakOnIssue(bool)`, `bool getPhysicsAnalyzerBreakOnIssue() const`, `const ArrayBase<InconsistentBodyPair>& getInconsistentBodyPairs() const`, `const ArrayBase<ArrayDynamic<boost::uint64_t>>& getInconsistentBodies() const`.
  - Logging: `void dumpLog(bool enable)`, `void setUserId(int id)`.
  - Private pipeline: `solveInternal(...)` (adds SolverConfig dispatch), `solveIsland(constraints, selectedSimBodies, dt, config)`, `updateContactManifold(pairId, manifold)`, `addContactConnectors(activeManifolds, connectors, simBodies)`, `initAnchoredObjects(...)` (fills dynamic/static/mass arrays + displacement arrays for anchored bodies), `integratePositionsAndUpdateSimBodies(...)`, `integratePositionsIgnoreVelocitiesAndUpdateSimBodies(...)`, `detectInconsistentConstraints(...)`.
  - State: `constraintUIDGenerator`; `pureConstraintSet` = ordered map uid→Constraint* ("pure constraints — not including the Collision constraints"); `contactManifolds` unordered map BodyUIDPair→ContactManifold*; nested `class SolverBodyCache` with 8 Vector3 fields (virD pos/vel stage linear+angular, linear/angular velocity, integrated linear/angular velocity) plus raw `SimBody* simBodyDebug` and its own `serialize(DebugSerializer&)`; `bodyCache` keyed by uid; `simBodies`, `highPrioritySimBodies` as `boost::unordered_set<SimBody*>`; detector flags/results; `SolverSerializer serializer`; 13 named `SolverProfiler` members (gatherCollisions, islandSplit, integrateVelocities, initAnchoredBodies, buildEquations, computeEffectiveMasses, preconditioning, multiplyEffectiveMassMultipliers, initVirD, kernel, integratePositions, writeCache, solver); `dumpLogSwitch`; `userId`.

## Gotchas

- `solveLegacy` exists precisely to bisect physics-analyzer regressions — behavior differences vs `solve` are intentional.
- Collision constraints never enter `pureConstraintSet`; they are rebuilt each frame inside `solveInternal` from the ContactConnector list ([Constraint.md](Constraint.md) gotcha).
- Throttling semantics live at this level: when `throttled=true`, only bodies in `highPrioritySimBodies` simulate.
- All profiler members are inert unless `ENABLE_SOLVER_PROFILER` is defined in [SolverConfig.md](SolverConfig.md) (it is commented out by default).
- `bodyCache` values hold a non-owning `SimBody*` used only for debug serialization — dangling after `removeSimBody` unless `clearBodyCache(uid)` is called.

## UNKNOWN

- Which engine subsystem instantiates PGSSolver (World/Workspace side lives outside App/include; likely documented under v8world docs once written).
