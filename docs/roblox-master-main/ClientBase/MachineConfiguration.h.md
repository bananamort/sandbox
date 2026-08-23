# MachineConfiguration.h

Source: `roblox-sandbox/ClientBase/MachineConfiguration.h` (6 lines)

## Purpose

Declares the single entry point for the machine-configuration telemetry post: `RBX::postMachineConfiguration(const char* baseURL, int lastGfxMode)`. This is the report the client sends to the website's `/Game/MachineConfiguration.ashx` endpoint describing the machine's graphics capabilities so the server can pick a suitable rendering profile for the session.

## API

```cpp
namespace RBX
{
    void postMachineConfiguration(const char* baseURL, int lastGfxMode);
}
```

That is the entire header — one free function in namespace RBX, no class.

## Usage

Included by `WindowsClient/Application.cpp`, which calls the function during client startup once the render pipeline knows the last graphics mode used. Implemented in `MachineConfiguration.cpp` alongside `RenderSettingsItem.h`.

## Gotchas

- The function name says "post" because it performs an HTTP POST; there is no return value and no error surfaced to the caller — all failures are swallowed inside the .cpp.
