# Network/ClientReplicator.h

**Module**: Network (root) · **Type**: header (.h, 318 lines)

## Purpose

Declares `RBX::Network::ClientReplicator` (`sClientReplicator`), the per-connection replicator created by `Client::HandleConnection` and parented under the `Client`. It is the client-side half of replication: receives join data/globals from the server, requests characters (`RequestCharacter`), streams terrain/instances in and out based on memory quota, runs memory-hash ("rocky"/NetPmc) checks against server challenges, performs property-sync acknowledgement (`PropSync::Slave`), GC of streamed regions, and implements the full protocol-schema negotiation machinery (learning server classes/props/enums it doesn't know and skipping their wire bytes).

## API

```cpp
const float kMaxIncomePacketWaitTime = 0.25f;

class ClientReplicator : public DescribedNonCreatable<ClientReplicator, Replicator, ...> {
public:
    rbx::signal<void()> receivedGlobalsSignal;    // fired when ID_SET_GLOBALS processed
    rbx::signal<void()> gameLoadedSignal;         // fired when initial replication done
    rbx::signal<void(shared_ptr<const Reflection::ValueTable>)> statsReceivedSignal;

    ClientReplicator(RakNet::SystemAddress systemAddress, Client* client,
                     RakNet::SystemAddress clientAddress, NetworkSettings* networkSettings);
    void requestServerStats(bool request);
    void requestCharacter();            // queues RequestCharacterItem
    void requestCharacterImpl();
    void updateClientCapacity();        // streaming capacity updates to server
    RakNet::PluginReceiveResult OnReceive(RakNet::Packet*);
    bool canUseProtocolVersion(int) const;
    shared_ptr<Instance> sendMarker();  // also fires markerReceived bookkeeping
    const RakNet::SystemAddress getClientAddress() const;
    bool isLimitedByOutgoingBandwidthLimit() const;
    void writePropAcknowledgementIfNeeded(instance, desc, outBitStream); // PropSync ack
    void renderStreamedRegions(Adorn*); void renderPartMovementPath(Adorn*); // debug viz
    RBX::MemoryStats::MemoryLevel getMemoryLevel();
    void updateMemoryStats();
    int getNumRegionsToGC() const; short getGCDistance() const; int getNumStreamedRegions() const;

protected:
    PropSync::Slave propSync;
    bool isProtectedStringEnabled(); encodeProtectedString(...); decodeProtectedString(...); // client never encodes: decode-only
    FilterResult filterChangedProperty/filterReceivedParent(...);
    Player* findTargetPlayer() const;   // Players::findLocalPlayer
    Player* getRemotePlayer() const { return NULL; }
    void readTag/processTag(int);       // TOP_REPLICATION_CONTAINER_FINISHED_TAG etc.
    void readRockyItem(...)/processRockyItem(...); static void doNetPmcCheck(...); // NetPmc memory check
    void readStreamData/readStreamDataItem/processStreamDataRegionId/streamOutTerrain/
        streamOutInstance/streamOutPartHelper/streamOutAutoJointHelper;
    bool needGC(); bool hasEnoughMemoryToReceiveInstances();

private:
    // protocol schema containers
    class ReflectionClassContainer { id, name, replicationLevel, properties, events };
    class ReflectionPropertyContainer { needSync, id, name, typeId, typeName, type, canReplicate, enumMSB };
    class ReflectionEventContainer { needSync, id, name, argTypes };
    class ReflectionEnumContainer { enumMSB };
    ReflectionClassMap serverClasses;  ReflectionEnumMap serverEnums; InstanceClassMap serverInstanceClassMap;
    DummyPropertyStrings dummyStrings; ... // string dictionaries for unknown server props/events
    void learnSchema(RakNet::BitStream&);
    void skipPropertyValue/skipPropertiesInternal/skipChangedProperty/skipEventInvocation(...);
    bool getServerBasedProperty/getServerBasedEvent(...);
    bool hasEnumChanged(const EnumDescriptor&, size_t& newMSB);
};
```

## Usage

- Created in `Client::HandleConnection` after ticket send; GameConfigurer connects its `disconnectionSignal`, `receivedGlobalsSignal`, `gameLoadedSignal`.
- Streaming: `streamJob` (from Replicator.StreamJob.h) plus `clientInstanceQuota`, `pendingInstanceRequests`, `numInstancesRead` drive region request/GC; low-memory warnings via `loggedLowMemWarning`.

## Gotchas

- `getRemotePlayer()` returns NULL by design — there is no remote Player on the client; code must use `findTargetPlayer()` for the local player.
- The schema-negotiation block means a newer server can replicate classes/properties this client has never heard of: they are recorded in `serverClasses` and silently skipped byte-exact (`skipPropertyValue`) with per-descriptor dummy dictionaries.
- UNKNOWN: exact semantics of `PropSync::Slave` expiration (Util/PropertySynchronization.h context).
