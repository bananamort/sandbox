# Network/GuidRegistryService.cpp

**Module**: Network (root) · **Type**: implementation (.cpp, 12 lines)

## Purpose

Implements `GuidRegistryService` (see GuidRegistryService.h): sets the reflection class name string and constructs the owned `GuidItem<Instance>::Registry` via `Registry::create()`.

## API

```cpp
const char* const RBX::Network::sGuidRegistryService = "GuidRegistryService";
RBX::Network::GuidRegistryService::GuidRegistryService(void);  // registry(Registry::create())
RBX::Network::GuidRegistryService::~GuidRegistryService(void);
```

## Usage

Created on demand via `ServiceProvider::create<GuidRegistryService>` in `Players::getGuidRegistry()` (both client and server paths — e.g. chat sender/receiver identifiers) and consumed by Replicator replication dictionaries; destructor relies on `intrusive_ptr` refcount to release the registry.

## Gotchas

- No logic beyond construction/destruction — all behavior lives in `GuidItem<Instance>::Registry` (declared outside this module).
