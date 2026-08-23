# Network/Replicator.h

**Module**: Network (root) · **Type**: header (.h, 681 lines)

## Purpose

Declares `RBX::Network::Replicator` (`sReplicator`), the abstract base of `ClientReplicator` and `ServerReplicator` and the heart of DataModel replication: it owns the per-connection replication containers, the reflection dictionaries (class/prop/event/type) used for wire compression, the item queues (join data, new/delete instance, change property, event invocation, marker, ping/stats/hash "Rocky" items), cluster/terrain delta streaming, physics sender/receiver wiring, packet deserialization thread, and the protocol-version negotiation constants. Also defines `DeserializedPacket`, `ReplicationData`, `ClusterReplicationData`, and base class `ReplicatorJob`.

## API

### Protocol constants (this header is their definition site)

```cpp
#define NETWORK_PROTOCOL_VERSION_MIN 24   // Release 0.157
#define NETWORK_PROTOCOL_VERSION    34
#define REPLICATED_FIRST_FINISHED_TAG     12
#define TOP_REPLICATION_CONTAINER_FINISHED_TAG 13
```

### Class shape

```cpp
class Replicator : public DescribedNonCreatable<Replicator, IdSerializer, sReplicator, INTERNAL_LOCAL>,
                   public RakNet::PluginInterface2, public RBX::IMetric,
                   public Voxel::CellChangeListener, public Voxel2::GridListener {
    enum DisconnectReason { BadHash, SecurityKeyMismatch, ProtocolMismatch, ReceivePacketError,
        ReceivePacketStreamError, SendPacketError, IllegalTeleport, DuplicatePlayer,
        DuplicateTicket, TimeOut, LuaKick, OnRemoteSysStats, HashTimeOut, CloudEditKick };
    enum PropertyCacheType { All, NonCacheable, Cacheable };

    struct ReplicationData      { shared_ptr<Instance> instance; connection; bool deleteOnDisconnect;
                                  bool replicateChildren:1; bool listenToChanges:1; };
    struct ClusterReplicationData { ClusterUpdateBuffer updateBuffer; smooth set; initial iterators; hasDataToSend(); };

    boost::shared_ptr<ConcurrentRakPeer> rakPeer;
    RakNet::SystemAddress const remotePlayerId;
    ReplicatorStats replicatorStats;

    // pure virtual contract for subclasses
    virtual bool checkDistributedReceive/Send/SendFast(PartInstance*) = 0;
    virtual Player* findTargetPlayer() const = 0;
    virtual Player* getRemotePlayer() const = 0;
    virtual void setPropSyncExpiration(double) = 0;
    virtual bool canUseProtocolVersion(int) const = 0;
    virtual bool isProtectedStringEnabled() = 0;
    virtual std::string encodeProtectedString(...); virtual optional<ProtectedString> decodeProtectedString(...);
    virtual bool isLegalSendProperty(...) = 0;
    virtual bool isCloudEdit() const = 0;
    virtual shared_ptr<Stats> createStatsItem() = 0;
    virtual bool canSendItems() = 0;

    // public API
    void requestDisconnect(DisconnectReason);        // defers Parent=NULL via task submit
    void requestDisconnectWithSignal(DisconnectReason);
    void closeConnection();
    shared_ptr<Instance> sendMarker();
    bool isInitialDataSent();
    RakNet::PluginReceiveResult OnReceive(RakNet::Packet*);
    void OnInternalPacket(...);                       // requires UsesReliabilityLayer()==true
    bool processNextIncomingPacket();
    size_t getAdjustedMtuSize() const;  size_t getPhysicsMtuSize() const;
    unsigned int getApproximateSizeOfPendingClusterDeltas() const;
    int getPort() const; std::string getIpAddress() const;
    double getRakOffsetTime();                        // rakTimeOffset clock sync
    RBX::Time remoteRaknetTimeToLocalRbxTime(const RemoteTime&);
    std::string getMetric(const std::string&) const;  double getMetricValue(const std::string&) const;
    static bool isTopContainer(const Instance*);
    virtual void addTopReplicationContainers(ServiceProvider*);
    virtual void sendDictionaries();
    static void teachDictionaries(const Replicator*, BitStream&, bool teachSchema, bool toBeCompressed);
    void sendDisconnectionSignal(std::string peer, bool lostConnection);
    bool isInStreamedRegions(const Extents&) const;  bool isAreaInStreamedRadius(...) const;

protected:
    // item classes implemented in Replicator.*.cpp files
    class ChangePropertyItem; DeleteInstanceItem; EventInvocationItem; JoinDataItem; MarkerItem;
    TagItem; NewInstanceItem; ReferencePropertyChangedItem; StatsItem; ProcessPacketsJob; PingBackItem;
    PingItem; HashItem; PingJob; RockyItem; SendDataJob; StreamJob; SendClusterJob; NetPmcResponseItem/
    ChallengeItem/RockyDbgItem (#ifdef'd);

    DescriptorDictionary<...> classDictionary/propDictionary/eventDictionary/typeDictionary;
    RepConts replicationContainers;             // Instance* → ReplicationData
    TopReplConts topReplicationContainers;      // ordered top-most replication containers
    ItemQueue pendingItems, highPriorityPendingItems;
    PendingPropertyChanges pendingChangedPropertyItems;  PendingInstances pendingNewInstances;
    rbx::timestamped_safe_queue<RakNet::Packet*> incomingPackets;
    rbx::timestamped_safe_queue<DeserializedPacket> deserializedPackets; // fed by deserializePacketsThread
    SharedDictionary<SystemAddress> systemAddressDictionary; SharedDictionary<ContentId> contentIdDictionary;

    // read/write plumbing
    void readProperties/writeProperties(...PropertyCacheType, useDictionary, preventBounceBack...);
    unsigned int readJoinData(RakNet::BitStream&);            // returns protocol version
    virtual void receiveCluster(BitStream&, Instance*, bool usingOneQuarterIterator);
    static void compressBitStream/decompressBitStream(...uint8_t compressRatio);
    virtual FilterResult filterReceivedChangedProperty/filterReceivedParent/filterPhysics/filterChangedProperty(...);
    virtual bool ProcessOutdated* (...);                      // hooks for newer-protocol clients (ServerReplicator)
};
class ReplicatorJob : public DataModelJob { protected: shared_ptr<Replicator> replicator;
    static bool canSendPacket(shared_ptr<Replicator>&, PacketPriority); };
```

## Usage

- Every replication message between client and server flows through here: outbound via `SendDataJob`/`SendClusterJob` flushing `pendingItems`; inbound via `OnReceive` → `pushIncomingPacket` → (optional `deserializePacketsThread`) → `ProcessPacketsJob` → `processDeserializedPacket` dispatching to the typed `read*/read*Item` methods.
- `DisconnectReason` codes are the shared vocabulary for kicks across Players/ClientReplicator/ServerReplicator.

## Gotchas

- The dictionary design means **both ends must learn identical dictionaries** in identical order (`teachDictionaries`/`learnDictionaries`) — any divergence corrupts every subsequent compressed id.
- `UsesReliabilityLayer()` must stay true or `OnInternalPacket` (loss stats) never fires.
- `requestDisconnect` deliberately does NOT null the parent synchronously: unsafe contexts like `RakPeerInterface::OnUpdate` defer through a DataModel task.
- Many inner item classes live in separate translation units (`Replicator.NewInstanceItem.cpp` etc.) — this header only forward-declares their Deserialized counterparts.
