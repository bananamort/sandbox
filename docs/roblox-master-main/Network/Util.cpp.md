# Network/Util.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 22 lines)

## Purpose

Tiny conversion helpers bridging RakNet's `SystemAddress` and Roblox's own `RBX::SystemAddress` (`Util/SystemAddress.h`), used all over the Network module when logging or storing peer endpoints.

## API

```cpp
namespace RBX::Network {
    const RBX::SystemAddress RakNetToRbxAddress(const RakNet::SystemAddress& raknetAddress);
    std::string RakNetAddressToString(const RakNet::SystemAddress& raknetAddress,
                                      bool writePort = true, char portDelineator='|');
}
```

- `RakNetToRbxAddress` copies binary address + port into the RBX type.
- `RakNetAddressToString` calls `RakNet::SystemAddress::ToString(writePort, buffer, portDelineator)` with a 30-byte stack buffer and returns it as `std::string`.

## Usage

Free functions in `RBX::Network`; called by replication/physics code that needs printable peer addresses (e.g. disconnect logs) or an engine-native address type.

## Gotchas

- The 30-char stack buffer is sized for IPv4 dotted-quad plus port; IPv6 representations will not fit — UNKNOWN whether any caller passes IPv6 addresses.
- Default `portDelineator` is `'|'`, not the usual `:` — output format differs from standard `ip:port`.
