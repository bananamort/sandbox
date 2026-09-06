// cpp_compat.h — minimal C++17 shims for 2016 engine code.
// Activated only when _MSVC_LANG >= 201703L (i.e. v143 + C++17).
#pragma once

#include <memory>
#include <functional>

#if defined(_MSC_VER) && _MSVC_LANG >= 201703L

// Note: std::auto_ptr shim lives in auto_ptr_compat.h (full std::auto_ptr
// re-implementation with 5.1.4 copy-on-assign semantics). This header
// only provides the other C++17 removals the engine hits.

// Note: std::unary_function / std::binary_function shims were removed
// because they interfere with overload resolution at user-class call
// sites (e.g. PairParams::operator== in ContactConnector.cpp sees the
// shim templates as additional candidates and produces C2666). The
// only consumer (util/Name.cpp) was refactored to use direct
// `using` type aliases instead of inheriting the shim base.

// Note: std::bind1st/std::bind2nd/std::mem_fun are handled by
// re-engineering call sites to use std::bind + lambdas (C++11+). The
// shim approach is fragile because of SFINAE overload-resolution
// differences with std::count_if and friends. Cleaner to avoid the
// shim and use the modern API in 2-3 known engine call sites.

#endif
