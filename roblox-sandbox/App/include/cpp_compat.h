// cpp_compat.h — minimal C++17 shims for 2016 engine code.
// Activated only when _MSVC_LANG >= 201703L (i.e. v143 + C++17).
#pragma once

#include <memory>
#include <functional>

#if defined(_MSC_VER) && _MSVC_LANG >= 201703L

// Note: std::auto_ptr shim lives in auto_ptr_compat.h (full std::auto_ptr
// re-implementation with 5.1.4 copy-on-assign semantics). This header
// only provides the other C++17 removals the engine hits.

namespace std {
    // C++11 deprecated these base classes; they're gone in C++17. Provide
    // minimal template shims so 2016 hash/equal functors compile.
    template <typename Arg, typename Result>
    struct unary_function {
        using argument_type = Arg;
        using result_type = Result;
    };
    template <typename Arg1, typename Arg2, typename Result>
    struct binary_function {
        using first_argument_type = Arg1;
        using second_argument_type = Arg2;
        using result_type = Result;
    };
}

// Note: std::bind1st/std::bind2nd/std::mem_fun are handled by
// re-engineering call sites to use std::bind + lambdas (C++11+). The
// shim approach is fragile because of SFINAE overload-resolution
// differences with std::count_if and friends. Cleaner to avoid the
// shim and use the modern API in 2-3 known engine call sites.

#endif
