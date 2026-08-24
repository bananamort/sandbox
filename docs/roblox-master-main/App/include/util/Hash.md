# util/Hash.h

## Purpose
Simple string/byte hash utility based on "a simple hash function from Robert Sedgewick's Algorithms in C book", with incremental append variants for building hashes piecewise.

## Declared API
```cpp
class Hash {
public:
    static unsigned int hash(const void* data, size_t bytes);
    static unsigned int hash(const std::string& str);

    static void hashAppend(unsigned int& currentHash, const void* data, size_t bytes);
    static void hashAppend(unsigned int& currentHash, unsigned int append);
};
```

## Gotchas
- 32-bit non-cryptographic hash; not for security or content addressing where collision resistance matters.
- `hashAppend` mutates the caller's `currentHash` accumulator — chain calls to combine fields.
- The `unsigned int` overload of `hashAppend` presumably appends the raw 4 bytes (endianness-dependent).

## UNKNOWN
- Exact Sedgewick variant/constants used (implementation .cpp outside App/include).
