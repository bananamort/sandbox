# util/Base64BinaryOutputStream.h

## Purpose
Bit-level writer that accumulates 1–8 bit chunks and emits them base64-encoded into an internal `std::ostringstream`. Counterpart to `Base64BinaryInputStream`.

## Declared API
```cpp
struct Base64BinaryOutputStream {
    Base64BinaryOutputStream();

    // NOT A REAL IMPLEMENTATION -- ONLY PRESENT TO SATISFY TEMPLATES
    size_t GetNumberOfBytesUsed() const;

    // numBitsToAdd must satisfy: 0 <= numBitsToAdd <= 8.
    // Only the character immediately pointed to by data is read.
    void WriteBits(const unsigned char* data, size_t numBitsToAdd);

    // Call exactly once, when no more WriteBits will happen:
    void done(std::string* out);
private:
    static const char* kTranslateToBase64;   // standard alphabet
    std::ostringstream result;
    unsigned char buffer;
    size_t bitsUsed;
};
```

## Gotchas
- `GetNumberOfBytesUsed()` is explicitly documented as a stub "ONLY PRESENT TO SATISFY TEMPLATES" — do not rely on it for real byte counts.
- `done()` must be called exactly once (it flushes the partial final group with padding); calling WriteBits after done() or done() twice is unsupported.
- Bits are taken from a single `unsigned char` per call — multi-byte values must be written in multiple calls (caller owns endianness).

## UNKNOWN
- Consumer format(s) — pairs with Base64BinaryInputStream.md; .cpp not under App/include.
