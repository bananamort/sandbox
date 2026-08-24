# RenderSettings.h

Source: `roblox-sandbox/Rendering/GfxBase/include/GfxBase/RenderSettings.h` (200 lines)

## Purpose

Declares `RBX::CRenderSettings` — the render configuration record and its enum vocabulary: GraphicsMode (D3D11/D3D9/OpenGL/NoGraphics), AA samples, quality levels 1–21, resolution presets, FRM mode. Mostly a getter façade over protected fields with a few process-global statics.

## API

```cpp
class CRenderSettings {
public:
    enum AASamples { NONE=1, AA4=4, AA8=8 };
    static const AASamples defaultAASamples = NONE;   // =1
    static const G3D::Vector2int16 defaultWindowSize;             // defined elsewhere
    static const G3D::Vector2int16 defaultFullscreenSize();        // function!
    static const G3D::Vector2int16 minGameWindowSize;              // (816,638) in .cpp

    typedef enum { UnknownGraphicsMode=0, AutoGraphicsMode=1, Direct3D11=2,
                   Direct3D9=3, OpenGL, NoGraphics } GraphicsMode;
    static GraphicsMode latchedGraphicsMode;

    typedef enum { AntialiasingAuto=0, AntialiasingOn=1, AntialiasingOff=2 } AntialiasingMode;
    typedef enum { FrameRateManagerAuto=0, FrameRateManagerOn=1, FrameRateManagerOff=2 } FrameRateManagerMode;
    typedef enum { QualityAuto=0, QualityLevel1..QualityLevel21, QualityLevelMax } QualityLevel;
    typedef enum { ResolutionAuto, Resolution720x526 ... Resolution1920x1200,
                   ResolutionMaxIndex } ResolutionPreset;
    struct RESOLUTIONENTRY { ResolutionPreset preset; int width; int height; };

protected:
    GraphicsMode graphicsMode; AntialiasingMode antialiasingMode;
    FrameRateManagerMode frameRateManagerMode; QualityLevel qualityLevel, editQualityLevel;
    ResolutionPreset resolutionPreference; int autoQualityLevel, maxQualityLevel,
        minCullDistance; bool debugShowBoundingBoxes, debugReloadAssets, enableFRM,
        objExportMergeByMaterial; static AASamples aaSamples;
    G3D::Vector2int16 fullscreenSize, windowSize;   // "filtered setting to use by app"
    bool showAggregation, drawConnectors, eagerBulkExecution;
    unsigned int textureCacheSize, meshCacheSize;   // comment says KB (ctor sets MB-scale)
public:
    CRenderSettings();
    static AASamples getAASamplesSafe();            // "Thread-safe" (plain read)
    getGraphicsMode/setGraphicsMode;                // setter non-inline (impl elsewhere)
    GraphicsMode getLatchedGraphicsMode();          // lazily pins latched from current
    getters: aaSamples, fullscreenSize, windowSize, FRM mode, AA mode,
             quality/edit/max/auto quality, resolutionPreference
    const RESOLUTIONENTRY& getResolutionPreset(ResolutionPreset) const; // in .cpp
    virtual void setAutoQualityLevel(int level) {}  // "FRM would like to report latest setting"
    float getMaxFrameRate() const { return 300.0f; }   // hardcoded
    float getMinFrameRate() const { return 30.0f; }    // hardcoded
    getDrawConnectors/setDrawConnectors; getMinCullDistance;
    getDebugShowBoundingBoxes/getDebugReloadAssets/getObjExportMergeByMaterial/
    getEnableFRM/getEagerBulkExecution/getTextureCacheSize/getMeshCacheSize
};
```

## Usage

Included by ViewBase.h, RenderCaps.h and backend settings code. Subclasses (app-side render settings) override `setAutoQualityLevel`.

## Gotchas
- `defaultFullscreenSize` is a FUNCTION while `defaultWindowSize` is a data member — easy to misuse.
- `getAASamplesSafe` is just an unsynchronized static read; "thread-safe" only in the trivial sense.
- Frame-rate bounds are HARDCODED (300 max / 30 min) despite the FRM machinery.
- Cache-size comment says KB but ctor stores 32 MB values — units are whatever ctor says.
- `setGraphicsMode` is declared but **never defined on the base class** (not in RenderSettings.cpp nor anywhere else) — the only implementation is the subclass override `CRenderSettingsItem::setGraphicsMode` (ClientBase/RenderSettingsItem.cpp:222; CRenderSettingsItem : public RBX::CRenderSettings). Calling it through a plain `CRenderSettings` fails at link time.
