# Network/Client.h

**Module**: Network (root) · **Type**: header (.h, 64 lines)

## Purpose

Declares `RBX::Network::Client` (`sClient = "NetworkClient"`, registered in API.cpp) — the client-side networking `Service`/`Creatable` wrapping a RakNet peer (`Peer` base). It owns the outbound join handshake (connect → ticket → spawn name), the signals consumed by `PlayerConfigurer`, and Cloud-Edit state.

## API

```cpp
class Client : public DescribedCreatable<Client, Peer, sClient,
                                          Reflection::ClassDescriptor::INTERNAL_LOCAL>,
               public Service {
    rbx::signal<void(std::string, shared_ptr<Instance>)> connectionAcceptedSignal; // (peer, replicator)
    rbx::signal<void(std::string, int, std::string)>     connectionFailedSignal;  // (peer, code, reason)
    rbx::signal<void(std::string)>                        connectionRejectedSignal;// (peer)

    void setTicket(const std::string& t);                 // stores join ticket (prop "Ticket", Authentication category)
    shared_ptr<Instance> playerConnect(int userId, std::string server,
                                       int serverPort, int clientPort, int threadSleepTime);
    void disconnect(int blockDuration);
    void disconnect();                                    // blockDuration=3000
    void setGameSessionID(std::string gameSessionID);
    void configureAsCloudEditClient();
    bool isCloudEdit() const;

    RakNet::PluginReceiveResult OnReceive(RakNet::Packet*);          // override
    void OnFailedConnectionAttempt(RakNet::Packet*, RakNet::PI2_FailedConnectionAttemptReason);

    static Client* findClient(const Instance* context, bool testInDatamodel=true);
    static bool clientIsPresent(const Instance* context, bool testInDatamodel=true);
    static const SystemAddress findLocalSimulatorAddress(const Instance* context);
    static bool physicsOutBandwidthExceeded(const Instance* context);
    static double getNetworkBufferHealth(const Instance* context);

private:
    RakNet::SystemAddress serverId;
    int userId;
    std::string ticket;
    NetworkSettings* networkSettings;
    bool isCloudEditClient;
    void sendVersionInfo();       // ID_PROTOCOL_SYNC + protocolVersion
    void sendTicket();            // ID_SUBMIT_TICKET payload
    void sendPreferedSpawnName(); // ID_SPAWN_NAME
    void HandleConnection(RakNet::Packet*);
};
```

## Usage

- Created by `PlayerConfigurer::configure` / Studio play flows; `GameConfigurer` wires its three signals and calls `setTicket` → `setGameSessionID` → `playerConnect`.
- `Players::clientIsPresent` and `Network/API.cpp isNetworkClient` delegate to `findClient`.

## Gotchas

- Constructor requires `Security::Plugin` permission ("create a NetworkClient").
- `INTERNAL_LOCAL` creatable: not scriptable/creatable from Lua.
- Header exposes only state; all packet IDs used by the impl live in `PacketIds.h`/RakNet messages.
