# util/HeapValue.h

## Purpose
Heap-allocated, XOR-obscured scalar holder: `boost::scoped_ptr<ObscureValue<T>>` presented through implicit conversion so it reads like a plain `T`. Anti-memory-scan hardening (used e.g. by CheatEngine.h VEH hook locations).

## Declared API
```cpp
template<typename T> class HeapValue {
public:
    explicit HeapValue(const T& value);   // allocates ObscureValue<T> on heap
    operator const T() const;             // decode on read (by value)
    HeapValue& operator=(const T& other); // re-encode on write
private:
    boost::scoped_ptr<ObscureValue<T>> storage;
    HeapValue();                          // disabled: no default ctor
    HeapValue(const HeapValue&);          // disabled: no copy
    HeapValue& operator=(const HeapValue&); // disabled: no copy-assign
};
```

## Gotchas
- Every read allocates nothing but **decodes** via `ObscureValue::operator const T()` — cheap but not free; don't use in hot loops.
- Non-copyable and non-default-constructible: must be initialized with a value; can't live in most containers.
- The obscuring XOR key is the heap block's own address (`this` of the ObscureValue) — defeats naive scans only, not a real attacker.
- Scoped_ptr semantics: destroyed with the owner.

## UNKNOWN
- All consumers (known: vehHookLocationHv / vehStubLocationHv in CheatEngine.md).
