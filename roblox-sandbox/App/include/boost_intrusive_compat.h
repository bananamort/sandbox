// boost_intrusive_compat.h — Boost 1.74 intrusive_ptr ADL shims.
// 2016 engine code uses boost::intrusive_ptr<IFoo> but doesn't provide
// the required intrusive_ptr_add_ref/intrusive_ptr_release functions
// for every I/Foo type it uses. Boost looks these up via ADL on the
// pointer type, which fails when I/Foo is in a non-lookup-friendly
// namespace. Provide fallback functions in the boost:: namespace and
// in the global namespace so that any pointer type can be looked up
// via Koenig's algorithm (unqualified lookup) when ADL fails.
#pragma once
#if defined(_MSC_VER) && _MSVC_LANG >= 201703L

#include <unknwn.h>

// Template overloads in global and boost:: namespaces. The real
// overloads in intrusive_ptr_target.h (more specialized) take
// precedence in overload resolution for types that inherit from
// quick_intrusive_ptr_target. For other types these are no-op
// fallbacks.
template <class T> inline void intrusive_ptr_add_ref(T*) {}
template <class T> inline void intrusive_ptr_release(T*) {}
namespace boost {
template <class T> inline void intrusive_ptr_add_ref(T*) {}
template <class T> inline void intrusive_ptr_release(T*) {}
}

#endif
