# App/include/solver — Index

PGS (projected Gauss-Seidel) physics solver interface: constraints and their jacobians, SIMD kernel free functions, solver body value types, config aggregate, and debug/profiling/serialization support. Implementation lives in the solver library; the engine-side driver is v8kernel/v8world.

| File | Doc | Notes |
|---|---|---|
| Constraint.h | [Constraint.md](Constraint.md) | Constraint base + all concrete constraint types (ball-in-socket, align-2-axes, velocity/spring/position, collision). |
| ConstraintJacobian.h | [ConstraintJacobian.md](ConstraintJacobian.md) | BodyPairIndices, VirtualDisplacement(POD/Array), EffectiveMass(Pair), ConstraintJacobian(Pair). |
| DebugSerializer.h | [DebugSerializer.md](DebugSerializer.md) | Byte-buffer serializer + SFINAE serialize-method trait + length-prefixed scope. |
| Solver.h | [Solver.md](Solver.md) | `PGSSolver` facade: SimBodies, constraints, manifolds, caches, physics-analyzer detector, 13 profilers. |
| SolverBody.h | [SolverBody.md](SolverBody.md) | Body dynamic/static properties + SymmetricMatrix(SIMD/2SIMD) inverse-inertia math. |
| SolverConfig.h | [SolverConfig.md](SolverConfig.md) | All runtime tunables + compile-time feature macros (ENABLE_SOLVER_* etc.) defined in-header. |
| SolverContainers.h | [SolverContainers.md](SolverContainers.md) | Map typedef shims (SOLVER_DEBUG_MAP switch), BodyIndexation = DenseHashMap, Vector3Pod. |
| SolverKernel.h | [SolverKernel.md](SolverKernel.md) | PGS* free functions: effective masses, preconditioning, virtual displacements, solve sweep, error variant. |
| SolverProfiler.h | [SolverProfiler.md](SolverProfiler.md) | Averaging stopwatch; fully inert without ENABLE_SOLVER_PROFILER. |
| SolverSerializer.h | [SolverSerializer.md](SolverSerializer.md) | Frame recorder → %TEMP%/ROBLOX/SolverLog_Client<uid>.bin via DebugSerializer. |

10 of 10 headers documented. No .inl files in this directory.
