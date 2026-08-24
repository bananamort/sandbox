# RenderStats.cpp

Source: `roblox-sandbox/Rendering/GfxBase/RenderStats.cpp` (34 lines)

## Purpose

Constructs and destroys `RBX::RenderStats`, the per-frame bundle of `RBX::Profiling::CodeProfiler` timers covering every major stage of the render pipeline. Each member is a named profiler that other subsystems scope-time into (e.g. `"3D CPU Total"` wraps the whole frame render).

## API

- `RBX::RenderStats::RenderStats()` — news up 15 CodeProfilers with these exact profiler names:
  - `cpuRenderTotal` → "3D CPU Total"
  - `culling` → "Culling"
  - `flip` → "Flipping Backbuffer"
  - `renderObjects` → "Render Objects"
  - `updateLighting` → "Update Lighting"
  - `adorn2d` → "Adorn 2D"
  - `adorn3D` → "Adorn 3D"
  - `visualEngineSceneUpdater` → "Visual Engine Scene Updater"
  - `finishRendering` → "Finish Rendering"
  - `renderTargetUpdate` → "RenderTarget Update"
  - `frameRateManager` → "Frame Rate Manager"
  - `textureCompositor` → "Texture Compositor"
  - `updateSceneGraph` → "Update SceneGraph"
  - `updateAllInvalidParts` → "updateAllInvalidParts"
  - `updateDynamicsAndAggregateStatics` → "updateDynamicsAndAggregateStatics"
  - `updateDynamicParts` → "updateDynamicParts"
- `RBX::RenderStats::~RenderStats()` — empty body.

## Usage

Depends on `Util/Profiling.h` (`RBX::Profiling::CodeProfiler`). The profiler name strings are what show up in MicroProfile/profiling output — they are the join key between this struct and profiling views.

## Gotchas

- All 15 profilers are heap-allocated in the ctor and never deleted (empty destructor) — intentional process-lifetime singletons, but it is a leak by construction.
- Profiler names are inconsistent in casing ("Update SceneGraph" vs lowercase "updateAllInvalidParts") — do not "fix" them; tooling may match exact strings.
