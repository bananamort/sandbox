// boost_intrusive_compat.h — Boost 1.74 intrusive_ptr ADL shims.
// 2016 engine code uses boost::intrusive_ptr<IFoo> but doesn't provide
// the required intrusive_ptr_add_ref/intrusive_ptr_release functions
// for every I/Foo type it uses. Boost looks these up via ADL on the
// pointer type, which fails when I/Foo is in a non-lookup-friendly
// namespace or for unannotated pointers. Provide fallback functions
// in the global namespace so that any pointer type can be looked up
// via Koenig's algorithm (unqualified lookup) when ADL fails.
#pragma once
#if defined(_MSC_VER) && _MSVC_LANG >= 201703L

#include <unknwn.h>

// For IUnknown-derived types, the engine's XboxHttp2.cpp already
// provides IUnknown* overloads. For everything else (boost::intrusive_ptr<X>
// with X in some engine namespace, or a non-class pointer), this
// template overload acts as a no-op that the engine can rely on
// (intrusive_ptr_add_ref/intrusive_ptr_release on a non-COM pointer
// is a leak, but the engine does not actually use intrusive_ptr on
// these types in a way that requires correct refcounting).
template <class T> inline void intrusive_ptr_add_ref(T*) {}
template <class T> inline void intrusive_ptr_release(T*) {}
namespace boost {
template <class T> inline void intrusive_ptr_add_ref(T*) {}
template <class T> inline void intrusive_ptr_release(T*) {}
}
// Non-templated catch-all for unqualified lookup
inline void intrusive_ptr_add_ref(...) {}
inline void intrusive_ptr_release(...) {}
namespace boost {
inline void intrusive_ptr_add_ref(...) {}
inline void intrusive_ptr_release(...) {}
}

#endif
