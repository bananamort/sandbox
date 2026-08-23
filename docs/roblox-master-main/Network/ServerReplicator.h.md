# Network/ServerReplicator.h

**Module**: Network (root) · **Type**: header (.h, 333 lines)

## Purpose

Declares `RBX::Network::ServerReplicator` (`sServerReplicator`) — the per-client server-side replicator created by `Server` on incoming connections — plus (under `RBX_RCC_SECURITY`) its cheat-hardened subclass `CheatHandlingServerReplicator`. It validates the join ticket, runs place authentication against the web tier, installs the remote Player, teaches descriptor dictionaries/schema to the client, applies basic filtering, tracks PropSync as Master, and consumes client anti-cheat telemetry (hash items, MCC reports, NetPmc responses, call-chain info).

## API

```cpp
enum PlaceAuthenticationState { Init, Requesting, Authenticated, Denied, DisconnectingClient };

class ServerReplicator : public DescribedNonCreatable<ServerReplicator, Replicator, ...> {
public:
    int numPartsOwned;
    rbx::signal<void(int, bool, int)> remoteTicketProcessedSignal;  // (userId, ok, ?)
    int remoteProtocolVersion;

    ServerReplicator(SystemAddress, Server*, NetworkSettings*);
    void sendTop(RakNet::RakPeerInterface* peer);        // pushes top replication containers + tags
    void setBasicFilteringEnabled(bool);
    void preventTerrainChanges();                        // acceptsTerrainChanges=false
    bool canUseProtocolVersion(int) const;
    bool isProtocolCompatible() const;
    virtual void serializeSFFlags(BitStream&) const;     // teaches FastFlags to client
    virtual void sendDictionaries();
    const PartInstance* readPlayerSimulationRegion(Region2::WeightedPoint&);  // dist. physics
    RakNet::PluginReceiveResult OnReceive(Packet*);

    // pluggable filters (wired by CheatHandling subclass / tests)
    boost::function<FilterResult(shared_ptr<Instance>, std::string, Variant)> filterProperty;
    boost::function<FilterResult(shared_ptr<Instance>, shared_ptr<Instance>)> filterNew;
    boost::function<FilterResult(shared_ptr<Instance>)> filterDelete;
    boost::function<FilterResult(shared_ptr<Instance>, std::string)> filterEvent;

    void writeDescriptorSchema(const ClassDescriptor*, BitStream&) const;
    void teachSchema();
    static RakNet::BitStream apiSchemaBitStream, apiDictionaryBitStream;  // cached schema blobs
    static void generateSchema(const ServerReplicator*, bool force);
    static void generateApiDictionary(const ServerReplicator*, bool force);
    bool isServerReplicator() { return true; }
    void onPlaceAuthenticationComplete(PlaceAuthenticationState);

protected:
    PropSync::Master propSync;
    boost::scoped_ptr<NetworkFilter> basicFilter;
    bool acceptsTerrainChanges;
    DescribedBase* lightingService;   // + GlobalShadows/OutdoorAmbient/Outlines descriptors
    std::string initialSpawnName;
    Instance* pendingCharaterRequest; Time pendingCharacterRequestStartTime;
    shared_ptr<Player> remotePlayer;
    Server* const server;
    boost::scoped_ptr<boost::thread> placeAuthenticationThread;
    PlaceAuthenticationState placeAuthenticationState;
    bool waitingForMarker, topReplicationContainersSent, remotePlayerInstalled;
    std::string gameSessionID;
    PmcHashContainer hashes; unsigned long long securityTokens[3];
    Analytics::InfluxDb::Points joinAnalytics;  void sendJoinStatsToInflux();
    void PlaceAuthenticationThread(int previousPlaceId, int requestedPlaceId);
    virtual void PlaceAuthenticationThreadImpl(...);      // web call in RCC builds
    // overridable security hooks:
    virtual void setAuthenticated(bool) {}
    virtual void decodeHashItem/processHashValue/processHashValuePost/updateHashState(...) {}
    virtual void processRockyMccReport(const MccReport&) {}
    virtual void processNetPmcResponseItem(BitStream&) {}
    virtual void processRockyCallInfoItem(BitStream&) {}

private:
    void processRequestCharacter(Instance*, Guid::Data id, unsigned sendStats, std::string spawnName);
    void readRequestCharacter/readClientQuotaUpdate/readRegionRemoval/readPropAcknowledgement(...);
    virtual void installRemotePlayer(const std::string& preferedSpawnName);
    static void installRemotePlayerSafe(weak_ptr<ServerReplicator>, std::string);
    void sendDictionaryFormat();
    void readHashItem/readRockyItem(...);
    static void toggleSendStatsJob(weak_ptr<ServerReplicator>, bool required, int version);

    Player* findTargetPlayer() const { return remotePlayer.get(); }
    Player* getRemotePlayer() const  { return remotePlayer.get(); }
};

#if defined(RBX_RCC_SECURITY)
class CheatHandlingServerReplicator : public ServerReplicator {
    bool isAuthenticated, isBadTicket, processedTicket;
    std::string ticket; int userIdFromTicket;
    unsigned int reportedGoldHash, hashNonce, ignoreHashFailureMask, ignoreGoldHashFailureMask,
                 sendStatsMask, extraStatsMask, apiStatsMask, mccStatsMask;
    RBX::Security::NetPmcServer netPmc;
    ServerFuzzySecurityToken securityToken, apiToken; unsigned long long prevApiToken;
    std::vector<CallChainSetInfo> reportedCallChains;   // handler[4]+ret[4] sets
    HashVector lastHashes; size_t numHashItems, numMccItems, numPingItems;
    // reported* booleans for one-shot GA reporting ...
    RakNet::PluginReceiveResult OnReceive(Packet*) override;   // intercepts ID_SUBMIT_TICKET
    void processTicket(RakNet::Packet*);
    void processSendStats(unsigned, unsigned); processHashStats(unsigned);
    void processGoldHashStats(unsigned); processApiStats(unsigned long long);
    void preauthenticatePlayer(int userId);
    void doRemoteSysStats/doDelayedSysStats(unsigned sendStats, unsigned mask, codeName, details, configString=DFString::US30605p1);
    bool canSendItems() override { return processedTicket; }   // gate on ticket
};
#endif
```

## Usage

- Join flow: `Server::OnReceive(ID_NEW_INCOMING_CONNECTION)` → factory creates replicator → client sends ticket (`ID_SUBMIT_TICKET`, intercepted by `CheatHandlingServerReplicator::OnReceive`→`processTicket`) → place authentication thread → `installRemotePlayer(preferedSpawnName)` creates/parents the `Player` and answers the character request with join data.
- `Players::disconnectPlayer` finds this object via `findTargetPlayer()->getUserID()`.

## Gotchas

- Base-class security hooks are no-ops; only `RBX_RCC_SECURITY` builds get real ticket validation via `CheatHandlingServerReplicator`.
- Static `apiSchemaBitStream`/`apiDictionaryBitStream` are process-wide caches — schema generation must be forced after FastFlag changes that affect reflection.
- Typo preserved from source: member `pendingCharaterRequest`.
