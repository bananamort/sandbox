// auto_ptr_compat.h — shim std::auto_ptr to std::unique_ptr for C++17.
// The 2016 engine code uses std::auto_ptr<...> in many headers. C++17
// (and v143's default) removed std::auto_ptr. The compat behavior of
// auto_ptr (movable, non-copyable) is identical to unique_ptr, so we
// #define a replacement for the std:: type only. The .h classes keep
// working with no source edits.
#pragma once
#include <memory>
#if defined(_MSC_VER) && _MSVC_LANG >= 201703L
namespace std {
    template <typename T>
    using auto_ptr = std::unique_ptr<T>;
}
#endif
