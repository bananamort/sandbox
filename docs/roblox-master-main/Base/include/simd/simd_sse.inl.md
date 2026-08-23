# simd/simd_sse.inl

## Purpose
SSE implementation of the entire simd.h contract via straight intrinsics: _mm_load/store variants, set/splat/form, cast-based reinterpretations, cvtps conversions, shuffle/unpack/move permutations, and/or/xor selects, cmp* comparisons, arith ops, rcp/rsqrt estimates with Newton-Raphson refinement and denormal/inf correction, dot products (_mm_dp_ps under RBX_SSE4 else shuffle trees), sumAcross family, pack3/unpack3, plus a SelectHelper template metaprogram giving optimal codegen for all 16 compile-time lane-select patterns.

## API
Same functions as simd.h; notable SSE-specifics:
- `load` asserts 16B alignment via RBX_SIMD_ALIGN_ASSERT then `_mm_load_ps/_mm_load_si128`.
- `loadSingle(int/uint)` loads as float scalar and bit-casts (`_mm_load_ss` + cast).
- `selectMask<a,b,c,d>()` builds −1/0 lanes from template bits.
- `extractSlow` uses an anonymous union punning pod↔elem[4].
- `blend<a,b,c,d>` exists only under RBX_SSE3.
- `inverseEstimate0` = `_mm_rcp_ps`; `inverseEstimate1` adds one NR step + denormal select + signed-zero-for-inf fixup; largestInvertible hardcoded 8.50705867e+37f (~FLT_MAX/4).
- `inverseSqrtEstimate0` = `_mm_rsqrt_ps` corrected to NaN for negative inputs; iteration = classic Quake-style 1.5−0.5·v·e².
- dotProduct3 zeroes lane 3 before the reduction.

## Usage
Included by simd.h when RBX_SIMD_USE_SSE. "Do not include directly."

## Gotchas
- operator!= for v4i/v4u is implemented as ANDNOT(eq, all-ones) rather than a real cmpneq_epi32 (SSE2 lacks integer neq) — fine but slower than needed under SSE4.
- inverseEstimate1's inf handling returns SIGNED zero matching input sign bit — sign-preserving quirk callers may rely on.
- The *Fast estimate variants skip the denormal/NaN fixups entirely.
- rotateLeft here takes const ref (header decl shows non-const in one place) — harmless overload mismatch avoided by template instantiation at call site.
- Double semicolons after moveHighLow/moveLowHigh casts (cosmetic).
