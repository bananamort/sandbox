# util/BinaryString.h

## Purpose
Marker wrapper for property values containing raw binary data, so XML serialization can encode them (e.g., base64) without round-trip corruption. Holds the bytes verbatim in a `std::string`.

## Declared API
```cpp
class BinaryString {
public:
    BinaryString();
    explicit BinaryString(const std::string& value);
    const std::string& value() const;
    void set(const char* buffer, unsigned int size);
    bool operator==(const BinaryString& other) const;
    bool operator!=(const BinaryString& other) const;
    bool operator<(const BinaryString& other) const;   // enables map/set keys
private:
    std::string internalValue;
};
```

## Gotchas
- The payload is arbitrary binary stored in a `std::string` — never treat `value()` as text (no NUL-termination guarantees, may contain embedded NULs).
- `explicit` ctor from string: no accidental implicit conversion from plain strings.
- Comparison operators are byte-wise lexicographic on the raw buffer.
- `set` takes an `unsigned int` size — >4 GiB payloads not representable.

## UNKNOWN
- Where XML/serialization decides to base64-encode (serializer side outside this slice).
