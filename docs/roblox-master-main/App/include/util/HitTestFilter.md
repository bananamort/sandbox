# util/HitTestFilter.h

## Purpose
Abstract predicate used by spatial hit tests to accept/skip/reject primitives during traversal. Three-valued result lets a test stop early, skip one primitive, or record a hit.

## Declared API
```cpp
class HitTestFilter {
public:
    typedef enum Result {
        STOP_TEST,     // Fail: stop the hit test - don't bore [sic] any further down
        IGNORE_PRIM,   // Ignore: keep testing (skip this primitive)
        INCLUDE_PRIM   // Hit: found something
    } Result;

    virtual Result filterResult(const Primitive* testMe) const = 0;
    virtual ~HitTestFilter() {}
};
```

## Gotchas
- Pure virtual — every filter must implement `filterResult`.
- `Primitive` is only forward-declared; include the real definition where the filter body needs it.
- Const interface: filters must be reentrant/stateless or manage their own synchronization.

## UNKNOWN
- Consumers in the physics/picking traversal code (outside this slice).
