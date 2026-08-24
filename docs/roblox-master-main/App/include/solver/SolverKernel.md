# App/include/solver/SolverKernel.h

## Purpose

Free-function SIMD kernel of the projected Gauss-Seidel (PGS) solver: effective-mass computation, preconditioning, virtual-displacement init, the iteration sweep itself, and an error-computing variant. All functions operate on flat SoA arrays sized by constraint count; declarations only, implementation in solver library.

## Declared API

All in `namespace RBX`. Forward-declared value types: `ConstraintJacobianPair`, `BodyPairIndices`, `SolverBodyStaticProperties`, `SolverBodyMassAndInertia`, `ConstraintVariables`, `VirtualDisplacementArray` (declared twice), `EffectiveMassPair`.

- `void PGSComputeEffectiveMasses(EffectiveMassPair* effectiveMassesVelStage, EffectiveMassPair* effectiveMassesPosStage, size_t constraintCount, const boost::uint8_t* dimensions, const ConstraintJacobianPair* jacobians, const BodyPairIndices* pairs, const SolverBodyMassAndInertia* massAndIntertia, const SolverConfig& config)`
- `void PGSApplyEffectiveMassMultipliers(EffectiveMassPair* effectiveMassesVelStage, EffectiveMassPair* effectiveMassesPosStage, size_t constraintCount, const boost::uint8_t* dimensions, const float* multipliers, const BodyPairIndices* pairs, const SolverConfig& config)`
- `void PGSPreconditionConstraintEquations(ConstraintJacobianPair* preconditionedJacobiansVelStage, ConstraintJacobianPair* preconditionedJacobiansPosStage, ConstraintVariables* velocityStageVariables, ConstraintVariables* positionStageVariables, size_t constraintCount, const boost::uint8_t* dimensions, const boost::uint8_t* useBlock, const float* __restrict sorVel, const float* __restrict sorPos, const ConstraintJacobianPair* jacobians, const EffectiveMassPair* effectiveMassesVelStage, const EffectiveMassPair* effectiveMassesPosStage)`
- `void PGSInitVirtualDisplacements(VirtualDisplacementArray& virDVel, VirtualDisplacementArray& virDPos, const EffectiveMassPair* effectiveMassesVelStage, const EffectiveMassPair* effectiveMassesPosStage, size_t constraintCount, const boost::uint8_t* dimensions, const ConstraintVariables* __restrict velStage, const ConstraintVariables* __restrict posStage, const BodyPairIndices* pairs, const SolverConfig& config)`
- `void PGSSolveKernel(ConstraintVariables* __restrict velStage, ConstraintVariables* __restrict posStage, VirtualDisplacementArray& virDVel, VirtualDisplacementArray& virDPos, size_t constraintCount, size_t collisionCount, const boost::uint8_t* dimensions, const BodyPairIndices* pairs, const ConstraintJacobianPair* preconditionedJacobiansVelStage, const ConstraintJacobianPair* preconditionedJacobiansPosStage, const EffectiveMassPair* effectiveMassesVelStage, const EffectiveMassPair* effectiveMassesPosStage, const SolverConfig& config)`
- `void PGSSolveKernelComputeErrors(ArrayBase<float>& residuals, ArrayBase<float>& deltaResiduals, ArrayBase<ConstraintVariables>& vars, VirtualDisplacementArray& virD, size_t constraintCount, size_t collisionCount, size_t bodyCount, const boost::uint8_t* dimensions, const BodyPairIndices* pairs, const ConstraintJacobianPair* jacobians, const ConstraintJacobianPair* preconditionedJacobians, const EffectiveMassPair* effectiveMasses, const SolverConfig& config)`

## Gotchas

- Parameter naming uses trailing underscores (`_velStage` etc.) — these are parameters, not members.
- `collisionCount <= constraintCount` split drives per-type behavior inside the sweep; collisions are expected to occupy the leading range of the arrays (consistent with [Solver.md](Solver.md) ordering constraints first).
- `PGSSolveKernelComputeErrors` takes *both* raw and preconditioned jacobians plus a `bodyCount` the plain kernel does not need — it reconstructs full residual vectors, not just impulses.
- `__restrict` appears on selected array params: callers must guarantee non-aliasing between those specific buffers or UB follows.
