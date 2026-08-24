# App/include/solver/ConstraintJacobian.h

## Purpose

SIMD data structures of the PGS kernel's linear algebra layer: body-pair index tuples, virtual displacements (6-DOF lin+ang vectors, POD and simd variants plus the SoA-style array), effective masses (inv-mass-matrix × jacobian), and the per-constraint jacobian pair. These are the element types flowing through every [SolverKernel.md](SolverKernel.md) function.

## Declared API

All in `namespace RBX`:

- `class BodyPairIndices : public std::pair<int,int>` — "use class definition rather than typedef so we can forward declare"; ctors `()` and `(int a, int b)`.
- `class VirtualDisplacementPOD` — union `{simd::v4f_pod linV4; Vector3Pod lin;}` + same for angular; `serialize(DebugSerializer&)`. Non-simd view still used by integration.
- `class VirtualDisplacement` — simd twin (`simd::v4f lin, ang`); "only ever used on the stack". Ctors from two v4f or from POD; implicit `operator VirtualDisplacementPOD()`; `reset()` zeroes; getters `getLin/getAng`; `serialize`.
- `class VirtualDisplacementArray` — ctor `(size_t size, size_t alignment)` over `ArrayDynamic<VirtualDisplacementPOD>` with `ArrayNoInit()`; `reset()` zero-fills; `getData() const/non-const` (POD*), `getSize()`, indexing `operator[](int)` returning POD refs with `RBXASSERT_VERY_FAST` bounds; `serialize`.
- `class EffectiveMass` — `simd::v4f lin, ang`; `applyMultiplier(simd::v4f m)` (lane-wise multiply both parts), `reset`, `getLin/getAng`.
- `class EffectiveMassPair` — holds `EffectiveMass a, b` (bodies A/B); ctor `(a, b)` or default; `reset`, `applyMultipliers(mA, mB)`, getters `getLinA/getLinB/getAngA/getAngB`, `getPartA/getPartB`; `serialize`.
- `class ConstraintJacobian` — unions `{Vector3Pod lin; simd::v4f_pod linV4;}` / ang; `reset()`. Plain aggregate, no methods.
- `class ConstraintJacobianPair` — public members `ConstraintJacobian a, b;`
  - Tag classes `LinA/LinB/AngA/AngB` select parts via explicit specializations of `template<PartSelect> simd::v4f get<>() const` / `set<>(const simd::v4f&)`.
  - Direct accessors `getLinA/getLinB/getAngA/getAngB` + matching setters; `reset()` (both bodies).
  - `simd::v4f dot(const EffectiveMassPair&) const` — J·M⁻¹·Jᵀ numerator: lane products summed over x,y,z via splats 0–2.
  - `serialize(DebugSerializer&)`.

## Gotchas

- `ConstraintJacobian::lin/ang` are 12-byte-viewable as `Vector3Pod` but storage is a full 16-byte `v4f_pod` — the 4th lane is whatever was last written, never assumed zero unless reset.
- `dot()` sums only lanes 0–2 (splat<3> deliberately excluded) — the padding lane must not carry meaningful data.
- `VirtualDisplacementArray` allocates uninitialized (`ArrayNoInit`) — read-before-write is garbage, always `reset()` first when starting from zero.
- Indexing asserts use `RBXASSERT_VERY_FAST`, i.e. compiled out in release: no bounds protection in production.
- `BodyPairIndices` stores raw ints into flat SoA arrays — indices are positions in the solver's body arrays, not UIDs (see [SolverBody.md](SolverBody.md)).
