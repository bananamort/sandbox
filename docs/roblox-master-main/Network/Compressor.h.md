# Network/Compressor.h

**Module**: Network (root) · **Type**: header (.h, 32 lines)

## Purpose

Declares `RBX::Network::Compressor`, a static utility class for writing/reading CFrame position+orientation onto RakNet `BitStream`s under three compression tiers: `UNCOMPRESSED` (raw floats), `RAKNET_COMPRESSED` (RakNet norm-quat / vector encoding), `HEAVILY_COMPRESSED` (fixed-point 15/14/15-bit translation within ±1024/±512/±1024).

## API

```cpp
class Compressor {
public:
    typedef enum {UNCOMPRESSED = 0, RAKNET_COMPRESSED, HEAVILY_COMPRESSED} CompressionType;
    static void writeTranslation(RakNet::BitStream&, const Vector3&, CompressionType);
    static void writeRotation(RakNet::BitStream&, const Matrix3&, CompressionType);
    static void readTranslation(RakNet::BitStream&, Vector3&);
    static void readRotation(RakNet::BitStream&, Matrix3&);
private:
    static bool canHeavilyCompressTranslation(const Vector3&);
    static void writeCompressionType(RakNet::BitStream&, CompressionType);   // 2 bits
    static CompressionType readCompressionType(RakNet::BitStream&);
};
```

## Usage

Used by physics replication (PhysicsSender/PhysicsReceiver family) and anywhere PVs cross the wire. The compression type is written inline before each value so readers self-describe.

## Gotchas

- Readers throw `std::runtime_error` on malformed quats (`ReadNormQuat` failure) — callers must be exception-safe.
