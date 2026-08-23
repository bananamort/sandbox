# simd/simd_platform.h

## Purpose
Architecture detection + intrinsic includes for the RBX::simd namespace: defines RBX_SIMD_X86/X64/ARM, picks exactly one backend (RBX_SIMD_USE_SSE or RBX_SIMD_USE_NEON), pulls the matching intrinsics headers, and typedefs the underlying vector pod types (__m128/__m128i or float32x4_t/...) plus VectorTypeSelect mapping scalar→pod.

## API
```cpp
// macros: RBX_SIMD_X86, RBX_SIMD_X64, RBX_SIMD_ARM (detection)
//         RBX_SIMD_USE_SSE | RBX_SIMD_USE_NEON  (backend selection; neither on unknown arch!)
//         RBX_SIMD_ALIGN_ASSERT(p, a)   // very-fast assert pointer alignment
//         RBX_SIMD_INLINE               // forceinline / always_inline / inline
namespace RBX::simd::details {
    typedef __m128/float32x4_t     vec4f_t;
    typedef __m128i/int32x4_t      vec4i_t;
    typedef __m128i/uint32x4_t     vec4u_t;
    template<class ScalarType> struct VectorTypeSelect { typedef ... type; }; // float/int32_t/uint32_t
}
```

## Usage
Included by simd_types.h and simd.h; every other simd file builds on these macros.

## Gotchas
- On an architecture that is NEITHER x86/x64 NOR ARM, no backend macro and NO vec typedefs exist — compilation of anything downstream fails with confusing errors.
- ARM detection treats plain `__arm__` as NEON-capable — pre-NEON ARM chips would miscompile.
