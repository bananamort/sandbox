# simd/simd_common.inl

## Purpose
Platform-independent SIMD composition layer, written only in terms of the backend primitives (splat/zip/zipLow/moveHighLow/arithmetic): 4-lane horizontal sums across 2/3/4 vectors (sumAcrossN), full and partial transposes (transpose, transpose4x3/3x4/4x2/2x4), and gatherX lane collectors. Also documents reciprocal-estimate precision constants.

## API
```cpp
namespace RBX::simd {
    // details: inverseEstimate0Precision()=3e-4f, inverseEstimate1Precision()=2e-7f,
    //          inverseSqrtEstimate0Precision()=3.3e-5f, inverseSqrtEstimate1Precision()=3e-7f
    v4f sumAcross2(a,b,c[,d]); v4f sumAcross3(a,b,c[,d]); v4f sumAcross4(a,b,c,d);
        // result lanes = per-lane sums of the inputs (a[i]+b[i]+c[i][+d[i]])
    template<class T> void transpose(T&a,T&b,T&c,T&d, x,y,z,w);   // 4x4 SoA<->AoS
    template<class T> void transpose4x3 / transpose3x4 / transpose4x2 / transpose2x4(...);
    template<class T> T gatherX(a,b,c,d | a,b,c | a,b);           // collect X lanes into one vector
}
```

## Usage
Included by simd.h after the backend .inl; callers use these instead of hand-writing shuffles.

## Gotchas
- The 3-arg sumAcross2/3/4 overloads pass `c` twice as the `d` argument. The zip algebra still counts each element exactly once per output lane (e.g. sumAcross2(a,b,c) yields {a0+a1, b0+b1, c0+c1, c0+c1}); the duplicated tail lane is officially "undefined" per simd.h comments.
- All functions assume 16-byte-aligned data implicitly via backend loads.
