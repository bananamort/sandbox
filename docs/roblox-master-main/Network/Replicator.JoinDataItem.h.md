# Network/Replicator.JoinDataItem.h

**Module**: Network (root) · **Type**: header (.h, 94 lines)

## Purpose

Declares the join-data item: the server-side queue of every instance replicated at connection setup (`Replicator::JoinDataItem`, fed by `addTopReplicationContainers`) and its deserialized counterpart (`DeserializedJoinDataItem` holding a vector of `DeserializedNewInstanceItem`). Wire format: `[ItemTypeJoinData][count][gzip blob of dictionary-less instance records]`.

## API

```cpp
#define ESTIMATED_COMPRESSION_RATIO 5.0f
// DFInt::JoinDataCompressionLevel, DFInt::JoinDataBonus (padding bytes)

class DeserializedJoinDataItem : public DeserializedItem {
    int numInstances;
    std::vector<DeserializedNewInstanceItem> instanceInfos;
    void process(Replicator&);   // → replicator.readJoinDataItem(this)
};

class Replicator::JoinDataItem : public Item {
    JoinDataItem(Replicator*);
    void setMaxInstancesToWrite(size_t);
    bool empty() const;  size_t size() const;
    void setBytesPerStep(int numBytes);      // Replicator::addTopReplicationContainers sets DFLog::MaxJoinDataSizeKB*1000
    void addInstance(shared_ptr<const Instance>);
    bool write(RakNet::BitStream&);          // false while instances remain
    static shared_ptr<DeserializedItem> read(Replicator&, RakNet::BitStream&);
protected:
    bool canUseCache(const Instance*);
    bool writeInstance(const Instance*, BitStream&);
    size_t writeInstances(BitStream&);
    void writeBonus(BitStream&, unsigned int bytes);  // zero padding (anti-size-fingerprint)
};
```

## Usage

- Server: `addInstance` registers into `pendingNewInstances` + optional `instancePacketCache`; `SendDataJob` repeatedly calls `write` until empty.
- Client: `read` decompresses and defers to `readJoinDataItem`.

## Gotchas

- Cache is skipped for server-simulated awake parts and for Scripts/ModuleScripts (ProtectedString format depends on protocol version; `BOOST_STATIC_ASSERT(NETWORK_PROTOCOL_VERSION_MIN < 28)` reminds to revisit).
- Instances are written **without** id/property dictionaries (join data precedes dictionary teaching on that path) and byte-aligned per record for cache friendliness.
