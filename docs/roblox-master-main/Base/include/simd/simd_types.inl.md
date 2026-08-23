# simd/simd_types.inl

## Purpose
Inline bodies for simd_types.h's v4 template: copy ctor, pod ctor, two assignment operators, and the implicit conversion to pod — each a one-liner moving the platform vector handle. "Do not include this file directly."

## API
```cpp
template<class E> v4<E>::v4(const v4& u)  : v(u.v) {}
template<class E> v4<E>::v4(const pod_t& u): v(u)   {}
template<class E> void v4<E>::operator=(const v4& u)   { v = u.v; }
template<class E> void v4<E>::operator=(const pod_t& u){ v = u;    }
template<class E> v4<E>::operator pod_t() const        { return v; }
```
All marked RBX_SIMD_INLINE.

## Usage
Included at the bottom of simd/simd_types.h only.

## Gotchas
- Uses `#pragma once` despite being an .inl — harmless double protection.
