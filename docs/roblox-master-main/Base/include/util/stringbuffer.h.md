# stringbuffer.h

## Purpose
Minimal iostream-style byte readers/writers over std::string: StringReadBuffer walks a const string with `>>` for unsigned char (throwing past-end), StringWriteBuffer accumulates bytes with `<<`. Used by hand-rolled binary serialization spots.

## API
```cpp
class RBX::StringReadBuffer {
    StringReadBuffer(const std::string&);       // binds reference; iterator to begin
    StringReadBuffer& operator>>(unsigned char&); // throws RBX::runtime_error past end
    bool eof();
};
class RBX::StringWriteBuffer {
    StringWriteBuffer();
    StringWriteBuffer& operator<<(unsigned char);
    const std::string& str();
};
```

## Usage
Byte-granular encode/decode helpers where full streams are overkill. UNKNOWN exact call sites in this pruned tree (grep outside Base needed).

## Gotchas
- ReadBuffer stores a const REFERENCE — binding a temporary string yields a dangling buffer after the statement.
- Only unsigned char overloads exist; reading other types silently picks the uchar overload on implicit conversions.
- No bounds reserve on write side; heavy << loops reallocate like plain std::string.
