# Network/TopNErrorsPhysicsSender.h

**Module**: Network (root) · **Type**: header (.h, 107 lines)

## Purpose

Declares `TopNErrorsPhysicsSender`, the default production physics sender (`NetworkSettings.PhysicsSend=TopNErrors`): per-nugget error accumulation with periodic partial sort (`nth_element`) so only the top-N error parts are sent, plus movement-history delta encoding ("cross-packet compression") that transmits motion nodes since the last send instead of full CFrames.

## API

```cpp
class TopNErrorsPhysicsSender : public PhysicsSender {
    class Nugget { part; float error; lastSent; sendDetailed; notInService; biggestSize; radius;
                   Time lastSendTime; float accumulatedError;
                   onSent(t, cf, err); computeError(focus, focusModel, stepId, sender);
                   static compError(a,b); static minDistance(9)/maxDistance(1e6)/minSize(2)/maxSize(50)(); };
    void step() override;
    int sendPacket(int maxPackets, PacketPriority, PhysicsSenderStats*) override;
protected:
    void writePV(...) override;                 // baseline CFrame/velocity writer
    void writeAssembly(...) override;           // 2-bit cache index (detailed|crossPacket)
    bool writeMovementHistory(BitStream&, const MovementHistory&, assembly, lastSendTime,
                              lastSendCFrame&, hasMovement&, compressionType, accumulatedError&, playerHead) override;
};
```

Flags: `DFInt::PhysicsSenderBufferHealthThreasholdPercent(40)`, `PhysicsSenderRotationThresholdThousandth(20)`, `DFFlag::PhysicsSenderSleepingUpdate`, `PhysicsSenderUseOwnerTimestamp`, `PhysicsSenderCheckPartInServiceBeforeSend`, `DebugPhysicsSenderLogCacheMissToGA`, shared `SFFlag::PhysicsPacketSendWorldStepTimestamp`.

## Usage

Created by `Replicator::createPhysicsSender(settings().getPhysicsSendMethod())` after top containers are sent (and directly under `RemoveUnusedPhysicsSenders`).

## Gotchas

- Detailed mode when squared distance < 400 (i.e. 20 studs), or when the object is huge (`biggestSize > DFInt::PhysicsCompressionSizeFilter`) to avoid compression jitter.
