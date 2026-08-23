# Network/PhysicsSender.h

**Module**: Network (root) · **Type**: header (.h, 102 lines)

## Purpose

Declares `PhysicsSender`, the abstract base for outgoing-physics encoders (`RoundRobinPhysicsSender`, `ErrorCompPhysicsSender`, `ErrorCompPhysicsSender2`, `TopNErrorsPhysicsSender`). Owns the wire writers for mechanisms/assemblies/PVs/motor-angles/compact CFrames, the "Replicator SendPhysics" and "Replicator SendTouches" scheduler jobs, and the touch-pair send queue.

## API

```cpp
class PhysicsSender : boost::noncopyable {
public:
    PhysicsSender(Replicator& replicator);
    static void start(shared_ptr<PhysicsSender>);      // registers Job + TouchJob with TaskScheduler
    virtual ~PhysicsSender();
    virtual void step() = 0;                            // pick parts to send (subclass policy)
    virtual int sendPacket(int maxPackets, PacketPriority,
                           ReplicatorStats::PhysicsSenderStats*) = 0;
    void sendTouches(PacketPriority);
    template<typename T> void writeTouches(RakNet::BitStream&, unsigned maxBitStreamSize, T& list);
    size_t pendingTouchCount();
protected:
    Replicator& replicator;
    ReplicatorStats::PhysicsSenderStats* senderStats;
    RunningAverage<int> itemsPerPacket;
    int sendPacketsPerStep;
    bool canSend(const PartInstance*, const Assembly*, RakNet::BitStream&);
    bool sendPhysicsData(RakNet::BitStream&, const PartInstance*, bool detailed, ...);
    void sendMechanism / sendMechanismCFrames / writeVelocity / writeMotorAngles(...);
    virtual void writePV(...); virtual void writeAssembly(...); virtual bool writeMovementHistory(...);
};
```

## Usage

Each replicator owns one sender; the Job steps at `DFInt::PhysicsSenderRate` (default 15 Hz), honoring `sendPacketBufferLimit` throttling and `getBufferCountAvailable`.

## Gotchas

- `writeMovementHistory` base implementation always returns false ("client will not use path based part movement") — path-based movement sending is effectively disabled at this layer.
