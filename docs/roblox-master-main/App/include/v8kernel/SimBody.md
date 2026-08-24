# App/include/v8kernel/SimBody.h

## Purpose

The simulation-side twin of a body assembly root: integrates state (quaternion orientation master + angular momentum master), holds reciprocal mass/inertia caches, force/torque/impulse accumulators for parallel accumulation, kernel list indices, connector counts, and symmetric-contact ("sleeping") detection state. One SimBody per assembly root that is in the kernel.

## Declared API

- `class SimBody : public Allocator<SimBody>`
  - `SimBody(Body*)`, dtor; `getBody()/getBodyConst()`, `setDt/getDt`, `setUID/getUID`.
  - State: `Body* body; float dt; bool dirty; boost::uint64_t uid; PV pv; Quaternion qOrientation;` ("master for simulation") `Vector3 angMomentum;` ("master for simulation") `Vector3 moment, momentRecip, Matrix3 momentRecipWorld; float massRecip; float constantForceY;`
  - Accumulators: `force/torque/impulse/rotationalImpulse` (all world-space; force/impulse at COM); solver cache `Vector3 impulseLast;`
  - Kernel indices: int refs `getFreeFallBodyIndex/getRealTimeBodyIndex/getJointBodyIndex/getBuoyancyBodyIndex/getContactBodyIndex()` + `isFreeFallBody()/isRealTimeBody()/isJointBody()/isBuoyancyBody()/isContactBody()/isInKernel()` + `validateBodyLists()` (**note**: sums only 4 of its 5 lists — buoyancy missing from the ≤1 check).
  - Connector counters: getters + increment/decrement pairs per kind (humanoid/secondPass/realTime/joint/buoyancy/contact), each also maintaining `numOfConnectors`; typos are API: `incrementJointConnetorCount`.
  - Stepping: `void step(); stepVelocity(); stepPosition(); stepFreeFall();` `applyImpulse(impulse, worldPos)`; `clearVelocity(); updateAngMomentum();`
  - Solver handoff: **`void updateFromSolver(const Vector3& newPosition, const Matrix3& newOrientation, const Vector3& newLinearVelocity, const Vector3& newAngularVelocity);`**
  - Dirty/gravity: inline `updateIfDirty()` ("called before step. Assumes body cofm is clean"), `makeDirty()/getDirty()`; `getWorldGravityForce()` → `(0, constantForceY, 0)`; statics `computeTorqueFromOffsetForce(force, cofm, location)`.
  - Symmetric-state block: `clearSymStateAndAccummulator()` (sic) sets both flags true and zeroes penetration aggregates; `accumulatePenetrationForce(...)` feeds them; `updateSymmetricContactState()` compares squared torque / x-z force against `Constants::impulseSolverSymStateTorqueBound/ForceBound`; queries `isSymmetricContact/isVerticalContact`, `clearSymmetricContact()`.
  - Parallel accumulate section (header comment: "Parallel physics will accumulate forces from different threads"): `accumulateForceCofm`, `accumulateForce(force, worldPos)` (adds matching torque), `accumulateTorque`, `accumulateImpulse(impulse, worldPos)` (rotational = r×J), `accumulateImpulseAtBranchCofm`, `accumulateRotationalImpulse` — each with slow asserts on finiteness and `maxDebug*` bounds.
  - Resets/queries: `resetImpulseAccumulators/resetForceAccumulators` (clearForce seeds gravity!), getters `getForce/getTorque/getImpulse/getRotationallmpulse()` (typo l/I), `getMassRecip`, `getImpulseLast`, `hasExternalForceOrImpulse()` (exact != comparisons).
  - Debug statics: `maxTorqueXX/maxForceXX/maxLinearImpulseXX/maxRotationalImpulseXX` + `maxDebug*()` accessors.

## Gotchas

- `clearForceAccumulators` seeds `force` with gravity rather than zero — resetting then reading gives gravity, not zero.
- Orientation/momentum quaternions+vectors here are the integration masters; the Body's PV is downstream-copied — writing one side directly desyncs the assembly.
- `hasExternalForceOrImpulse` uses exact float equality against zero/gravity — near-zero external forces still count as external.
- `validateBodyLists` omits buoyancy index from its exclusivity check (comment-level inconsistency in the source).
- `dt` is set by KernelData list placement (`kernelDt` vs `freeFallDt`) and zeroed on removal — a SimBody outside the kernel has dt 0.

## UNKNOWN

- Where `impulseLast` warm-start data is consumed (PGS path in solver .cpps).
