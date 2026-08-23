# RbxG3D/include/RbxG3D/RbxTime.h

## Purpose

Declares `RBX::RbxTime`, a tiny static time-source wrapper around G3D's real-time clock (`G3D::RealTime getTick()` plus a private `static G3D::RealTime m_startTime` epoch). **Vestigial**: no `.cpp` implementing either symbol exists anywhere in the tree.

## API

```cpp
namespace RBX {
class RbxTime {
public:
    static G3D::RealTime getTick();
private:
    static G3D::RealTime m_startTime;
};
}
```

## Lua globals and events

None — engine-side C++ header; not exposed to Lua.

## Usage (who loads it)

Included by four first-party files — `WindowsClient/UserInput.cpp:17`, `App/script/ScriptContext.cpp:43`, `App/v8datamodel/DataModel.cpp:117`, `App/v8datamodel/factoryregistration.cpp:203` — but none call `RbxTime::getTick()` (verified by tree-wide grep). Actual timing in those files flows through `RBX::Time` declared in `Base/include/rbx/rbxTime.h` (a different file) and `G3D::System`. Also listed in this module's CMakeLists.txt HEADERS and in both Xcode targets' Headers phases, but **not** in RbxG3D.vcxproj.

## Gotchas

- **Dead declaration**: calling `RbxTime::getTick()` would fail at link time (`undefined symbol`); `m_startTime` likewise has no storage allocated.
- Name-collision trap: two unrelated headers named `RbxTime.h` exist — `Base/include/rbx/rbxTime.h` (live, `RBX::Time`) and this one. Case-insensitive filesystems make `#include "RBX/RbxTime.h"` ambiguous; `PartOperationAsset.cpp:12` uses that spelling and resolves to the Base one via include order.
