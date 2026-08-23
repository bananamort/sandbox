# rbx/BaldPtr.h

## Purpose
Debug-hardened raw-pointer wrapper. `RBX::BaldPtr<T>` behaves like `T*` but validates on construction/assignment/dereference that the pointer does not match known CRT/Ogre debug-heap poison patterns (`0xCCCCCCCC` uninitialized stack, `0xCDCDCDCD` uninit heap, `0xFDFDFDFD` no-man's-land, `0xDDDDDDDD`/`0xFEEEFEEE` deleted, `0xBAADF00D`, `0xDEADC0DE`, `0xFEEDFACE`, `0xDEADBEEF`). Zero overhead in release when very-fast asserts are compiled out.

## API
```cpp
template<class T> class BaldPtr {
    BaldPtr();                       // NULL
    BaldPtr(T* Pointer);             // validate()
    T*& operator=(T* Pointer);
    T& operator*() const;            // RBXASSERT_VERY_FAST(mPointer) + validate
    operator T*() const;
    T* operator->() const;
    T* get() const;                  // unchecked
    void validate() const;
};
```

## Usage
Drop-in replacement for members/locals that hold borrowed raw pointers where stale/uninitialized derefs were a past crash source. File tail contains a commented compile-test exercising pointer/const conversion parity with raw pointers.

## Gotchas
- Validation compares the truncated 32-bit value: `(unsigned)mPointer != ...` — on 64-bit builds a legit pointer whose LOW 32 bits happen to match a poison pattern would false-positive assert.
- Only catches the specific poison constants at *pointer granularity* — it cannot detect arbitrary dangling pointers.
- Implicit `operator T*` means it decays to raw pointer silently; no ownership semantics whatsoever.
