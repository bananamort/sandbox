# MachineConfiguration.cpp

Source: `roblox-sandbox/ClientBase/MachineConfiguration.cpp` (89 lines)

## Purpose

Implements `RBX::postMachineConfiguration(baseURL, lastGfxMode)`: collects the client's display/render settings into a flat `name:value;` string and asynchronously POSTs it to `<baseURL>/Game/MachineConfiguration.ashx`. The server uses this to decide which graphics quality profile the machine gets.

## API

```cpp
void RBX::postMachineConfiguration(const char* baseURL, int lastGfxMode);
```

File-local helpers:

```cpp
static void appendProperty(const char* category, std::stringstream& data, const RBX::Reflection::Property& prop);
static void HandleAsyncHttp(std::string *response, std::exception *exception);   // intentionally empty
```

## Usage

Called from `WindowsClient/Application.cpp`. Internally it pulls from two settings singletons:

- `RBX::DebugSettings::singleton()` — contributes every property whose descriptor category is `"Profile"` (vertex/pixel shader model, resolution string, etc.). Before serializing it forces `setVertexShaderModel(-1)` and `setPixelShaderModel(-1)`; the setters are plain member stores and the `"Profile"` descriptors (`prop_getVertexShaderModel` / `prop_getPixelShaderModel`) read those members back through their getters, so the POST payload actually reports `-1` for both unless something re-populates them between the reset and serialization (nothing here does).
- `CRenderSettingsItem::singleton()` (`RenderSettingsItem.h`) — contributes every property in category `"General"`, plus `lastGfxMode:<n>;`.

On `_WIN32` it parses `debugsettings.resolution()` with `sscanf_s("%d x%d")` into a `G3D::Vector2int16 displayResolution` and takes `rendersettings.getFullscreenSize()`. Note both variables are computed but never appended to the payload — dead data on the current build.

The URL is built with `BuildGenericGameUrl(baseURL, "Game/MachineConfiguration.ashx")` when fast flag `FFlag::UseBuildGenericGameUrl` is on; otherwise by string concatenation with `trim_trailing_slashes`.

## Gotchas

- The POST is asynchronous: `RBX::Http(url).post(...)` with completion callback `HandleAsyncHttp`, which is an empty TODO — response bodies and exceptions are silently discarded.
- Everything is wrapped in `try { ... } catch (const std::exception&) {}`: any failure (including Http construction) is swallowed with no logging.
- `displayResolution` / `fullscreenResolution` are parsed but never serialized; only DebugSettings "Profile" props, RenderSettingsItem "General" props, and `lastGfxMode` reach the wire.
- Depends on fast flag `UseBuildGenericGameUrl`; behavior differs between the two URL-building paths only in slash handling.
- Windows-only fields (`sscanf_s`) are compiled out elsewhere; on non-Windows the resolution defaults of 800x600 stay unused.
