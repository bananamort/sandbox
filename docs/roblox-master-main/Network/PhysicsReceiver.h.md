# Network/PhysicsReceiver.h

**Module**: Network (root) · **Type**: header (.h, 138 lines)

## Purpose

Declares `PhysicsReceiver`, the abstract base for all incoming-physics decoders (concrete: `DirectPhysicsReceiver`, `InterpolatingPhysicsReceiver`). Owns the wire-format readers for mechanisms, assemblies, PVs, motor angles, compact CFrames and touch pairs, plus debug adorn bookkeeping for path-based movement visualization. Also declares `DeserializedTouchItem`, a deferred touch-processing item.

## API

```cpp
class DeserializedTouchItem : public DeserializedItem {
    std::vector<TouchPair> touchPairs;
    /*implement*/ void process(Replicator& replicator);
};

class PhysicsReceiver : boost::noncopyable {
public:
    PhysicsReceiver(Replicator* replicator, bool isServer);
    virtual void start(shared_ptr<PhysicsReceiver>) {}
    void setTime(Time now_);
    void receiveMechanism(RakNet::BitStream&, PartInstance* rootPart,
                          MechanismItem&, RemoteTime remoteSendTime, int& numNodesInHistory);
    void receiveMechanismCFrames(RakNet::BitStream&, RakNet::Time timeStamp,
                                 const RBX::RemoteTime& remoteSendTime);
    void setPhysics(const MechanismItem& item, const RemoteTime& remoteSendTime = RemoteTime(),
                    const RakNet::TimeMS = 0, int numNodesInHistory = 0);
    virtual void receivePacket(RakNet::BitStream& bitstream, RakNet::Time timeStamp,
                               ReplicatorStats::PhysicsReceiverStats* stats) = 0;
    void deserializeTouches(RakNet::BitStream&, const RakNet::SystemAddress&, std::vector<TouchPair>&);
    bool deserializeTouch(RakNet::BitStream&, const RakNet::SystemAddress&, TouchPair&);
    void processTouchPair(const TouchPair&);
    void readTouches(RakNet::BitStream&, const RakNet::SystemAddress&);
    void renderPartMovementPath(Adorn* adorn);
protected:
    const bool iAmServer;
    Replicator* const replicator;
    ReplicatorStats::PhysicsReceiverStats* stats;
    Time now;
    // private readers: readMovementHistory, readMechanismAttributes, readAssembly, readPV,
    //   readCoordinateFrame, readVelocity, readMotorAngles, readCompactCFrame,
    //   okDistributedReceivePart, receiveRootPart, receivePart
};
namespace PathBasedMovementDebug { struct NodeDebugInfo { Color3 color; float size; bool show; }; }
```

## Usage

Held by `Replicator` (`replicator->physicsReceiver`); `ID_PHYSICS` packets dispatch to `receivePacket`; `ID_PHYSICS_TOUCHES` to `readTouches`/`deserializeTouches`.

## Gotchas

- Wire format is documented in a comment in the .cpp: mechanism = MechanismAttributes + PrimaryAssembly + repeated ChildAssembly until a `done` flag.
- Debug adorn state (`movementWaypointList`) capacity is driven by NetworkSettings at runtime (`rset_capacity`).
