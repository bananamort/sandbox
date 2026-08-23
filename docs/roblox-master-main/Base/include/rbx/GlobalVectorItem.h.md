# rbx/GlobalVectorItem.h

## Purpose
Sparse-slot allocator for a caller-owned static array: `RBX::GlobalVectorItemPtr<T>(list, count)` claims the first slot whose `valid` flag is false (T must derive from `GlobalVectorItemBase`), or heap-allocates an overflow object when the array is exhausted. Destructor releases the slot (or deletes the overflow object).

## API
```cpp
namespace RBX {
struct GlobalVectorItemBase { bool valid; };  // starts false

template<class T> class GlobalVectorItemPtr {
    GlobalVectorItemPtr(T* list, size_t count); // claim slot or new T()
    ~GlobalVectorItemPtr();                     // release slot / delete overflow
    T* operator->();
    T* get();
};
}
```

## Usage
Fixed-capacity registries declared as static arrays where occasional overflow shouldn't fail: item behaves "smartptr-like" for the lifetime of the registration.

## Gotchas
- Slot claiming is a linear scan with no synchronization — not thread-safe.
- Overflow items are plain `new`/`delete`, NOT part of the shared array; two instances never share slots, but ordering guarantees between static-array and overflow items are up to the caller.
- Copying GlobalVectorItemPtr is unguarded (raw T* p copied; both destructors would release) — treat as move-only by convention. UNKNOWN whether any copy sites exist.
