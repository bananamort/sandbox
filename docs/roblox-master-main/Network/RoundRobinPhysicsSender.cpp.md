# Network/RoundRobinPhysicsSender.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 319 lines)

## Purpose

Implements the round-robin sender: inner `JobSender` opens `[ID_TIMESTAMP][now][ID_PHYSICS]` (optionally + step-compensated timestamp) packets sized to `getPhysicsMtuSize()`, reports SimJobs via `Workspace::getWorld()->getSendPhysics()->reportSimJobs(jobSender, jobStagePos, characterSimJob, remaining)`, writes per-assembly state through `sendPhysicsData` (`canSend` filter → `trySerializeId` → `sendMechanism`, with "not done"/"done" tokens when streaming), closes with an end tag and sends UNRELIABLE on PHYSICS_CHANNEL. Client-side `step()` adapts `sendPacketsPerStep` from buffer health every 3 s.

## API

```cpp
SYNCHRONIZED_FASTFLAG(PhysicsPacketSendWorldStepTimestamp)
void sendPhysicsData(BitStream&, const Assembly*);   // detailed stats for target player's parts
class JobSender { openPacket/openPacketPhysicsOffset/closePacket/report(SimJob&); packetCount/itemCount };
void step(); int sendPacket(int maxPackets, PacketPriority, PhysicsSenderStats*);
```

## Usage

See header. Character priority: sent first if >100 ms since last forced send.

## Gotchas

- `characterSimJob = NULL; // don't ignore me below` — a NULL assignment means "already handled, don't skip in rotation" (confusing double negative).
- Packets with no items are never sent (closePacket checks bits used beyond header).
