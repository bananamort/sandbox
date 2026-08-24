# RenderStats.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/RenderStats.h` (101 lines)

## Purpose

Declares `RBX::RenderStats` — the render pipeline's statistics hub: 16 named `Profiling::CodeProfiler` timers (one per pipeline stage) plus per-pass and clustering counters. Also defines the small aggregate structs `RenderPassStats` and `ClusterStats`.

## API

```cpp
struct RenderPassStats {          // counters per render pass
    unsigned int batches, faces, vertices, stateChanges, passChanges;
    RenderPassStats();            // all zero
    RenderPassStats& operator+=(const RenderPassStats&);
    RenderPassStats operator+(const RenderPassStats&) const;
};

struct ClusterStats {
    unsigned int clusters, parts; // zero-init
};

class RBX::RenderStats {
public:
    // 16 scoped_ptr<CodeProfiler>: cpuRenderTotal, culling, flip, renderObjects,
    //   updateLighting, adorn2D, adorn3D, visualEngineSceneUpdater, finishRendering,
    //   renderTargetUpdate, frameRateManager, textureCompositor, updateSceneGraph,
    //   updateAllInvalidParts, updateDynamicsAndAggregateStatics, updateDynamicParts
    RenderPassStats passTotal, passScene, passShadow, passUI, pass3DAdorns;
    ClusterStats clusterFast, clusterFastFW, clusterFastHumanoid;
    ClusterStats lastFrameFast;
    unsigned lastFrameMegaClusterChunks;
    RenderStats(); ~RenderStats();
};
```

Note member naming mismatch with the .cpp: header says `adorn2D`, ctor names profiler string "Adorn 2D" — both refer to the same scoped_ptr.

## Usage

Includes `boost/scoped_ptr.hpp`, `util/Profiling.h`. Instantiated once by VisualEngine; backends increment `pass*` stats during draw; profilers are used via RAII scopes elsewhere.

## Gotchas

- `scoped_ptr` = non-copyable, non-transferable — RenderStats itself is effectively a singleton-style object.
- Counters are plain unsigned ints — no overflow protection on long sessions at high face counts (wraps at 4.29e9).
- `lastFrame*` members are snapshot slots written at frame end; readers must tolerate mid-frame tearing.
