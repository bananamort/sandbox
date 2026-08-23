# Rendering/GfxCore/Device.cpp

## Purpose

Shared Device-layer implementation: `DeviceContext` ctor/dtor and the non-virtual `draw` entry points; `DeviceCaps::dumpToFLog`; `DeviceVR` dtor; `Device` ctor/dtor with leak reporting; single-buffer convenience overloads of `createGeometry`/`createFramebuffer`; and the device lost/restored broadcast.

## API

- FastFlags declared here: `FFlag::DebugGraphicsCrashOnLeaks` (default **true**), `FFlag::GraphicsDebugMarkersEnable` (default false); log variables Graphics, VR.
- `DeviceContext::draw(Geometry*, Primitive, offset, count, indexRangeBegin, indexRangeEnd)` / `draw(const GeometryBatch&)` — both unwrap into pure-virtual `drawImpl`.
- `void DeviceCaps::dumpToFLog(int channel)` — FASTLOG dump of caps (shaders/FFP, framebuffer MRT MSAA stencil 32bIdx, DXT/PVR/ETC1/Half, 3D/NPOT/partial mips, size/units, BGR/half-pixel/RT-flip, retina).
- `Device::Device()` — zeroes list head/tail. `Device::~Device()` — if resources remain: logs "ERROR: Not all resources are destroyed!" plus per-resource type (`typeid(*cur).name()`) and debug name; then `RBXCRASH()` when `DebugGraphicsCrashOnLeaks` else `RBXASSERT(false)`.
- `createGeometry(layout, singleVB, ib, baseVertexIndex)` — wraps VB in a vector, forwards to `createGeometryImpl`; vector overload passes through.
- `createFramebuffer(single color[, depth])` — wraps in vector, forwards to `createFramebufferImpl`.
- `void fireDeviceLost()` — walks tail→head calling `onDeviceLost()`; `fireDeviceRestored()` walks head→tail.

## Usage

This is the only place the shared half of Device lives; backends implement the `*Impl` virtuals and lifecycle methods. The leak check makes device teardown order-critical for callers.

## Gotchas

- With default flags a leaked GPU resource at Device destruction *crashes the process* (by design, Debug flag defaults true) — teardown code must release all GfxCore objects first.
- Lost/restored iteration directions differ deliberately (reverse vs forward), preserving creation-order symmetry around a loss event.
