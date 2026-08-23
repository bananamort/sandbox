# Network/GuidRegistryService.h

**Module**: Network (root) · **Type**: header (.h, 20 lines)

## Purpose

Declares `RBX::Network::GuidRegistryService`, a non-creatable `Instance`+`Service` that owns a `GuidItem<Instance>::Registry` — the server-side registry mapping replicated instances to their GUIDs used by the descriptor/instance replication dictionary system.

## API

```cpp
extern const char* const sGuidRegistryService;
class GuidRegistryService
    : public DescribedNonCreatable<GuidRegistryService, Instance, sGuidRegistryService>
    , public Service
{
public:
    boost::intrusive_ptr<GuidItem<Instance>::Registry> const registry;
    GuidRegistryService(void);
    ~GuidRegistryService(void);
};
```

## Usage

Attached to a server DataModel so instance GUIDs can be registered/looked up during replication (`ID_TEACH_DESCRIPTOR_DICTIONARIES`, `ID_DICTIONARY_FORMAT` flows). The public `registry` member is consumed by Replicator/ServerReplicator code paths.

## Gotchas

- `registry` is `const` after construction — the service never swaps registries.
- Non-creatable via reflection: only engine code constructs it.
