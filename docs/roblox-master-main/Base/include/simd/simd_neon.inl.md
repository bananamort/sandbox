# simd/simd_neon.inl

## Purpose
ARM NEON implementation of the simd.h contract: vld1q/vst1q loads/stores (NEON has no alignment fault — loadUnaligned is just load), lane insert/extract helpers, vdup splats, vzip-based permutations, vbsl selects, vreinterpret casts, vcvt conversions (with a manual abs+0.5+sign-fixup for round-to-nearest), compare intrinsics, and reciprocal/rsqrt estimates built on vrecpeq/vrsqrteq + vrecpsq/vrsqrtsq Newton-Raphson steps with denormal/inf fixups. Also defines 2-lane helper types (details::v2, v2x2) used throughout.

## API
Same surface as simd.h; NEON-specifics:
- `convertFloat2IntNearest` — vcvt truncates, so: t = cvt(|v|+0.5); select by sign → ±t.
- `operator/(a,b)` = `a * inverseEstimate1(b)` — division is an ESTIMATE, not IEEE-correct!
- `inverseEstimate0Fast` already does ONE NR iteration (unlike SSE where it's raw rcp); Estimate1 does two.
- `smallestInvertible()` = 2.9387359e-39f — a DENORMAL (comment says explicitly not FLT_MIN); largestInvertible = FLT_MAX.
- shuffle via byte-table trick: cast vectors to uint8x8xN, RBX_SIMD_NEON_TBL_MASK builds indices for vtbl2_u8/vtbl4_u8.
- SelectHelper specializations only cover the "one lane differs" patterns; generic case falls back to mask+vbsl.
- Extra functions beyond SSE parity: zeroi(), zerou().

## Usage
Included by simd.h when RBX_SIMD_USE_NEON (iOS/older Android ARM builds).

## Gotchas
- DIVISION PRECISION DIFFERS from SSE: operator/ here multiplies by ~22-bit-accurate reciprocal, so numeric results differ between ARM and x86 for identical code — cross-platform replay/simulation divergence hazard.
- form(x,y) returns {x,y,x,y} duplicated into both halves (combine(vxy,vxy)) — lanes 2,3 are NOT undefined but copies; differs subtly from expectations.
- unpack3's chooseTwoElements<3,4> indexes ACROSS two packed arrays (p[0],p[1] pair passed in) — table indices are relative to the pair, not each vector.
- inverseSqrtEstimate* inf-handling returns plain +0.0f (not signed).
- Uses C++11 `auto` (in zip()) despite the codebase's general pre-C++11 posture — compiler-dependent.
