// cpp_compat.h — shims for C++17 removals needed by 2016 engine code.
// Activated only when _MSVC_LANG >= 201703L (i.e. v143 + C++17).
#pragma once

#include <memory>
#include <functional>

#if defined(_MSC_VER) && _MSVC_LANG >= 201703L

// Note: std::auto_ptr shim lives in auto_ptr_compat.h. cpp_compat.h
// provides the OTHER C++17 removals (unary_function, binary_function,
// bind1st, bind2nd, mem_fun) that the engine still uses.

namespace std {
        typedef Arg argument_type;
        typedef Result result_type;
    };
    template <typename Arg1, typename Arg2, typename Result>
    struct binary_function {
        typedef Arg1 first_argument_type;
        typedef Arg2 second_argument_type;
        typedef Result result_type;
    };

    // C++11 deprecated std::bind1st/std::bind2nd; gone in C++17. Provide
    // minimal lambdas (the engine uses them in one place: SerializerV2).
    template <class Fn, class T>
    inline auto bind1st(Fn&& fn, T&& x) {
        return [fn = std::forward<Fn>(fn), x = std::forward<T>(x)](auto&&... args) mutable {
            return fn(x, std::forward<decltype(args)>(args)...);
        };
    }
    template <class Fn, class T>
    inline auto bind2nd(Fn&& fn, T&& x) {
        return [fn = std::forward<Fn>(fn), x = std::forward<T>(x)](auto&&... args) mutable {
            return fn(std::forward<decltype(args)>(args)..., x);
        };
    }
}

// C++17 removed std::mem_fun in <functional>. Forward to the legacy
// __gnu_cxx namespace (which v143 still ships) so the 2016 code keeps
// working.
namespace std {
    template <typename Result, typename C>
    inline auto mem_fun(Result (C::*pmf)()) {
        return __gnu_cxx::mem_fun(pmf);
    }
}

#endif
