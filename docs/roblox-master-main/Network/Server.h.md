# Network/Server.h

**Module**: Network (root) · **Type**: header (.h, 133 lines)

## Purpose

Declares `RBX::Network::Server` (`sServer = "NetworkServer"`), the host-side networking `Service`/`Peer` subclass: listens for RakNet connections, spawns `ServerReplicator`s per client via the swappable `createReplicator` factory, owns the legal-script allow-list used to validate replicated scripts (by source and both bytecode formats), place-authentication result caching, Cloud-Edit server mode, and the distributed-physics `NetworkOwnerJob`.

## API

```cpp
class Server : public DescribedCreatable<Server, Peer, sServer,
                                         Reflection::ClassDescriptor::INTERNAL_LOCAL>,
               public Service {
    static boost::function<shared_ptr<ServerReplicator>(SystemAddress, Server*, NetworkSettings*)> createReplicator;

    std::set<std::string> usedTickets;      // consumed auth tickets
    std::set<std::string> preusedTickets;   // tickets seen before validation completes

    bool getIsPlayerAuthenticationRequired() const; // isPlayerAuthenticationEnabled() && flag
    void setIsPlayerAuthenticationRequired(bool);

    rbx::signal<void(shared_ptr<Instance>, FilterResult, shared_ptr<Instance>, std::string)> dataBasicFilteredSignal;
    rbx::signal<void(shared_ptr<Instance>, FilterResult, shared_ptr<Instance>, std::string)> dataCustomFilteredSignal;
    rbx::signal<void(std::string, shared_ptr<Instance>)> incommingConnectionSignal; // (peerString, replicator)

    static bool serverIsPresent(const Instance* context, bool testInDatamodel=true);
    ServerReplicator* findClientOwner(const Vector3& p);
    void start(int port, int threadSleepTime);
    void stop(int blockDuration = 1000);
    void configureAsCloudEditServer();
    int getClientCount();
    int getPort() const;
    bool securityKeyMatches(const std::string& key);
    bool protocolVersionMatches(int protocolVersion);
    NetworkOwnerJob* getNetworkOwnerJob();

    static void setAllowedSecurityVersions(const std::vector<std::string>& versions);
    static std::vector<std::string> getAllIPv4Addresses();

    bool isLegalReceiveInstance(Instance*) const;
    bool isScriptLegal(Instance*) const;
    boost::optional<long> getScriptIndexForSource(const std::string&) const;
    boost::optional<long> getScriptIndexForBytecode(const std::string&, bool isCurrentFormat=true) const;
    boost::optional<ProtectedString> getScriptSourceForIndex(long) const;
    boost::optional<std::string> getScriptBytecodeForIndex(long, bool isCurrentFormat=true) const;

    boost::optional<int> getPlaceAuthenticationResultForOrigin(int originPlaceId);
    void registerPlaceAuthenticationResult(int originPlaceId, int result);

    RakNet::PluginReceiveResult OnReceive(RakNet::Packet*);
    bool isCloudEdit() const;
};
```

## Usage

- Created by RCC/Studio server boot paths (`GameConfigurer`-equivalent server configurers); reflection: `Start(port=0, threadSleepTime=20)` Plugin, `Stop(blockDuration=1000)` LocalUser, `GetClientCount`, `Port`, `SetIsPlayerAuthenticationRequired`/`ConfigureAsCloudEditServer` Roblox, events `DataBasicFiltered/DataCustomFiltered/IncommingConnection`.
- `Players::serverIsPresent` delegates here.

## Gotchas

- Only `ServerReplicator` children are accepted (`askAddChild`).
- `legalScripts` indices are shared across three lookup maps (source / current bytecode / legacy bytecode); index 0 is pre-registered as the empty script.
