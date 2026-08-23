# INDEX.md — ClientBase

Directory: `roblox-sandbox/ClientBase/` (7 files)

ClientBase holds the client machine's configuration machinery: the persisted render-settings singleton shown in the settings UI (`RenderSettingsItem`), the telemetry POST describing the machine's graphics capabilities to the website (`MachineConfiguration`), and the reflection-metadata subsystem (`ReflectionMetadata.*`) that loads `ReflectionMetadata.xml` — the documentation tree behind Studio's object browser and API dumps. Despite the generic name this directory is first-party code compiled directly into the client targets; there is no project file here, the sources are pulled into client builds by include path.

| File | One-liner |
|---|---|
| MachineConfiguration.h | Declares `RBX::postMachineConfiguration(baseURL, lastGfxMode)` |
| MachineConfiguration.cpp | Collects DebugSettings/RenderSettings props into `name:value;` payload, async POST to `/Game/MachineConfiguration.ashx`; errors swallowed |
| ReflectionMetadata.h | `RBX::Reflection::Metadata` namespace: Instance tree mirroring descriptors, singleton loader, descriptor lookups |
| ReflectionMetadata.cpp | Registration, XML load/save, all `get(descriptor)` lookups, plain-text API dump writer incl. duplicate-declaration report |
| ReflectionMetadata.xml | 4224-line data file: per-class/member summaries, deprecation, explorer order/icons, UI bounds, enum browseability |
| RenderSettingsItem.h | `CRenderSettingsItem`: GlobalAdvancedSettingsItem + CRenderSettings hybrid exposing graphics options as reflection props |
| RenderSettingsItem.cpp | Enum/property registration (GraphicsMode, QualityLevel, Resolution presets...), change-signal setters |

Cross-directory notes: WindowsClient consumes all three subsystems (Application.cpp includes both RenderSettingsItem.h and MachineConfiguration.h and calls `CRenderSettingsItem::singleton()`; View.cpp and RenderJob.cpp also call `singleton()`; UserInput.cpp/GameVerbs.cpp include RenderSettingsItem.h). MachineConfiguration.cpp also pulls ClientShared's `format_string.h` and `RobloxServicesTools.h`.
