# Network/RoundRobinPhysicsSender.h

**Module**: Network (root) · **Type**: header (.h, 36 lines)

## Purpose

Declares `RoundRobinPhysicsSender`, the physics sender that walks all moving SimJobs in round-robin order each step (via `SendPhysics::reportSimJobs` with a persisted `SimJobTracker` cursor), giving the target player's character a periodic priority slot. This is also the method forced for client→server distributed-physics sends (`ID_SET_GLOBALS` path).

## API

```cpp
class RoundRobinPhysicsSender : public PhysicsSender {
    RoundRobinPhysicsSender(Replicator&);
    int sendPacket(int maxPackets, PacketPriority, ReplicatorStats::PhysicsSenderStats*) override;
    void step() override;                       // buffer-health adaptive sendPacketsPerStep (client side)
    void sendPhysicsData(BitStream&, const Assembly*);
private:
    SimJobTracker jobStagePos;                  // round-robin cursor
    Time lastCharacterSendTime, lastBufferCheckTime;
    const SimJob* findTargetPlayerCharacterSimJob();
};
```

## Usage

Created by `Replicator::createPhysicsSender(RoundRobin)` and directly by ClientReplicator under distributed physics.

## Gotchas

- Character is force-sent at most every 0.1 s; between those windows it still gets its normal rotation turn.
- `SFFlag::PhysicsPacketSendWorldStepTimestamp` switches packet headers to include a world-step-compensated timestamp.
