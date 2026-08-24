# Network/ConcurrentRakPeer.h

**Module**: Network (root) · **Type**: header (.h, 112 lines)

## Purpose

Declares `ConcurrentRakPeer`, the thread-safety wrapper around `RakNet::RakPeerInterface` owned by every `Peer`: DataModel-write contexts may use `rawPeer()` directly; everyone else funnels sends through a queued job. Also declares `ConnectionStats` — the per-connection snapshot (MTU, pings, max packetloss, buffer health running average, bandwidth/congestion flags, KB/s in/out, full `RakNetStatistics`) pushed to Replicator via callback.

## API

```cpp
struct ConnectionStats {
    int mtuSize, averagePing, lastPing, lowestPing;
    float maxPacketloss;
    RunningAverage<> bufferHealth;   // 0 bad (buffer growing) .. 1 good
    RunningAverage<double> averageBandwidthExceeded/CongestionControlExceeded/kiloBytesSent/ReceivedPerSecond;
    RakNet::RakNetStatistics rakStats;
    void updateBufferHealth(int bufferSize);   // 0 / 0.5 / 1 sampling
};

class ConcurrentRakPeer : boost::noncopyable {
    ConcurrentRakPeer(RakNet::RakPeerInterface*, RBX::DataModel*);
    void addStats(SystemAddress, boost::function<void(const ConnectionStats&)>);
    void removeStats(SystemAddress);
    RakNet::RakPeerInterface* rawPeer();          // asserts write_requested
    void Send(shared_ptr<const BitStream>, PacketPriority, PacketReliability, char channel, SystemAddress, bool broadcast);
    void DeallocatePacket(Packet*);               // thread-safe
    double GetBufferHealth();
    double GetBandwidthExceeded/SystemAddress(); GetCongestionControlExceeded(...);
    const RakNetStatistics* GetStatistics(SystemAddress) const;
};
```

## Usage

Created per Peer attach (`Peer::onServiceProvider`); `Replicator` registers stats callbacks keyed by `remotePlayerId`.

## Gotchas

- Header comment is the contract: "Any Job running in DataModelJob::Write can access the peer interface directly using rawPeer(). All other threads should use the functions provided."
