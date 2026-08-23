# RenderSettingsItem.h

Source: `roblox-sandbox/ClientBase/RenderSettingsItem.h` (70 lines)

## Purpose

Declares `CRenderSettingsItem`, the persisted user-facing render-settings singleton. It merges the engine-side `RBX::CRenderSettings` state object (GfxBase layer) with the settings-item infrastructure (`RBX::GlobalAdvancedSettingsItem`) so that graphics options (graphics mode, AA, quality levels, resolution presets, caches) are exposed as reflection properties, saved with the other global settings, and broadcast to the render pipeline via `settingsChangedSignal`.

## API

```cpp
extern const char* const sRenderSettings;   // "RenderSettings"

class CRenderSettingsItem
    : public RBX::GlobalAdvancedSettingsItem<CRenderSettingsItem, sRenderSettings>
    , public RBX::CRenderSettings
{
public:
    CRenderSettingsItem();
    void setShowAggregation(bool value);
    void runProfiler(bool overwriteExistingValues);          // sets profileName = "profiled5"
    void setAASamples(AASamples value);
    void setFullscreenSize(G3D::Vector2int16 value);
    void setWindowSize(G3D::Vector2int16 value);
    void setGraphicsMode(GraphicsMode value);
    void setFrameRateManagerMode(FrameRateManagerMode value);
    void setAntialiasingMode(AntialiasingMode value);
    void setQualityLevel(QualityLevel value);
    void setEditQualityLevel(QualityLevel value);
    void setAutoQualityLevel(int level);
    void setResolutionPreference(ResolutionPreset value);
    void setMinCullDistance(int value);
    void setDebugShowBoundingBoxes(bool value);
    void setEagerBulkExecution(bool value);
    void setEnableFRM(bool value);
    void setTextureCacheSize(unsigned int size);
    void setMeshCacheSize(unsigned int size);
    // get/setDebugDisableInterpolation, get/setShowInterpolationPath,
    // get/setDebugReloadAssets, get/setObjExportMergeByMaterial

    bool isSynchronizedWithPhysics;                          // public field, bound directly
    static RBX::Reflection::BoundProp<std::string> prop_profileName;
    static RBX::Reflection::EnumPropDescriptor<CRenderSettingsItem, ResolutionPreset> prop_resolution;

    rbx::signal<void(const RBX::Reflection::PropertyDescriptor*)> settingsChangedSignal;
};
```

## Usage

- Consumed via `CRenderSettingsItem::singleton()` from MachineConfiguration.cpp (machine-config POST), and included by WindowsClient's Application.cpp, View.cpp, RenderJob.cpp, UserInput.cpp, GameVerbs.cpp, which read/apply settings when constructing views and handling display changes.
- Most setters of reflection-registered properties fire `settingsChangedSignal(&prop)` so active render jobs re-read state; getters/setters mostly forward to the inherited `CRenderSettings` fields. Silent (no-signal) setters: `setFullscreenSize`, `setWindowSize`, cache-size setters, `setDebugReloadAssets`, `setObjExportMergeByMaterial`.

## Gotchas

- The header declares `setFrameRateManagerMode`/`setAntialiasingMode`, but their bodies are not hand-written in the .cpp — they are generated there by `SET_MODE(FrameRateManager, frameRateManager)` / `SET_MODE(Antialiasing, antialiasing)`. `SET_VAR(bool, EagerBulkExecution, ...)` likewise generates both the descriptor and the setter body.
- `setMinCullDistance(int)` is declared but has NO definition anywhere in this tree (verified by tree-wide grep) — it is a dead declaration; any ODR-use would fail to link.
- Debug interpolation/reload flags proxy into `PartInstance` statics (`disableInterpolation`, `showInterpolationPath`) rather than local fields.
- `prop_profileName` carries `STREAMING` flag; `EnableFRM` is registered with `LEGACY_SCRIPTING`.
