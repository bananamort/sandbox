# util/SteppedInstance.h

## Purpose
Mixin that wires a class into the DataModel's stepped signal (sibling of HeartbeatInstance.md): subclass implements `onStepped` and calls `onServiceProviderIStepped` from its `onServiceProvider` override. Supports Default, HighPriority, and Render step flavors.

## Declared API
```cpp
LOGGROUP(ISteppedLifetime)

class IStepped {
public:
    enum StepType {
        StepType_Default,
        StepType_HighPriority,
        StepType_Render,
    };

    IStepped(StepType stepType = StepType_Default);
    virtual ~IStepped();
protected:
    // call this inside onServiceProvider:
    void onServiceProviderIStepped(ServiceProvider* oldProvider, ServiceProvider* newProvider);
    /*implement*/ virtual void onStepped(const Stepped& event) = 0;
    void stopStepping();                       // explicit disconnect
private:
    StepType stepType;
    rbx::signals::scoped_connection steppedConnection;   // auto-disconnect on destruction
};
```

## Gotchas
- Pure-virtual `onStepped(const Stepped&)`; the `Stepped` payload comes from RunStateOwner.md.
- Forgetting the `onServiceProviderIStepped` call means never receiving steps (silent).
- The chosen `StepType` selects which RunService signal (stepped vs high-priority vs render) gets connected.
- LOGGROUP(ISteppedLifetime) implies lifetime logging in debug builds.

## UNKNOWN
- Exact signal-to-StepType mapping (.cpp-side).
