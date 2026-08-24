# RenderSettings.cpp

Source: `roblox-sandbox/Rendering/GfxBase/RenderSettings.cpp` (72 lines)

## Purpose

Static data + constructor for `RBX::CRenderSettings`, the process-wide render configuration record: graphics mode, quality levels, AA, resolution presets and caches. Also defines the 18-entry resolution preset table and latched-mode statics.

## API

- `const G3D::Vector2int16 CRenderSettings::minGameWindowSize` — **(816, 638)**.
- `static CRenderSettings::GraphicsMode CRenderSettings::latchedGraphicsMode` — initialized `UnknownGraphicsMode`.
- `static CRenderSettings::AASamples CRenderSettings::aaSamples` — `defaultAASamples`.
- `const CRenderSettings::RESOLUTIONENTRY ResolutionTable[]` — 18 presets from 720×526 through 1920×1200 (720x526, 800x600, 1024x600, 1024x768, 1280x720, 1280x768, 1152x864, 1280x800, 1360x768, 1280x960, 1280x1024, 1440x900, 1600x900, 1600x1024, 1600x1200, 1680x1050, 1920x1080, 1920x1200).
- `CRenderSettings::CRenderSettings()` — defaults: fullscreenSize/windowSize = 800×600 (1024×768 on iOS; comments: *"fail safes in case auto detect procedure fails"*), graphicsMode=AutoGraphicsMode, qualityLevel/editQualityLevel=QualityAuto, antialiasingMode=AntialiasingOff, frameRateManagerMode=FrameRateManagerAuto, showAggregation=false, drawConnectors=false, minCullDistance=50, debugShowBoundingBoxes=false, debugReloadAssets=false, objExportMergeByMaterial=false, eagerBulkExecution=false, enableFRM=true, autoQualityLevel=1, resolutionPreference=ResolutionAuto, maxQualityLevel=QualityLevelMax, textureCacheSize=32 MB, meshCacheSize=32 MB.
- `const RESOLUTIONENTRY& getResolutionPreset(ResolutionPreset preset) const` — asserts `preset < ResolutionMaxIndex`, table entry identity, and `ResolutionMaxIndex == ARRAYSIZE(ResolutionTable)+1`; returns `ResolutionTable[preset-1]`.

## Usage

Paired with its header (200 lines of enums). The statics (`latchedGraphicsMode`, `aaSamples`) are process-global mutable state.

## Gotchas

- Presets are 1-based in the enum (`ResolutionAuto`=0 sentinel presumably); indexing is `preset-1`.
- Three RBXASSERTs encode the table invariant — release builds lose all bounds checking here.
- `minCullDistance(50)` default is the value UserInputUtil::setMinCullDistance (dead-code list) mutates.
