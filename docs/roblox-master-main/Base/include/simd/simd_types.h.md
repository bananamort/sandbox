# simd/simd_types.h

## Purpose
Declares the SIMD vector wrapper template `RBX::simd::v4<ElemType>` — a single-member POD wrapper around the platform vector type — plus convenience typedefs v4f/v4i/v4u, their pod types (v4f_pod = __m128 etc.), and const-ref arg typedefs. Header comment: include THIS file when you only need types, not functionality.

## API
```cpp
template<class ElemType> class v4 {
    typedef fun_t (platform vector), elem_t, v4_t, arg_t (const v4&), pod_t (= fun_t);
    v4(); v4(const v4&); v4(const pod_t&);      // implicit from pod
    operator=(v4/pod); operator pod_t() const;  // implicit to pod
    fun_t v;                                    // public member
};
typedef v4<float> v4f;  v4<int32_t> v4i;  v4<uint32_t> v4u;
typedef v4f_pod/v4i_pod/v4u_pod;   // raw intrinsic handles
typedef v4fArg/v4iArg/v4uArg;      // const-ref params
```

## Usage
Physics/rendering hot paths pass `v4fArg` parameters and store `v4f`. The .inl at bottom defines the trivial copy/assign/conversion bodies.

## Gotchas
- Both implicit conversions (pod→v4 via ctor, v4→pod via operator) are deliberately enabled — vectors interop freely with intrinsics code but overload resolution surprises are possible.
- Default ctor leaves `v` UNINITIALIZED.
