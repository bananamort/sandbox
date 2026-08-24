# Network/ReplicatorStats.h

**Module**: Network (root) · **Type**: header (.h, 153 lines)

## Purpose

Declares `ReplicatorStats`, the per-Replicator metrics bundle consumed by stats UI and analytics: running averages for data/cluster/physics/touch packets (rate+size) both directions, per-`PacketType` count/size tables (InstanceNew/Delete/Ping/Data/Behavior/State/Appearance/Team/Video/Control/Event categories), physics sender/receiver detailed breakdowns (mechanism/CFrame/translation/rotation/velocity/characterAnim), data-ping RTT, queue time-in-queue, split-message counters, security heartbeat timestamps (`lastReceivedPingTime/HashTime/MccTime`), and the asynchronously-updated `ConnectionStats peerStats`.

## API

```cpp
enum PacketType { PACKET_TYPE_InstanceNew=0, ..., PACKET_TYPE_Event, PACKET_TYPE_MAX };
static const char* kPacketTypeNames[PACKET_TYPE_MAX];   // category strings for Data..Control

struct PhysicsPacketDetailedStats { mechanismCFrame/mechanism/characterAnim/translation/rotation/velocity
                                    + sizes; void CreateStatsItems(Stats::Item*) const; };
struct PhysicsSenderStats { physicsPacketsSent(+Smooth), throttle, size, itemsPerPacket, touch*, waitingTouches, details };
struct PhysicsReceiverStats { details };

void incrementPacketsSent/SamplePacketsSent(PacketType | categoryName string);
void incrementPacketsReceived/samplePacketsReceived(...);
void resetSecurityTimes();   // re-arm all three heartbeats to now
```

## Usage

Sampled from Replicator send/receive paths and physics senders/receivers; rendered by `Replicator::Stats`/Server/Client StatsItems.

## Gotchas

- Explicit warning in header: `peerStats` is updated from another thread; individual fields consistent, cross-field pairs may not be.
- String-based category lookups are linear scans over 11 entries per sampled packet.
