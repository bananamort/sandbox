# util/HeartbeatInstance.h

## Purpose
Mixin that wires a class into the ServiceProvider's heartbeat signal: subclass overrides `onHeartbeat` and calls `onServiceProviderHeartbeatInstance` from its own `onServiceProvider` override (usage pattern documented in the header comment).

## Declared API
```cpp
class HeartbeatInstance {
public:
    HeartbeatInstance();
    virtual ~HeartbeatInstance();
protected:
    // call this inside onServiceProvider:
    void onServiceProviderHeartbeatInstance(ServiceProvider* oldProvider, ServiceProvider* newProvider);
    /*implement*/ virtual void onHeartbeat(const Heartbeat& event) = 0;
private:
    rbx::signals::scoped_connection heartbeatConnection;  // auto-disconnects on destruction
};
```

## Gotchas
- Pure-virtual `onHeartbeat` — subclasses must implement it.
- Wiring is manual: forgetting to call `onServiceProviderHeartbeatInstance` in `onServiceProvider` means no heartbeats ever arrive (no error).
- `scoped_connection` guarantees unsubscription when the instance dies — but only if the connection was made; re-parenting providers rebinds it.
- The header comment shows the exact override pattern; follow it or the mixin does nothing.

## UNKNOWN
- Which ServiceProvider signal exactly (Heartbeat vs Stepped) — named `Heartbeat` here; see also SteppedInstance.h for the stepped variant.
