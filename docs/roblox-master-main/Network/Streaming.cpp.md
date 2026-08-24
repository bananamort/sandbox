# Network/Streaming.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 1614 lines)

## Purpose

Implements everything declared in Streaming.h plus the `StreamingUtil.h` operator family: RakNet BitStream `operator<</>>` for all RBX types, enum index coding with overflow-to-0 handling, Huffman-compressed strings (`RakNet::StringCompressor`, `MAX_STRING_SIZE` 200 000; disable via `SFFlag::NetworkDisableStringCompression`), BinaryStrings (512 KB cap, byte-aligned), the special "brick location" 33-bit Vector3 packing for `PartInstance::Size`, CoordinateFrame coding (rationalized translation + axis-aligned 6-bit orientation id or four Float16 quaternion components — `LOSSY_QUAT` experiment disabled because it corrupted places), StreamRegion::Id small/large encoding, sequences/ranges/PhysicalProperties, and the `IdSerializer`/`DescriptorSender/Receiver<T>` machinery with per-template `learnName` specializations that resolve names to live descriptors and set `isOutdated` flags from CRC checksums.

## API

```cpp
DFInt::PhysicsCompressionSizeFilter = 50
SFFlag NetworkAlignBinaryString(true), NetworkDisableStringCompression(false)

void serializeEnumIndex/deserializeEnumIndex(desc, index&, stream, enumSizeMSB=0); // MSB+1 bits, overflow→0+error log
void serializeEnum/deserializeEnum(...); void serializeEnumProperty/deserializeEnumProperty(...);
void serializeStringCompressed/deserializeStringCompressed(std::string&, stream);  // throws >200 KB
void writeBrickVector/readBrickVector(stream, Vector3&);   // snap test: x,z∈[-512,512] step .5, y∈[0,204.8) step .1 → 3×11 bits
void rationalize(CoordinateFrame&);                        // NaN→(0,-1e6,0); clamp to ±1e6
const int orientationBits = 6;

// IdSerializer
bool trySerializeId(stream, instance); bool canSerializeId(instance);
Id extractId(instance); void sendId(stream, Id);
void serializeId(stream, const Instance*|Guid::Data); void serializeIdWithoutDictionary(...); // code byte: 0=null,255=serverScope,else len-prefixed scope string +32-bit index
void deserializeId / deserializeIdWithoutDictionary(stream, Guid::Data&);
bool deserializeInstanceRef(stream, shared_ptr<Instance>&, Guid::Data&);
void addPendingRef(desc, instance, id); void resolvePendingReferences(instance, id);

// DescriptorSender<T> ctors enumerate ALL descriptors of T at construction (Class/Property/Event/Type)
template<> learnName<ClassDescriptor|EventDescriptor|PropertyDescriptor|Type>(name, id, checksum);
```

## Usage

- This is the byte-level contract for every packet in the module; both sides must agree on every format here.
- Dictionary learning marks descriptors outdated via CRC mismatch, which later drives ClientReplicator's schema-skip paths.

## Gotchas

- `deserializeStringCompressed` uses `alloca(size+1)` on attacker-controlled length (capped at 200 KB) — stack pressure risk.
- Guid scope strings are limited to <255 bytes by assertion in `serializeIdWithoutDictionary`.
- Brick snapping uses exact float compares on x/z but fuzzy on y (documented round-off asymmetry).
