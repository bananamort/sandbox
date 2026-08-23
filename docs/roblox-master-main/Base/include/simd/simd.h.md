# simd/simd.h

## Purpose
The full SIMD API surface: ~90 force-inlined free functions over v4f/v4i/v4u documented lane-by-lane in comments — loads/stores (aligned, unaligned, splat, single), forming (zerof/splat/form), bit reinterpretations, int<->float conversions, select/replace/permute/shuffle/rotate, comparisons returning 0xffffffff masks, arithmetic operators (+ - * / abs min max mulAdd), reciprocal/rsqrt estimates with precision tiers, dot products, sumAcross variants, pack3/unpack3 SoA packing, and transposes. Backend .inl is chosen at the bottom; shared compositions come from simd_common.inl.

## API
Representative signatures (all RBX_SIMD_INLINE, namespace RBX::simd):
```cpp
template<class S> v4<S> load(const S*);              // 16B aligned
v4f load3(const float*);                              // unaligned, lane3 undefined
template<class S> v4<S> loadUnaligned/loadSplat/loadSingle(const S*);
template<class S> void store/storeUnaligned/storeSingle(S*, const v4<S>&);
v4f zerof(); template<class S> v4<S> splat(S); form(x,y,z[,w]);
template<class V> V::elem_t extractSlow(const V&, uint32_t);   // "very slow"
reinterpretAsUInt/Int/Float(...); convertFloat2IntNearest/Truncate; convertIntToFloat;
template<uint32_t...> selectMask/select/replace/shuffle/splat/permute/rotateLeft/replaceWithZero;
v4u compare*/operator > >= < <= == != (...);           // masks
v4f operator+ - * / += -= *= /= -(unary) abs max min; v4f mulAdd(a,b,c);
v4f inverseEstimate0/1[Fast]; inverseSqrtEstimate0/1[Fast]; smallest/largestInvertible[Sqrt];
v4f dotProduct/dotProduct3/sumAcross[N](...);
template<class T> void pack3(T::pod_t* __restrict, a,b,c,d); unpack3(a,b,c,d, p);
gatherX / transpose / transpose3x4/4x3/2x4/4x2;        // defined in simd_common.inl
```

## Usage
Header comment warns it is "a large include" — hot-path TUs only. Consumers get identical semantics on SSE and NEON backends.

## Gotchas
- load() REQUIRES 16-byte alignment; misaligned pointers crash (use loadUnaligned).
- Estimates are ~12-bit precision and the *Fast variants return UNDEFINED for out-of-range inputs — callers must range-check via smallest/largestInvertible.
- Lane comments frequently say "undefined" for partial ops — never rely on untouched lanes.
- rotateLeft takes `VectorType&` (non-const ref) though semantically read-only.
- If neither backend macro is set, all these are declarations with no definitions → link errors far from the cause.
