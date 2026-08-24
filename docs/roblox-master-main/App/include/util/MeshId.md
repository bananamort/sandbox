# util/MeshId.h

## Purpose
Typed ContentId for mesh assets: `MeshId` is-a `ContentId` with no added behavior (pure strong-typing wrapper). Despite the includes of Service/RunStateOwner/Event, nothing else is declared here.

## Declared API
```cpp
class MeshId : public ContentId {
public:
    MeshId();
    MeshId(const ContentId& id);
    MeshId(const char* id);
    MeshId(const std::string& id);
};
```

## Gotchas
- No scheme helpers (unlike AnimationId's `isActive`) — all semantics inherited from ContentId.md.
- Includes (`V8Tree/Service.h`, `Reflection/Event.h`, `Util/RunStateOwner.h`) appear vestigial — likely leftovers from when mesh fetching logic lived nearby.

## UNKNOWN
- Where mesh content resolution/fetching hooks to this type (mesh streaming code outside this slice).
