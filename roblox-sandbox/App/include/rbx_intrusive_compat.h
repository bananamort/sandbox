// rbx_intrusive_compat.h — boost::intrusive_ptr ADL fallback for RBX:: types.
// boost::intrusive_ptr<T> calls intrusive_ptr_add_ref(T*) and
// intrusive_ptr_release(T*) via unqualified name lookup + ADL on T*.
// The engine's boost 1.74+ shim defines these in `boost::` namespace, but
// ADL on T* where T is in `rbx::` searches `rbx::`, not `boost::`.
// Provide a fallback template overload in the `rbx::` namespace so
// ADL succeeds for any T* the engine passes to boost::intrusive_ptr.
#pragma once
#if defined(_MSC_VER) && _MSVC_LANG >= 201703L

#include <unknwn.h>

// Engine types (Registry, LiveThreadRef, WeakThreadRef, etc.) live in
// RBX:: or its sub-namespaces. ADL on a pointer to one of these
// types searches the RBX:: namespace. Provide no-op fallback overloads
// there so the call resolves to *something* at link time. The real
// implementations in intrusive_ptr_target.h are matched FIRST via
// better overload (more specialized), so these are fallbacks only
// for types that don't inherit from quick_intrusive_ptr_target.
namespace rbx {
    template <class T> inline void intrusive_ptr_add_ref(T*) {}
    template <class T> inline void intrusive_ptr_release(T*) {}
}

#endif
