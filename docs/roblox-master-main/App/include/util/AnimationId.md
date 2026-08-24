# util/AnimationId.h

## Purpose
Thin typed wrapper distinguishing animation content from generic content: `AnimationId` is-a `ContentId` with an `active://` scheme check and a shared null instance.

## Declared API
```cpp
class AnimationId : public ContentId {
public:
    AnimationId();                          // null id
    AnimationId(const ContentId& id);
    AnimationId(const char* id);
    AnimationId(const std::string& id);

    bool isActive() const { return toString().substr(0, 9) == "active://"; }

    static AnimationId nullAnimation();
};
```

## Gotchas
- `nullAnimation()` returns a copy of a function-local static — the comment notes the underlying ContentId name is resolved via `boost::call_once`; cheap to call, but all callers share one instance.
- `isActive()` does a substring compare on the first 9 chars; a 9+-char string starting exactly with `active://` (note trailing slash counts in the 9: `active://` is exactly 9 chars) matches. Shorter strings are safe (`substr` clamps).
- All ContentId semantics (hashing, comparison, http/local schemes) inherit — see ContentId.md.

## UNKNOWN
- Where `active://` URIs are produced/consumed (animation streaming path outside this slice).
