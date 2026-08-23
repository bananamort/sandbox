# WindowsClient/Teleporter.h

## Purpose

Header for `RBX::Teleporter` — "responsible for teleporting the player across places". Implements the `TeleportCallback` interface (from `v8datamodel/TeleportCallback.h`) so the engine-side `TeleportService` can call back into the Windows shell when in-game Lua requests a place switch. Holds a raw `Application*` and `FunctionMarshaller*`; no ownership.

## API

```cpp
namespace RBX {
class Teleporter : public TeleportCallback {
    Application* app;
    FunctionMarshaller* marshaller;
public:
    void initialize(Application* app, FunctionMarshaller* marshaller);
    virtual void doTeleport(const std::string& url, const std::string& ticket,
        const std::string& script);
    virtual bool isTeleportEnabled() const { return true; }
};
}
```

## Usage

Constructed by Application (one instance per process), `initialize(...)` registers it as the global TeleportService callback; from then on any `TeleportService:TeleportToPlaceId()`-style call in game Lua funnels through `doTeleport`. See Teleporter.cpp.md for behavior.

## Gotchas

- Header comment and class are minimal; the real semantics (which thread, what teardown happens) live entirely in Teleporter.cpp + `Application::Teleport`.
