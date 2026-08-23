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

Constructed by server bootstrapping code when a DataModel is configured for network play; destructor relies on `intrusive_ptr` refcount to release the registry.

## Gotchas

- No logic beyond construction/destruction — all behavior lives in `GuidItem<Instance>::Registry` (declared outside this module).
