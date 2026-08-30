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

    // C++11 deprecated std::mem_fun[_ref]; removed in C++17. Provide
    // a real wrapper that returns a callable matching the original
    // semantics (callable that takes the class instance and returns
    // the member function result). The original `mem_fun` (without
    // _ref) returned mem_fun_t<C, Result> which was a nested class
    // with operator(). Our shim returns a lambda; for the engine
    // use sites this is equivalent.
    template <typename Result, typename C>
    struct mem_fun_t {
        C* obj;
        Result (C::*pmf)();
        mem_fun_t(C* o, Result (C::*p)()) noexcept : obj(o), pmf(p) {}
        Result operator()() const { return (obj->*pmf)(); }
    };
    template <typename Result, typename C>
    inline mem_fun_t<Result, C> mem_fun(Result (C::*pmf)()) {
        return mem_fun_t<Result, C>(nullptr, pmf);
    }
    template <typename Result, typename C, typename T>
    inline mem_fun_t<Result, C> mem_fun(Result (C::*pmf)(), T) {
        (void)pmf;  // overload to suppress C2665 (no-op)
        return mem_fun_t<Result, C>(nullptr, pmf);
    }

    // C++11 deprecated std::bind1st/std::bind2nd; gone in C++17. The
    // original returned binder1st/binder2nd templates. Provide a
    // minimal lambda that captures the bound value and forwards args.
    template <class Fn, class T>
    struct binder1st {
        Fn fn;
        T value;
        binder1st(Fn f, T v) noexcept : fn(std::move(f)), value(std::move(v)) {}
        template <class... Args>
        auto operator()(Args&&... args) const {
            return fn(value, std::forward<Args>(args)...);
        }
        template <class... Args>
        auto operator()(Args&&... args) {
            return fn(value, std::forward<Args>(args)...);
        }
    };
    template <class Fn, class T>
    struct binder2nd {
        Fn fn;
        T value;
        binder2nd(Fn f, T v) noexcept : fn(std::move(f)), value(std::move(v)) {}
        template <class... Args>
        auto operator()(Args&&... args) const {
            return fn(std::forward<Args>(args)..., value);
        }
        template <class... Args>
        auto operator()(Args&&... args) {
            return fn(std::forward<Args>(args)..., value);
        }
    };
    template <class Fn, class T>
    inline binder1st<Fn, T> bind1st(const Fn& fn, const T& x) {
        return binder1st<Fn, T>(fn, x);
    }
    template <class Fn, class T>
    inline binder2nd<Fn, T> bind2nd(const Fn& fn, const T& x) {
        return binder2nd<Fn, T>(fn, x);
    }
}

#endif
