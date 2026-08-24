# Network/PropertySynchronization.h

**Module**: Network (root) · **Type**: header (.h, 310 lines, header-only)

## Purpose

Header-only implementation of the PropSync "ships passing in the night" resolver: a versioned, time-boxed property-change handshake between the replication `Master` (ServerReplicator) and `Slave` (ClientReplicator). The master versions each changed property for ~2 s; until the slave acknowledges that version, further slave changes to the same property are rejected — guaranteeing eventual consistency without permanent per-property state.

## API

```cpp
namespace PropSync {
    class Master {                       // expiration 2 s
        unsigned int propertyRejectionCount;
        void expireItems();                              // cull (called from dataOutStep)
        void onPropertyChanged(ConstProperty);           // bump version when one is in flight
        PropertySendResult onPropertySend(ConstProperty);// SendVersionReset on new/zero-version items
        void onReceivedAcknowledgement(ConstProperty, int version);
        FilterResult onReceivedPropertyChanged(ConstProperty); // Reject while slaveVersion != version
        void setExpiration(Time::Interval);
    };
    class Slave {                        // expiration 4 s
        unsigned int ackCount;
        void expireItems();
        void onReceivedPropertyChanged(ConstProperty, bool versionReset); // reset or ++ version, clear ack
        PropertySendResult onPropertySend(ConstProperty, int& version);   // one-shot ItemTypePropAcknowledgement
        void setExpiration(Time::Interval);
    };
}
// detail: PropertyKey (descriptor ptr + guid), Item{version,expiration},
//         MasterItem{isVersionSent,slaveVersion}, SlaveItem{isAckSent}, Base::expireItems()
```

## Usage

- Server: `ServerReplicator::writeChangedProperty(Ref)` writes the `versionReset` bit; `filterReceivedChangedProperty/filterPhysics` consult `onReceivedPropertyChanged`.
- Client: `readChangedProperty(Item)` feeds `onReceivedPropertyChanged`; outgoing changes prepend `ItemTypePropAcknowledgement` via `onPropertySend`; CFrame gets an immediate ack item.

## Gotchas

- Expirations are asymmetric (2 s master vs 4 s slave) to tolerate round-trip skew; tunable via `SetPropSyncExpiration` reflection.
- Slave may transiently change a value that later snaps back to the master's — by design ("The master will never experience this temporary state").
