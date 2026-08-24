# Network/ErrorCompPhysicsSender.h

**Module**: Network (root) · **Type**: header (.h, 120 lines)

## Purpose

Declares `ErrorCompPhysicsSender`, the legacy error-compensating physics sender (whole file guarded by `#if 1 // removing deprecated senders…` — slated for deletion once `FFlag::RemoveUnusedPhysicsSenders` lands). It maintains per-assembly-root "Nuggets" in a boost intrusive multiset ordered by accumulated send error, recomputes error lazily per step, and sends the highest-error mechanisms first.

## API

```cpp
class ErrorCompPhysicsSender : public PhysicsSender {
    class Nugget : NuggetHook {
        shared_ptr<const PartInstance> part;
        double error; int errorStepId;      // -1 uninit; 0 = just sent
        CoordinateFrame lastSent; bool sendDetailed;
        float biggestSize, radius;
        void computeError(focus, focusModel, timestamp);
        static void onSent(Nugget&);
        static float minDistance(3)/maxDistance(1000)/minSize(2)/maxSize(50)();
    };
    void step() override;                   // lazy error updates (≤100 old visits/step)
    int sendPacket(int maxPackets, PacketPriority, PhysicsSenderStats*) override;
protected:
    void writeAssembly(BitStream&, const Assembly*, Compressor::CompressionType, bool crossPacketCompression=false) override;
};
```

## Usage

Selectable via `NetworkSettings.PhysicsSend=ErrorComputation`.

## Gotchas

- Removal detection is passive: nuggets whose part left PhysicsService's intrusive list are dropped during step/send scans (`removedAssemblyConnection` is commented out).
- Character parts get `error = DBL_MAX` and detailed mode.
