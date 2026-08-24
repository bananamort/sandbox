# Network/Streaming.h

**Module**: Network (root) · **Type**: header (.h, 523 lines)

## Purpose

Declares the wire-format toolkit used across Network: compressed string helpers, the `DescriptorSender`/`DescriptorReceiver`/`DescriptorDictionary` templates (id-compressed reflection descriptor dictionaries with CRC32 schema checksums), `IdSerializer` (the Replicator base providing guid serialization/deserialization plus pending-reference resolution), property serialize/deserialize template specializations, enum/guid-scope helpers, and the header-inline `CustomSerializer` lossy float/vector/quat compressors used by physics senders.

## API

```cpp
void serializeStringCompressed/deserializeStringCompressed(std::string&, BitStream&);

template<class T> class DescriptorSender {
    struct IdContainer { uint32_t id; bool outdated; };   // outdated ⇒ id = all-1s sentinel
    IdContainer getId(const T*) const;
    void teach(BitStream&, bool exchangeChecksum, bool useRakString) const;  // CRC32 per ClassDescriptor
    void send(BitStream&, uint32_t id);   // raw idBits
};
template<class T> class DescriptorReceiver {
    void learn(BitStream&, bool, bool);   // idBits = MSB(count)+1
    unsigned int receive(BitStream&, const T*&, bool versionCheck) const;  // outdated ⇒ NULL value
    bool verifyChecksum(const T*, uint32_t);
};
template<class T> class DescriptorDictionary : Sender, Receiver, noncopyable {};

class IdSerializer : public Instance {          // base of Replicator
    struct Id { bool valid; Guid::Data id; };
    Id extractId(const Instance*);
    void sendId/serializeId/serializeIdWithoutDictionary/trySerializeId/canSerializeId(...);
    void deserializeId/deserializeIdWithoutDictionary(BitStream&, Guid::Data&);
    bool deserializeInstanceRef(BitStream&, shared_ptr<Instance>&, Guid::Data&);  // false = unknown guid
    void resolvePendingReferences(Instance*, Guid::Data);
    void addPendingRef(const RefPropertyDescriptor*, shared_ptr<Instance>, Guid::Data);
protected:
    SharedGuidDictionary scopeNames; Guid::Scope serverScope;
    intrusive_ptr<GuidItem<Instance>::Registry> guidRegistry;
    WaitItemMap waitItems;   // refs waiting on streamed-in objects (mutex-guarded)
};

namespace CustomSerializer {  // inline, physics-facing
    writeCompressedFloat/readCompressedFloat(heavy: byte, light: ushort, sign bit)
    writeVector/readVector      // magnitude + 2 compressed direction components + z-sign reconstruction
    writeNormQuat/readNormQuat  // w reconstructed from x,y,z + sign bit
}
```

Also free functions `writeBrickVector/readBrickVector`, `serializeEnum(Property)`, `deserializeEnum(Property)`, `serializeGuidScope`, and generic `serialize<T>/deserialize<T>` property templates with specializations for ContentId, BrickColor, UDim(2), RbxRay, Faces, Axes.

## Usage

- Every Replicator inherits `IdSerializer`; dictionaries are taught once (`ID_TEACH_DESCRIPTOR_DICTIONARIES`) then referenced by `idBits`-wide ids.
- Physics senders/receivers use `CustomSerializer` for velocity/quaternion compression.

## Gotchas

- Lossy compression is genuinely lossy: heavy mode is 8-bit per component with min-delta biasing; vectors above `DFInt::PhysicsCompressionSizeFilter` magnitude fall back to short precision to avoid desync.
- Dictionary receive with `versionCheck=true` NULLs outdated entries — callers must handle NULL descriptors (the ProcessOutdated* hooks exist for this).
