# util/VarInt.h

## Purpose
Configurable-window variable-length integer codec for bit streams: encodes an unsigned int as groups of `WindowSize` data bits plus a 1-bit continuation flag (default window = 4 bits ⇒ 5 bits per group). Works over the Base64Binary-style bit streams (`WriteBits`/`ReadBits`).

## Declared API
```cpp
template<int WindowSize = 4>
struct VarInt {
    static const unsigned char kDataMask = (1 << WindowSize) - 1;
    static const unsigned char kFlagMask = (1 << WindowSize);

    template<class OutputStream>
    static void encode(OutputStream& out, unsigned int count);
        // asserts WindowSize < 8; emits low group first; flag set while more remain

    template<class InputStream>
    static void decode(InputStream& in, unsigned int* out);
        // accumulates groups LSB-first until flag clears
};
```

## Gotchas
- Requires stream types exposing `WriteBits`/`ReadBits` with the (data, numBits) signature — pairs with Base64BinaryOutputStream.md / Base64BinaryInputStream.md.
- In-header TODO: a faster `Network::readFastN` path is commented out pending a streaming.h include move.
- `WindowSize < 8` asserted: a full byte would leave no room for the continuation flag.
- Max ~7 groups for 32-bit values at default window 4 — small numbers cost 1 byte-ish (5 bits).
- Includes Network/api.h — couples this util to the Network slice.

## UNKNOWN
- Where VarInt wire format is used (network replication of counts, presumably).
