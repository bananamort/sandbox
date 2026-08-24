# App/include/solver/Constraint.h

## Purpose

Declares the constraint interface for the PGS physics solver plus every concrete constraint type it drives: `ConstraintVariables` (per-DOF solver inputs/outputs), `MovingRegression` (2nd-degree curve fit over recent samples), `ConstraintCache` (cross-frame impulse/SOR warm-start storage), abstract `Constraint`, and the concrete subclasses `ConstraintBallInSocket`, `ConstraintLegacyBreakableBallInSocket`, `ConstraintAlign2Axes`, `ConstraintAngularVelocity`, `ConstraintLinearVelocity`, `ConstraintLinearSpring`, `ConstraintAchievePosition`, `ConstraintBodyAngularVelocity`, `ConstraintLegacyAngularVelocity`, and `ConstraintCollision`. Implementation lives in the solver library (`PGSSolver.cpp` / constraint .cpps); see [Solver.md](Solver.md).

## Declared API

- `class ConstraintVariables` — 4-float union (`minImpulseValue, maxImpulseValue, reaction, impulse`) aliased as `simd::v4f_pod v`.
  - Static SIMD setters writing into a stride-array of vars: `setReaction(ConstraintVariables*, const Vector3&)`, `setReaction(ConstraintVariables*, float x, float y)`, `setImpulse(...)` (same two shapes), `setMinImpulses(...)`, `setMaxImpulses(...)`.
  - Static gathers: `gatherComponents(simd::v4f& impulses, simd::v4f& reactions, simd::v4f& min, simd::v4f& max, const ConstraintVariables& v0[, v1[, v2[, v3]]])` — splat or 1–4-way transpose.
  - `void serialize(DebugSerializer&) const`.
- `class MovingRegression` — fields `confidence, lastPoint, lastTangent, lastCurvature`; `float testFitNextDataPointZeroOrder/FirstOrder/SecondOrder(float y) const` (relative error × confidence); `float predict() const` (= lastPoint); `void addDataPoint(float y, float weight)` (note: `weight` is ignored); `serialize(DebugSerializer&)`.
- `class ConstraintCache` — floats `velocityImpulse/velocityReaction/velocitySor/velocityCacheDamping/positionImpulse/positionReaction/positionSor/positionCacheDamping` + `MovingRegression velocityImpulseRegression/positionImpulseRegression`. Ctor initializes SOR to 1.9 with a comment "need to be initialized to the values in SolverConfig". `void cache(const ConstraintVariables& velStage, const ConstraintVariables& posStage, float sorVel, float sorPos, bool isCollision, const SolverConfig&)`; `readCache(ConstraintVariables&, ConstraintVariables&, float&, float&) const`; `serialize`.
- `class Constraint` (abstract)
  - `enum Types { Types_Collision, Types_Align2Axes, Types_BallInSocket, Types_AngularVelocity, Types_LinearVelocity, Types_AchievePosition, Types_BodyAngularVelocity, Types_LinearSpring, Types_LegacyBreakableBallInSocket, Types_LegacyAngularVelocity, Types_Count }`.
  - `enum Convergence { Convergence_Converges, Convergence_Diverges, Convergence_Undetermined }`.
  - Accessors: `unsigned getDimension() const`, `bool isBroken() const`, `Types getType() const`, body get/set `setBodyA/setBodyB/getBodyA/getBodyB(Body*)`, UID `setUID(uint64)/hasValidUID()/getUID()`.
  - Solver entry points (documented "should only be called by the solver"): `restoreCacheAndBuildEquation(ConstraintJacobianPair* jac, ConstraintVariables* velStage, ConstraintVariables* posStage, float* sorVel, float* sorPos, boost::uint8_t* useBlock, const SolverBodyDynamicProperties& bodyA, const SolverBodyDynamicProperties& bodyB, const SolverConfig&, float dt)`; `cache(const ConstraintVariables*, const ConstraintVariables*, const float*, const float*, const SolverConfig&)`; `updateBrokenState(const ConstraintVariables*, const ConstraintVariables*, const SolverConfig&)`.
  - Virtuals: `virtual ~Constraint()`; `virtual Convergence testPGSConvergence(const float* disp, const float* residuals, const float* deltaResiduals, const SolverConfig&)` (default Converges); `virtual void serialize(DebugSerializer&) const`; protected pure `buildEquation(jacobian, useBlock, velStage, posStage, bodyA, bodyB, config, dt)`; virtual `computeBrokenState(...) const` (default false). Copy ctor/assignment disabled.
  - Protected state: `uint8_t dimensions; Types type : 8; bool broken : 1;` private `Body* bodyA/bodyB; ConstraintCache* cacheData; boost::uint64_t uid;`.
  - `__RBX_NOT_RELEASE` only: static inline `checkConstraintVariables(const ConstraintVariables&)` and `checkJacobian(const ConstraintJacobianPair&)` NaN assertions.
- Concrete constraints (all take `(Body* A, Body* B)` and forward dimension counts):
  - `ConstraintBallInSocket` (3 DOF): `setPivotA/setPivotB(Vector3)` (object space relative to COM), overrides `testPGSConvergence`.
  - `ConstraintLegacyBreakableBallInSocket` (3): pivots + `setNormalOnA(Vector3)` (builds tangent frame), `setMaxNormalForce(float)` (default ∞), `computeBrokenState` override, own `broken` flag shadowing base's.
  - `ConstraintAlign2Axes`: ctor takes bodies; `setAxisA/setAxisB/getAxisA/getAxisB`; keeps cached `worldSpaceOrthogonalB1/B2`.
  - `ConstraintAngularVelocity` (1): `setAxisA/setAxisB(Vector3)`, `setDesiredAngularVelocity(float)`, `setMaxForce(float)`.
  - `ConstraintLinearVelocity` (3): `setDesiredVelocity(Vector3)`, `setMaxForce(Vector3)`.
  - `ConstraintLinearSpring` (3): pivots + `setMaxForce(Vector3)` + `setPD(float p, float d)`.
  - `ConstraintAchievePosition` (3): pivots, `setTargetVelocity(Vector3)`, `setMaxForce/setMinForce(Vector3)`.
  - `ConstraintBodyAngularVelocity` (3) and `ConstraintLegacyAngularVelocity` (3): `setTarget/setMaxTorque/setMinTorque(Vector3)` (body-A object space), `setUseIntegratedVelocities(bool)`.
  - `ConstraintCollision` (3): ctor sets SOR=1.0 per component and `cachedTangent1=(1,0,0)`; `setNormal/setPointA(Vector3)`, `setDepth(float)`, `setFriction(float)`, `setResititution(float)` (sic), overrides `testPGSConvergence`.

## Gotchas

- `restoreCacheAndBuildEquation` seeds min/max impulses to ±infinity and zeroes jacobians before calling `buildEquation`, then damps the cached impulse by `velCacheDamping`/`posCacheDamping` — a `buildEquation` that assumes pre-zeroed caches will double-damp.
- `useBlock[i]` defaults from `solverConfig.blockPGSEnabled`; constraints opt out of block Gauss-Seidel by overwriting it inside `buildEquation`.
- `ConstraintLegacyBreakableBallInSocket` carries its own `bool broken` field distinct from the base-class bitfield; `isBroken()` on the base does not observe it.
- `MovingRegression::addDataPoint` ignores its `weight` parameter despite the signature suggesting weighted regression.
- The typo `setResititution` is API spelling (do not rename independently).
- `Types_Collision` constraints are generated inside the solver from ContactConnectors — they are never registered through `addConstraint`.
