// boost_intrusive_compat.h — Boost 1.74 intrusive_ptr ADL shims.
// The 2016 engine code uses boost::intrusive_ptr<T>. The real
// add_ref/release overloads for quick_intrusive_ptr_target /
// intrusive_ptr_target live in boost:: namespace in
// intrusive_ptr_target.h. Those are sufficient for the engine's
// types. We do NOT add fallback overloads here because that
// creates overload-resolution ambiguity (C2668) for the types
// that DO have real impls.
#pragma once
#if defined(_MSC_VER) && _MSVC_LANG >= 201703L
#endif
