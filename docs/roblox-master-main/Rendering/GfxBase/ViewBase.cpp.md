# ViewBase.cpp

Source: `roblox-sandbox/Rendering/GfxBase/ViewBase.cpp` (81 lines)

## Purpose

Implements the static factory registry and frame-driving skeleton of `RBX::ViewBase`, the abstract render-view (swap-chain owner). Backends (RenderView/D3D/GL) register an `IViewBaseFactory` per `CRenderSettings::GraphicsMode`; clients call `CreateView` to get the mode-appropriate concrete view.

## API

- `static IViewBaseFactory** getFactory(CRenderSettings::GraphicsMode)` — file-static 6-slot table indexed by GraphicsMode enum value; returns NULL for out-of-range modes.
- `ViewBase* ViewBase::CreateView(CRenderSettings::GraphicsMode mode, OSContext* context, CRenderSettings* renderSettings)` — looks up factory; `RBXASSERT(ppfactory && *ppfactory)` with comment *"did you call RBX::ViewBase::InitPluginModules?"*; returns NULL if unregistered.
- `void ViewBase::RegisterFactory(CRenderSettings::GraphicsMode mode, IViewBaseFactory* factory)` — stores into slot.
- `void ViewBase::render(IMetric* metric, double timeRenderJob)` — if `timeRenderJob == 0.0`, substitutes `Time::nowFastSec()`; then `renderPrepare(metric); renderPerform(timeRenderJob);`.
- `void ViewBase::InitPluginModules()` — calls extern `RenderView_InitModule()`.
- `void ViewBase::ShutdownPluginModules()` — calls extern `RenderView_ShutdownModule()`.
- `std::pair<unsigned,unsigned> ViewBase::setFrameDataCallback(const boost::function<void(void*)>&)` — **stub: always returns `(0, 0)`**.

## Usage

Includes `rbx/rbxTime.h`, `rbx/Debug.h`, `util/MachineIdUploader.h`, `boost/functional/hash.hpp`. The externs `RenderView_InitModule/ShutdownModule` are defined in the RenderView plugin TU.

## Gotchas

- Calling `CreateView` before `InitPluginModules()` trips the assert (and returns NULL in release).
- Exactly ONE factory per GraphicsMode — later RegisterFactory silently overwrites.
- 6-slot table bounds the valid GraphicsMode values; adding a 7th mode needs this table grown.
- setFrameDataCallback is a no-op stub — callback is never invoked.
