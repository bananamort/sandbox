# util/SystemAddress.h

## Purpose
Minimal IPv4 endpoint value type (binary address + port), mirroring RakNet's SystemAddress but namespaced under RBX ("RakNet doesn't namespace this - ouch"). Default state is 255.255.255.255:65535 ("empty").

## Declared API
```cpp
namespace RBX {
class SystemAddress {
public:
    unsigned int   binaryAddress;   // from inet_addr
    unsigned short port;

    SystemAddress();                // 0xFFFFFFFF / 0xFFFF (empty)
    SystemAddress(unsigned int binaryAddress, unsigned short port);

    bool empty() const;             // == default sentinel
    void clear();                   // reset to sentinel
    unsigned int   getAddress() const;
    unsigned short getPort() const;

    bool operator==(const SystemAddress&) const;   // .cpp-defined
    bool operator!=(const SystemAddress&) const;
    bool operator> (const SystemAddress&) const;
    bool operator< (const SystemAddress&) const;
};
}
```

## Gotchas
- Members are public and non-const — mutable record semantics.
- "Empty" is the broadcast-ish sentinel 0xFFFFFFFF/0xFFFF, not zero.
- Ordering operators defined in .cpp (likely addr-then-port lexicographic).
- No IPv6 support.

## UNKNOWN
- Exact comparison ordering rules (.cpp-side).
