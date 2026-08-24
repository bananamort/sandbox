# Network/ErrorCompPhysicsSender2.h

**Module**: Network (root) · **Type**: header (.h, 130 lines)

## Purpose

Declares `ErrorCompPhysicsSender2`, the second-generation error-compensating physics sender (also inside the `#if 1` deprecation guard). Instead of a sorted set, it buckets nuggets into `NUM_GROUPS=4` priority groups (character=0 … farthest=3) and round-robins between buckets with 2:1 send-ratio scheduling — cheaper than global sorting.

## API

```cpp
class ErrorCompPhysicsSender2 : public PhysicsSender {
    class Nugget { part; errorStepId; sendStepId; groupId; mapIter; sendDetailed; biggestSize;
                   computeDeltaError(focus, focusModel, timestamp); onSent(stepId);
                   static minDistance(3)/maxDistance(800)/minSize(2)/maxSize(25)/midArea(312.5)(); };
    struct Bucket { NuggetIterator iter; NuggetList list; int targetSentCount, sendCount;
                    push_back/erase/splice(...); size(); };
    void step() override;
    int sendPacket(int maxPackets, PacketPriority, PhysicsSenderStats*) override;
protected:
    void writeAssembly(...) override;   // PhysicsPacketCache wrapper
private:
    NuggetMap/UpdateList/SendGroups; void calculateSendCount();
    bool writeNugget(BitStream&, Nugget&);
};
```

## Usage

Selectable via `NetworkSettings.PhysicsSend=ErrorComputation2`.

## Gotchas

- Group assignment: base = distance scaled to group count, then **reduced** by velocity error (`-1 + lVel·0.8/5000 + rVel·0.25/5000`) and size error (`-1 + biggestSize²/midArea`) — faster/bigger objects move toward lower (higher-priority) groups.
