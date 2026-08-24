# App/include/solver/SolverBody.h

## Purpose

Body-side value types consumed by the solver: per-body dynamic state snapshot, symmetric 3×3 (and 2×2) inverse-inertia matrices in scalar/POD/SIMD flavors with closed-form inversion, the mass-and-inertia record with velocity-stage vs position-stage scaling, and static identity properties.

## Declared API

All in `namespace RBX`:

- `class SolverBodyDynamicProperties` — "internal representation of dynamic properties of a body (for both simulated and anchored)": `Vector3 integratedLinearVelocity, integratedAngularVelocity; Matrix3 orientation; Vector3 position, linearVelocity, angularVelocity;` + `serialize(DebugSerializer&)`.
- `class SymmetricMatrix` — scalar 3×3 symmetric matrix stored as two Vector3Pods: `diagonals [d0,d1,d2]`, `offDiagonals [a,b,c]` per the comment layout `[d0 a b / a d1 c / b c d2]`. `Vector3 operator*(const Vector3&)`, `SymmetricMatrix operator*(float)`, `serialize`.
- `class SymmetricMatrixPOD` — `{simd::v4f_pod diagonals, offDiagonals;}` — union-compatible storage twin of SymmetricMatrixSIMD.
- `class SymmetricMatrixSIMD`
  - Ctors from `(const float*)` via `simd::load3` twice (diagonals then off-diagonals), from two v4f, or from POD.
  - `template<int row,int column> simd::v4f get() const` — specializations for all six independent entries + three mirrored ones.
  - `simd::v4f operator*(const simd::v4f& v)` — full mat-vec through permutes of off-diagonals.
  - `void invert()` — analytic symmetric 3×3 inverse: cofactors via shuffles/permutes, determinant assembled from splats 0+2+3 of an intermediate, `dInv = splat(1.0f)/d`; writes back diagonals and off-diagonals.
  - Free `operator*(const simd::v4f& s, const SymmetricMatrixSIMD&)` (declared `static` at namespace scope — internal linkage quirk).
- `class SymmetricMatrix2SIMD` — packed `[d00, d01, d01, d11]` in one v4f (`m`); ctors/default, `load(const float*)` (reads _m[0], _m[2], _m[2], _m[1]), `form(d00, d11, d01)` via `simd::gatherX`, `operator*` (2×2 mat-vec), `invert()` (det = m0·m3 − m1², sign-select permute), `get<row,column>()` specializations.
- `class SolverBodyMassAndInertia`
  - Union view: anonymous struct `{Vector3Pod inertiaDiagonal; float massInvVelStage; Vector3Pod inertiaOffDiagonal; float posToVelMassRatio;}` overlaying `SymmetricMatrixPOD inertiaSIMD`.
  - `SymmetricMatrixSIMD getInvInertiaVelStage() const`; `SymmetricMatrixSIMD getInvInertiaPosStage(float scale)` — multiplies by `scale * posToVelMassRatio`.
  - `simd::v4f getInvMassVelStage()` / `getInvMassPosStage()` (latter scaled by `posToVelMassRatio`) as splatted v4f.
  - Stage-tag dispatch: nested tag classes `VelStage/PosStage` + specialized `template<StageSelect> getInvMass()` / `getInvInertia(float scale)`.
  - `serialize(DebugSerializer&)`.
- `class SolverBodyStaticProperties` — `boost::uint64_t bodyUID; boost::uint32_t guid; bool isStatic;` + `serialize`.

## Gotchas

- The mass/inertia union means `inertiaDiagonal/inertiaOffDiagonal/massInvVelStage/posToVelMassRatio` are literally the same bytes as `inertiaSIMD` — writing one view changes the other; layout assumes diagonal fields land in lanes 0–2 and `massInvVelStage` in lane 3 of `diagonals` (and off-diagonal analogously).
- `posToVelMassRatio` scales position-stage effective masses relative to velocity stage — position corrections intentionally use different inertia than impulses; passing scale=0 into `getInvInertiaPosStage` zeroes it entirely.
- `SymmetricMatrixSIMD::invert()` divides by a determinant computed without any singularity guard — degenerate inertia produces inf/NaN that propagates through the kernel.
- Free `operator*(v4f, SymmetricMatrixSIMD)` is declared `static` → each TU gets its own copy; harmless but unusual.
- `SolverBodyDynamicProperties` keeps both plain and integrated velocities; integration writes the integrated set while constraint warm data reads both (see [Solver.md](Solver.md) `integratePositions...` methods).
