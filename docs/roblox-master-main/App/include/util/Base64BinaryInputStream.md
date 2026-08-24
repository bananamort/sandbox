# util/Base64BinaryInputStream.h

## Purpose
Bit-level reader over a base64-encoded character stream: decodes standard base64 chars back into raw bits and hands them out in 1–8 bit chunks. Counterpart to `Base64BinaryOutputStream`.

## Declared API
```cpp
struct Base64BinaryInputStream {
    explicit Base64BinaryInputStream(const char* source);   // NUL-terminated? see Gotchas

    // numBitsToRead must satisfy: 1 <= numBitsToRead <= 8
    void ReadBits(unsigned char* out, size_t numBitsToRead);
private:
    const char* source;
    boost::uint16_t buffer;          // holds decoded bits awaiting consumption
    size_t readableBitsInBuffer;
    static unsigned char decode(unsigned char charFromString);
};
```

## Gotchas
- `ReadBits` is contract-limited to 1–8 bits per call; larger requests are UB/precondition violation.
- Takes a bare `const char*` — lifetime of the underlying string must outlive the stream object; whether the ctor requires NUL termination is an implementation detail (UNKNOWN).
- No EOF signaling in the declared interface: reading past the encoded data's end behavior is unspecified here (UNKNOWN).

## UNKNOWN
- Which serialization format pairs with this (bit-packed property streams) and its .cpp location.
