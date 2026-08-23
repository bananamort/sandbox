# RenderSettingsItem.cpp

Source: `roblox-sandbox/ClientBase/RenderSettingsItem.cpp` (344 lines)

## Purpose

Implements `CRenderSettingsItem`: registers the "RenderSettings" class and its enums with the reflection system, defines all property descriptors grouped by settings category ("General", "Performance", "Quality", "Debug", "Cache", "Screen"), and implements the setters that fire `settingsChangedSignal` when a value actually changes.

## API

Class registration: `RBX_REGISTER_CLASS(CRenderSettingsItem)` plus enum registrations for `CRenderSettings::{AASamples, GraphicsMode, FrameRateManagerMode, AntialiasingMode, QualityLevel, ResolutionPreset}` via explicit `EnumDesc<T>::EnumDesc()` template specializations:

- AASamples: None, 4, 8.
- GraphicsMode: Automatic, Direct3D9, Direct3D11, OpenGL, NoGraphics.
- FramerateManagerMode: Automatic, On, Off.
- Antialiasing: Automatic, Off, On.
- QualityLevel: "Automatic" plus generated names `Level01..LevelNN` (`RBX::format("Level%.2d", i)` up to `QualityLevelMax`, asserted < 100) and legacy aliases `"Level NN"` via `addLegacyName`.
- Resolution: Automatic plus ~20 fixed presets (720x526 ... 1920x1200), several with `(wide)` legacy aliases.

Registered properties (REFLECTION_BEGIN/END block): GraphicsMode, ExportMergeByMaterial, FrameRateManager, QualityLevel, EditQualityLevel, IsAggregationShown (Debug), IsSynchronizedWithPhysics (Performance), AASamples, profileName (Quality, STREAMING), Antialiasing, ShowBoundingBoxes (Debug), AutoFRMLevel (Debug), EnableFRM (Debug, LEGACY_SCRIPTING), DebugDisableInterpolation, ShowInterpolationpath, ReloadAssets (Debug), Resolution (Screen), TextureCacheSize, MeshCacheSize (Cache), plus bound function `GetMaxQualityLevel()` (Security::None). `SET_VAR(bool, EagerBulkExecution, ...)` generates the EagerBulkExecution descriptor + setter.

Constructor: name "Rendering", defaults currentDisplaySize/fullscreenSize to 800x600 (1024x768 if `SystemUtil::getVideoMemory() >= 16000000` bytes).

## Usage

- The singleton instance is read by MachineConfiguration.cpp (General-category props for the machine-config POST) and by WindowsClient code (Application.cpp, View.cpp, RenderJob.cpp, UserInput.cpp, GameVerbs.cpp).
- Setters follow one pattern: compare, assign, then `settingsChangedSignal(&prop_X)` so listeners (render jobs) react. Exceptions that assign silently with no signal: `setFullscreenSize`, `setWindowSize`, `setTextureCacheSize`, `setMeshCacheSize`, `setDebugReloadAssets`, `setObjExportMergeByMaterial`. (`runProfiler` writes through `prop_profileName.setValue`, which is also not the `settingsChangedSignal` path.)

## Gotchas

- `runProfiler(bool overwriteExistingValues)` writes profileName "profiled5" — a hardcoded profile tag, not a real GPU profiler run.
- `setAutoQualityLevel` fires `settingsChangedSignal(&prop_frmQuality)` (the QualityLevel descriptor), not an auto-level-specific one — listeners see it as a quality-level change.
- Interpolation/reload debug flags are stored on `PartInstance` statics, so they are global engine state, not per-item fields.
- QualityLevel enum generation relies on `RBXASSERT(QualityLevelMax < 100)` — in release builds a value >= 100 would overflow the two-digit naming.
- `snprintf(numberstart, 3, "%2u", i)` writes legacy alias strings in place inside `"Level 00"` buffers; the trailing NUL handling is subtle (buffer of exactly 9 chars including terminator).
