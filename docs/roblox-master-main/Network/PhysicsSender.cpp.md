# Network/PhysicsSender.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 621 lines)

## Purpose

Implements the `PhysicsSender` base and its two scheduler jobs: `Job` ("Replicator SendPhysics", PhysicsOut, at `DFInt::PhysicsSenderRate`(15) Hz — RoundRobin senders use ClientPhysicsSendRate; under `DFFlag::CleanUpInterpolationTimestamps` it always wakes and self-throttles by skip-steps) which calls the subclass's `step()`+`sendPacket` honoring `sendPacketBufferLimit`, and `TouchJob` ("Replicator SendTouches", touchSendRate Hz) that drains PhysicsService touch pairs into `ID_PHYSICS_TOUCHES` packets (RELIABLE_ORDERED on PHYSICS_CHANNEL). Also implements shared wire helpers: compression-type choice (complex mechanisms in distributed physics ⇒ UNCOMPRESSED), mechanism/child-assembly serialization with done-tokens, streaming CFrame-only mode for parts outside streamed regions, PV/motor-angle writers (`writeCompactCFrame` 1-bit fast path for simple z-axis hinges), and velocity vectors only under distributed physics.

## API

```cpp
FASTINT NumPhysicsTouchPacketsPerStep(1); DFInt NumPhysicsPacketsPerStep(1); DFInt PhysicsSenderRate(15);
class PhysicsSender::Job / TouchJob;
size_t pendingTouchCount(); void sendTouches(PacketPriority);
template<class T> void writeTouches(BitStream&, maxBitStreamSize, T& touchPairList); // skips own-origin pairs
static void start(shared_ptr<PhysicsSender>);   // registers both jobs
Compressor::CompressionType getCompressionType(assembly, detailed);
void sendMechanism/sendMechanismCFrames/sendChildPrimitiveCoordinateFrame/sendChildAssembly(...);
bool writeMovementHistory(...) { return false; }   // base: no path movement (TopNErrors overrides)
void writeAssembly/writePV/writeCoordinateFrame/writeVelocity/writeMotorAngles/writeCompactCFrame;
bool canSend(part, assembly, stream); bool sendPhysicsData(bitStream, part, detailed, ...);
```

Mechanism wire format (comment block): attributes → primary assembly → repeated [child part id + child assembly] → done token.

## Usage

Subclasses (ErrorComp×2, RoundRobin, TopNErrors) only implement selection policy; all packet framing lives here.

## Gotchas

- Velocity is written **only** when distributed physics is enabled — receivers must tolerate absent velocity otherwise.
- Touch packets skip pairs whose originator is this connection's own address (no echo).
- `writeCompactCFrame` loses a sign bit on angles ("todo: losing one bit here").
