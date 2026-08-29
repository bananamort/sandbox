// auto_ptr_compat.h — shim std::auto_ptr to a copy-capable wrapper for
// C++17. The 2016 engine code uses auto_ptr's copy semantics (which
// transferred ownership) extensively. std::unique_ptr is move-only,
// so direct aliasing would break every copy operation. We provide a
// minimal auto_ptr<T> shim that:
//   * owns a T* (like unique_ptr)
//   * is move-only (non-copyable, non-assignable) — BUT
//   * has a copy ctor/assign that takes ownership from the source
//     (matching pre-C++11 std::auto_ptr's behavior: a = b; makes a
//     take ownership, b becomes empty). This is the only way to compile
//     code that used auto_ptr's dangerous copy semantics.
#pragma once

#include <memory>

#if defined(_MSC_VER) && _MSVC_LANG >= 201703L

namespace std {

template <typename T>
class auto_ptr {
    T* p_;
public:
    explicit auto_ptr(T* p = nullptr) noexcept : p_(p) {}
    ~auto_ptr() { delete p_; }

    // 5.1.4 copy semantics: source loses ownership on copy.
    auto_ptr(auto_ptr& other) noexcept : p_(other.release()) {}
    template <typename U>
    auto_ptr(auto_ptr<U>& other) noexcept : p_(other.release()) {}

    auto_ptr& operator=(auto_ptr& other) noexcept {
        if (this != &other) reset(other.release());
        return *this;
    }
    template <typename U>
    auto_ptr& operator=(auto_ptr<U>& other) noexcept {
        reset(other.release());
        return *this;
    }

    // 5.1.4 supported move construction/assignment in C++11 mode;
    // std::auto_ptr has implicit move via the copy ctor (C++11
    // deprecation made this OK).
    auto_ptr(auto_ptr&&) noexcept = default;
    auto_ptr& operator=(auto_ptr&&) noexcept = default;

    T& operator*() const { return *p_; }
    T* operator->() const { return p_; }
    T* get() const noexcept { return p_; }
    explicit operator bool() const noexcept { return p_ != nullptr; }

    T* release() noexcept {
        T* old = p_;
        p_ = nullptr;
        return old;
    }
    void reset(T* p = nullptr) noexcept {
        if (p_ != p) {
            delete p_;
            p_ = p;
        }
    }
};

} // namespace std

#endif
