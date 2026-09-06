// rbx_intrusive_compat.h — boost::intrusive_ptr ADL fallback for RBX:: types.
// (REVERTED to no-op: the real impls in intrusive_ptr_target.h, which
// live in the boost:: namespace, were creating overload-resolution
// ambiguity when both real templates and this fallback template were
// in the boost::/rbx:: namespaces. The real templates are sufficient.)
#pragma once
#if defined(_MSC_VER) && _MSVC_LANG >= 201703L
#endif
