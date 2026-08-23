# Network/Peer.h

**Module**: Network (root) · **Type**: header (.h, 61 lines)

## Purpose

Declares `RBX::Network::Peer` (`sPeer = "NetworkPeer"`), the common base of `Client` and `Server`. It fuses an RBX `Instance` with RakNet's `PluginInterface2` (so packet callbacks dispatch into the instance tree), owns the shared `ConcurrentRakPeer`, the static AES key used for ticket/data-packet encryption, and the task-scheduler receive job.

## API

```cpp
class Peer : public Reflection::Described<Peer, sPeer, Instance>,
             public RakNet::PluginInterface2 {
public:
    RunningAverageDutyCycle<> rakDutyCycle;          // sampled by ProfiledRakPeer each RakNet update cycle
    boost::shared_ptr<ConcurrentRakPeer> rakPeer;

    void setOutgoingKBPSLimit(int limit);
    void encryptDataPart(RakNet::BitStream& bitStream);
    static void decryptDataPart(RakNet::BitStream& bitStream);

protected:
    int protocolVersion;                             // NETWORK_PROTOCOL_VERSION
    Peer();
    ~Peer();
    virtual void onCreateRakPeer();                  // called after rakPeer is created
    bool askAddChild(const Instance* instance) const; // only Replicator children allowed
    void onServiceProvider(ServiceProvider* old, ServiceProvider* newP);

private:
    shared_ptr<PacketReceiveJob> receiveJob;
    static unsigned char aesKey[16];
    RakNet::RakNetRandom rnr;                        // seeded from local RakNetGUID
};
```

## Usage

- `Client`/`Server` constructors rely on `Peer()` to initialize `protocolVersion = NETWORK_PROTOCOL_VERSION`; both override `onCreateRakPeer` after `Peer::onServiceProvider` constructs the `ConcurrentRakPeer(new ProfiledRakPeer(...))`.
- `encryptDataPart`/`decryptDataPart` are used by the join handshake (`Client::sendTicket`) and matching server-side decode paths.

## Gotchas

- The AES key is a hardcoded trivially-derived constant: `aesKey[i] = 0xFE ^ 7*i` — "encryption" here is obfuscation only.
- Header includes `Streaming.h`, `Item.h`, `NetworkSettings.h`, `Network/api.h` — pulling in Peer.h transitively includes much of the Network module.
