# Rendering/GfxCore/include/GfxCore/Resource.h

## Purpose

Base class of every GfxCore GPU object (`Texture`, `Framebuffer`, `Renderbuffer`, `Geometry`, buffers, shaders). Provides the device back-pointer and wires each resource into the owning `Device`'s intrusive doubly-linked list so the device can broadcast device-lost/restored notifications to all live resources.

## API

- `class Resource : boost::noncopyable` (in `RBX::Graphics`)
  - `explicit Resource(Device* device)` — links itself into the device's list.
  - `virtual ~Resource()` — unlinks.
  - `virtual void onDeviceLost()` — empty default; backend resources override to release native handles (D3D9 pool-default objects).
  - `virtual void onDeviceRestored()` — empty default; override to recreate native handles.
  - `const std::string& getDebugName() const` / `void setDebugName(const std::string& value)`.
- Members: `Device* device`, intrusive `Resource* prev; Resource* next;`, `std::string debugName`. `friend class Device`.

## Usage

Every abstraction in this directory inherits from it; `Device::fireDeviceLost()` walks the list **tail→head** and `fireDeviceRestored()` walks **head→tail**, calling the virtuals. Backends keep their native object pointers as members and null them in `onDeviceLost`.

## Gotchas

- The list is intrusive and noncopyable by inheritance — never copy a Resource subclass by value.
- Device-lost handling is only meaningful for D3D9-style lossy devices; D3D11/GL overrides are typically empty, but the virtuals are still invoked for all backends.
