# Network/NetworkSettings.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 369 lines)

## Purpose

Implements `NetworkSettings`: registers enum descriptors (`PhysicsSendMethod`, `PhysicsReceiveMethod`, RakNet `PacketReliability`, `PacketPriority`) and the full reflection property set grouped under "Network"/"Data"/"Physics"/"Diagnostics"/"Profiler"/"Optimization"/"Appearance" categories, applies clamps in every setter (rate/MTU bounds), forwards appearance debug toggles to Workspace statics, and exposes memory stats.

## API

Key reflection names: `PreferredClientPort`, `DataSendRate`, `DataGCRate`, `PhysicsSendRate`, `ClientPhysicsSendRate`, `NetworkOwnerRate`, `TouchSendRate`, `IsThrottledByOutgoingBandwidthLimit/CongestionControl`, `ReceiveRate`, `UsePhysicsPacketCache`, `UseInstancePacketCache`, `IsQueueErrorComputed`, `TrackDataTypes`, `Print*` diagnostics, `IncommingReplicationLag`, `PhysicsSend`, `PhysicsReceive` (dummy pair), `PhysicsSendPriority`, `ExperimentalPhysicsEnabled`, `PhysicsMtuAdjust`, `DataMtuAdjust`, `CanSendPacketBufferLimit` (+deprecated `MaxDataModelSendBuffer`), `SendPacketBufferLimit`, `DataSendPriority`, `EnableHeavyCompression`, `ExtraMemoryUsed`, `FreeMemoryMBytes`, `FreeMemoryPoolMBytes`, `RenderStreamedRegions`, `ShowPartMovementWayPoint`, `TotalNumMovementWayPoint`, `ShowActiveAnimationAsset`; profiler props only under `NETWORK_PROFILER` (Windows debug/test builds).

## Usage

- Constructor defaults: dataSendRate 30, physics 20/20, GC 20, networkOwner 10, touch 10, receive 60, MTU adjust −200 both, canSendBufferLimit 1, sendBufferLimit −1, TopNErrors sender + Interpolation receiver, distributed physics **true**, profiler server 127.0.0.1:38123.
- `printProfilingResult()` → `CPUPROFILER_OUTPUT()`.

## Gotchas

- `ReportStatURL` is a deprecated no-op property kept for script compatibility.
- Setter clamps silently truncate values (e.g. DataSendRate beyond 120 becomes 120).
