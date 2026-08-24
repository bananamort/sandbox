# util/ObscureValue.h

## Purpose
Template wrapper that stores a value XOR-obscured against casual memory scans, while still exposing it through implicit conversion so it can be used almost like `T`. Anti-cheat hardening primitive (paired in spirit with CheatEngine.h defenses), includes FastLog.h for logging support.

## Declared API
```cpp
template<typename T> class ObscureValue {
public:
    explicit ObscureValue(const T& value);
    operator const T() const;                       // decode on read
    ObscureValue& operator=(const T& other);        // re-encode on write
private:
    ObscureValue();                                 // no default ctor
    ObscureValue(const ObscureValue&);              // no copy
    ObscureValue& operator=(const ObscureValue&);
};
```

Storage detail: values live in a union of `long asRaw[kArraySize]` / `T asBase`, where `kArraySize = max(1, sizeof(T)/sizeof(long))`. Encode/decode XORs every raw word with `reinterpret_cast<uintptr_t>(this)`.

## Gotchas
- The obfuscation key is the object's own address — trivially defeated by a determined attacker; it defeats naive memory scans only ("mildly obscures", per comment).
- Implicit conversion returns `const T` **by value**, so `obj.member = x` style mutation of the underlying value does not work; you must assign back through `operator=`.
- Copy construction/assignment and default construction are deliberately disabled (declared private, undefined) — type cannot be stored in containers requiring copies without modification.
- XOR at `long` granularity: types whose size isn't a multiple of `sizeof(long)` rely on the `kArraySize < 1 ? 1 : ...` clamp, meaning trailing bytes of the union may be uninitialized padding read during encode (benign but worth knowing when comparing raw storage).

## UNKNOWN
- Which systems hold `ObscureValue` members (usage sites outside this slice).
