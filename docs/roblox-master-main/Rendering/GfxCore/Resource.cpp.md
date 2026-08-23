# Rendering/GfxCore/Resource.cpp

## Purpose

Implements `Resource` — construction/destruction wiring into the owning Device's intrusive doubly-linked resource list, plus empty default device-lost/restored handlers and debug naming.

## API

- `Resource::Resource(Device* device)` — appends itself at `device->resourceListTail` (head if list empty), with `RBXASSERT` consistency checks on head/tail pairing.
- `Resource::~Resource()` — unlinks; asserts it was actually head/tail when prev/next were null.
- `void Resource::onDeviceLost()` / `onDeviceRestored()` — intentionally empty base implementations.
- `void Resource::setDebugName(const std::string& value)`.

## Usage

Every GfxCore GPU object chains through this ctor/dtor, so at any moment `Device` can enumerate all live resources (used for leak reporting and lost-device broadcasts — see Device.cpp).

## Gotchas

- The dtor asserts (`RBXASSERT(device->resourceListHead == this)`) when unlinking a head/tail that isn't this object — corruption here means double-destruction or cross-device mixing.
- Resources are appended at the tail and device-lost is fired tail→head (children before parents by allocation order is NOT guaranteed; it's reverse creation order).
