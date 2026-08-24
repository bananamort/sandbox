# Network/NetworkFilter.h

**Module**: Network (root) · **Type**: header (.h, 56 lines)

## Purpose

Declares the two client→server data filters used when `FilteringEnabled` is on: `StrictNetworkFilter` — a hard whitelist (scriptable properties/events must be whitelisted; new instances rejected except local Player/StarterGear/tool welds; terrain edits always rejected) — and `NetworkFilter`, the "basic" first-pass filter that accepts known-safe physics/Humanoid data and rejects protected service subtrees, leaving everything else to the pluggable Lua callbacks.

## API

```cpp
class StrictNetworkFilter {
    StrictNetworkFilter(Replicator*);
    FilterResult filterChangedProperty(Instance*, const PropertyDescriptor&);
    FilterResult filterParent(Instance*, Instance* newParent);
    FilterResult filterEvent(Instance*, const EventDescriptor&);
    FilterResult filterNew(const Instance*, const Instance* parent);
    FilterResult filterDelete(const Instance*);
    FilterResult filterTerrainCellChange();     // always Reject
    void onChildRemoved(Instance* removed, const Instance* oldParent); // arms one-shot reparent allowance
    static boost::unordered_set<std::string> propertyWhiteList, eventWhiteList;
};

class NetworkFilter {   // returns bool "handled" + result
    bool filterChangedProperty(...); filterParent(...); filterNew(...); filterDelete(...); filterEvent(...);
};
```

## Usage

- Strict: created in ClientReplicator/ServerReplicator when workspace filtering is enabled; consulted before basic/Lua filters.
- Basic: `ServerReplicator::setBasicFilteringEnabled(true)` default; fires `Server::dataBasicFilteredSignal`.

## Gotchas

Whitelists (static, built once): properties `{Jump, Sit, Throttle, Steer, SimulationRadius}`; events `{OnServerEvent, PromptProductPurchaseFinished, PromptPurchaseFinished, PromptPurchaseRequested, ClientPurchaseSuccess, ServerPurchaseVerification, Activated, Deactivated, SimulationRadiusChanged, LuaDialogCallbackSignal, ServerAdVerification, ClientAdVerificationResults}`.
