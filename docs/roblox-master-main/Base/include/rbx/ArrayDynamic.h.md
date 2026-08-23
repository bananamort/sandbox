# rbx/ArrayDynamic.h

## Purpose
Aligned, type-trait-optimized dynamic array: `RBX::ArrayDynamic<T>` (owning, aligned_malloc-backed growth), `RBX::ArrayBase<T>` (non-owning view base with STL-style interface), and `RBX::ArrayRef<T>` (explicit non-owning view). Copy/construct/destroy paths dispatch on `boost::has_trivial_*` traits so PODs get `memcpy`/no-op lifetimes; SIMD-friendly 16-byte alignment by default (`defaultAlignment = 16`).

## API
```cpp
template<class T> class ArrayBase<T> {           // view: T* mData + size
    T& operator[](size_t)/at(size_t);            // RBXASSERT_VERY_FAST bounds
    size_t size(); T& front()/back();
    T* begin()/end(); const T* cbegin()/cend(); T* data(); bool empty();
};
struct ArrayNoInit {};                            // tag

template<class T> class ArrayDynamic<T> : public ArrayBase<T> {
    static const boost::uint32_t defaultAlignment = 16;
    ArrayDynamic();
    explicit ArrayDynamic(size_t size, boost::uint32_t align = defaultAlignment);
    explicit ArrayDynamic(size_t size, ArrayNoInit, boost::uint32_t align = defaultAlignment); // raw memory
    ArrayDynamic(const ArrayDynamic<T>& / const ArrayBase<T>&);
    void clear(); ArrayDynamic& operator=(const ArrayDynamic<T>& / const ArrayBase<T>&);
    void reserve(size_t); void resize(size_t); size_t capacity() const;
    void push_back(const T&); void pop_back();
    void insert(size_t i, const T& val); T* insert(const T* it, const T& val);
    template<class In> void insert_count(T* it, In first, size_t count);
    template<class In> void insert(T* it, In first, In last);
    void assign(size_t size, const T& value);
};

template<class T> class ArrayRef<T> : public ArrayBase<T> {
    ArrayRef(T*, size_t); ArrayRef(const ArrayRef<T>& / const ArrayBase<T>&);
    ArrayRef& operator=(const ArrayBase<T>&);
};
```
Internal helpers in `array_dynamic_details`: `aligned_alloc`/`aligned_free` (`_aligned_malloc` Win32, `memalign` Android, `posix_memalign` otherwise), `construct`, `copyTrivial`, `copyConstruct`, `destroy`, `shiftRight(TrivialCopy)`.

## Usage
Used where vector's allocator can't guarantee alignment or where per-type trait specialization matters (math/SIMD buffers, hot render data).

## Gotchas
- `mNoInit` mode (via `ArrayNoInit`) hands out UNINITIALIZED memory and then uses trivial memcpy for copies — only valid for trivially copyable T; mixing with non-trivial T is UB.
- Inverted-looking trait logic in `copyTrivial`: the `boost::true_type isFundamentalOrPointer` overload does element-wise placement-new for ≤16 elements, while `false_type` does memcpy — i.e., memcpy path is taken when T is NOT fundamental/pointer. Verify intent before "fixing".
- Growth doubles from capacity 2; never shrinks.
- `pop_back` destroys the popped element ONLY when mNoInit is set — backwards relative to normal C++ semantics (in normal mode destruction happens later via clear/resize).
- Consequence of the above in NORMAL mode: after `pop_back`, the popped slot still holds a live object; a later `push_back` placement-news over it WITHOUT running its destructor — for non-trivial T the popped element's destructor NEVER executes. Treat ArrayDynamic as POD-only unless you control every mutation.
