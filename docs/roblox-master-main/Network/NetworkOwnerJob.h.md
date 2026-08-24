# Network/NetworkOwnerJob.h

**Module**: Network (root) · **Type**: header (.h, 72 lines)

## Purpose

Declares `NetworkOwnerJob`, the server-side distributed-physics ownership arbiter ("Distributed Physics Ownership" Write job at `NetworkSettings::networkOwnerRate` Hz, default 10): each step it refreshes per-client weighted simulation regions from their `ServerReplicator`s, then walks all moving assemblies in the SpatialFilter and assigns/switches network owners between Server and the closest capable client.

## API

```cpp
class NetworkOwnerJob : public DataModelJob {
    NetworkOwnerJob(shared_ptr<DataModel>);
    void invalidateProjectileOwnership(RBX::SystemAddress addr);  // marks client overloaded → projectiles stop sticking
private:
    struct ClientLocation { Region2::WeightedPoint clientPoint; ServerReplicator* clientProxy;
                            const Mechanism* characterMechanism; bool overloaded; };
    ClientMap clientMap;   // SystemAddress → location
    void updatePlayerLocations(Server*);        // resets numPartsOwned per replicator
    void updateNetworkOwner(PartInstance* rootPart);
    ClientMapConstIt findClosestClientToPart / findClosestClient(const Vector2&);
    bool clientCanSimulate(part, it);           // character mechanism always; else within region+SERVER_SLOP
    bool switchOwners(part, current, candidate);// no switch off a character mechanism
    static void resetNetworkOwner(part, value); // setNetworkOwnerAndNotify + 0.1 s re-switch delay
};
```

## Usage

Created by `Server::onServiceProvider` when distributed physics is enabled; also consumed by `Players::findLocalSimulatorAddress`.

## Gotchas

- Character mechanisms always stay with their player; non-character parts follow closest-region with hysteresis (`networkOwnerTimeUp`, 0.1 s) and projectile stickiness unless the owner is flagged overloaded (sim radius shrank).
- Manual ownership of a departed/unresolvable address falls back to Server + auto.
