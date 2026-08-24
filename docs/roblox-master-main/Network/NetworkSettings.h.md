# Network/NetworkSettings.h

**Module**: Network (root) · **Type**: header (.h, 158 lines)

## Purpose

Declares `RBX::NetworkSettings` (`sNetworkSettings = "NetworkSettings"`), the GlobalAdvancedSettings singleton holding every tunable of the networking stack: verbose-print/track diagnostics flags, physics send/receive method enums, packet priorities, MTU adjustments, data/physics/touch/receive/GC rates (rate floats stored as `ObscureValue` to hinder memory scanning), packet buffer limits, distributed-physics switch, preferred client port, packet caches toggles, heavy-compression enable, and streaming/memory debug knobs.

## API

```cpp
typedef enum { ErrorComputation, ErrorComputation2, RoundRobin, TopNErrors } PhysicsSendMethod;
typedef enum { Direct, Interpolation } PhysicsReceiveMethod;

static Reflection::BoundProp<bool> prop_DistributedPhysics;   // "ExperimentalPhysicsEnabled"
bool distributedPhysicsEnabled;
int preferredClientPort;
int canSendPacketBufferLimit;   // default 1
int sendPacketBufferLimit;      // default -1 = unchecked
float touchSendRate;  float networkOwnerRate;
bool isThrottledByOutgoingBandwidthLimit / isThrottledByCongestionControl;
double incommingReplicationLag;

PhysicsSendMethod get/setPhysicsSendMethod();     // default TopNErrors
PacketPriority get/setPhysicsSendPriority();      // HIGH
PacketPriority get/setDataSendPriority();         // MEDIUM
int get/setPhysicsMtuAdjust();  int get/setReplicationMtuAdjust();   // clamped [-1000,0], default -200
float getDataSendRate/setDataSendRate();          // clamp [5,120], default 30
float getDataGCRate/setDataGCRate();              // [2,60], 20
float getPhysicsSendRate/...ClientPhysicsSendRate/...TouchSendRate(...);
double getReceiveRate/setReceiveRate();           // [5,120], 60
bool enableHeavyCompression(); bool heavyCompressionEnabled();
void setExtraMemoryUsedInMB(int); int getExtraMemoryUsedInMB();
float getFreeMemoryMBytes/getFreeMemoryPoolMBytes();
get/setRenderStreamedRegions / ShowPartMovementPath / ShowActiveAnimationAsset (Workspace statics)
```

## Usage

- Constructed eagerly by `NetworkSettings::singleton()` from API.cpp init paths; read everywhere via `settings()` on Replicator or `NetworkSettings::singleton()`.
- `ID_SET_GLOBALS` writes `prop_DistributedPhysics` on the client copy to mirror server config.

## Gotchas

- Defaults matter for protocol compatibility: server comment notes unit tests assume TopNErrors and receivers expect RoundRobin-or-TopNErrors packets.
- Rates are `ObscureValue<float>` — direct memory reads see scrambled values.
