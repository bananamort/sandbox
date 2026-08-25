# CERTIFICATION — App/include/solver (final independent review)

Reviewer: last-pass independent reviewer (all prior in-flight edits on disk re-verified from scratch; nothing taken on trust).
Method: all 10 source headers read IN FULL via tool calls, each paired .md read IN FULL; every concrete claim checked against source (signatures, macro lists, field orders, comments, control flow). Cross-TU claims additionally checked against `App/solver/*.cpp`. Fixes applied only where mechanically certain.

| File | Verdict | Notes |
|---|---|---|
| Constraint.md | PASS | Prior fix verified correct: `buildEquation`/`computeBrokenState` are **private** (lines 305–314). Enum orders incl `Types_Count`, DOF counts, static setter/gather shapes, SOR=1.9 cache ctor, collision SOR=1.0 + `cachedTangent1=(1,0,0)` ctor init, `setResititution` sic, LegacyBreakableBallInSocket shadowed `broken`, ±inf seed + velCacheDamping/posCacheDamping flow (lines 370–392), `useBlock[i] = blockPGSEnabled` default, `__RBX_NOT_RELEASE` NaN checkers — all verified. |
| ConstraintJacobian.md | PASS | Prior fix verified: const `operator[]` returns POD **by value**, non-const by reference (lines 109–119). BodyPairIndices comment quote, VirtualDisplacement "only ever used on the stack", EffectiveMass(Pair) members, ConstraintJacobian unions+reset-only, Pair get/set<> specializations, dot() splats 0–2 — verified. |
| DebugSerializer.md | PASS | Prior fixes verified: raw host-byte-order (union byte copy, no endian conversion); `tag()` length wraps **mod 256** (`boost::uint8_t = strlen`). SFINAE trait signature, arithmetic storeAt/operator&, enum full-width bytes, container uint32 prefixes, scope placeholder patching, pointer overload null-check absence — verified. |
| INDEX.md | PASS | 10/10 roster matches directory; per-row notes accurate ("13 profilers" counted; %TEMP% path; SOLVER_DEBUG_MAP switch; profiler inertness). |
| Solver.md | PASS | All public/private signatures param-for-param; solveLegacy comment quoted accurately (dual legacy/PGS path confirmed in header lines 69–73); InconsistentBodyPair operator< compares bodyPair; nested SolverBodyCache 8 Vector3s + simBodyDebug; exactly 13 profilers enumerated; cross-TU gotchas confirmed in App/solver/Solver.cpp (`solveInternal` builds collisions via `addContactConnectors`, line 874; `addConstraint` rejects Types_Collision, line 1477). |
| SolverBody.md | PASS | Field orders, `[d0 a b / a d1 c / b c d2]` layout comment, all nine get<row,col> specializations, SymmetricMatrix2SIMD load indices (_m[0],_m[2],_m[2],_m[1]), invert det splats 0+2+3, union lane-3 = massInvVelStage layout, posToVelMassRatio scaling, static free operator* linkage quirk — verified. |
| SolverConfig.h doc (SolverConfig.md) | PASS | Macro roster exact: enabled = ENABLE_SOR_CONSTRAINTS / ENABLE_SOR_COLLISIONS / ENABLE_LOCAL_SOR_MODULATION / ENABLE_HINGE_FRICTION / ENABLE_IMPULSE_CACHE_DAMPING_PER_EQUATION / ENABLE_SOLVER_DEBUG_SERIALIZER; commented out = ENABLE_SOLVER_PROFILER / MIN_NORM_REPROJECT / PGS_MIN_NORM / DISABLE_ANGULAR_CONSTRAINTS (lines 3–13). All ~40 config fields with types and section grouping verified. |
| SolverContainers.md | PASS | SOLVER_DEBUG_MAP conditional type switch, always-std::map ordered shim, DenseHashMap BodyIndexation over commented-out typedef, Vector3Pod conversion/dot/+= operators and free ops — verified. |
| SolverKernel.md | PASS | Six PGS* signatures param-for-param incl preserved `massAndIntertia` typo and duplicated VirtualDisplacementArray forward decl (lines 15–16). "Collisions occupy leading range" gotcha confirmed in App/solver/SolverKernel.cpp (`pureConstraintCount = _constraintCount - _collisionCount`, line 831). |
| SolverProfiler.md | PASS | ENABLE_SOLVER_PROFILER guards on start/end/printStats, Time::now(Time::Precise), printStats formula and MESSAGE_OUTPUT, dead `static bool enable`, maxSamples=0 division gotcha — verified. |
| SolverSerializer.md | FIXED (this pass) | Prior truncate fix verified correct (`std::ios::out | std::ios::binary`, no `ios::app` → every open truncates; %TEMP%/ROBLOX/SolverLog_Client<userId>.bin). This pass fixed one more WRONG clause: `serializeForces` with `total < simBodies.size()` does **not** silently drop bodies — all simBodies.size() entries are written while the uint32 prefix declares only `total`, desyncing parsers; rewritten accordingly. |

## Totals

- Files reviewed: 11 (10 header docs + INDEX.md) — full read, no sampling
- **PASS = 10 · FIXED = 1 (SolverSerializer.md) · FAIL = 0**
- Severity ledger (this pass): WRONG ×1 (serializeForces "silently dropped"), UNSUPPORTED ×0, MISSING-GOTCHA ×0, STYLE ×0
- Prior reviewers' 4 in-flight fixes (Constraint, ConstraintJacobian, DebugSerializer, SolverSerializer-truncate) independently re-verified against source: all correct, retained.
