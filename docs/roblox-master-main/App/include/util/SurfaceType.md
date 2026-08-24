# util/SurfaceType.h

## Purpose
The classic part-surface enum (Studs/Inlet/Weld/Glue/Universal/Rotate variants) that historically drove auto-joining; plus helpers `IsNoSurface`/`IsRotate` and a `Legacy::SurfaceConstraint` enum preserved from older code. In-header note: "TODO - Joint.cpp uses this ordering - fix up as a class".

## Declared API
```cpp
typedef enum {
    NO_SURFACE = 0,
    GLUE,
    WELD,
    STUDS,
    INLET,
    UNIVERSAL,
    ROTATE,          // special ordering here
    ROTATE_V,
    ROTATE_P,
    NO_JOIN,                  // specifically prevents joining (via ManualWeldHelper)
    NO_SURFACE_NO_OUTLINES,   // identical to NO_SURFACE, but removes outlines
    NUM_SURF_TYPES
} SurfaceType;

inline bool IsNoSurface(SurfaceType surface);  // NO_SURFACE or NO_SURFACE_NO_OUTLINES
inline bool IsRotate(SurfaceType surface);     // ROTATE..ROTATE_P inclusive range check

namespace Legacy {
// LEGACY from when this was separate stuff ("TODO: improve precedence logic"):
typedef enum { NO_CONSTRAINT = 0, ROTATE_LEGACY, ROTATE_P_LEGACY, ROTATE_V_LEGACY,
               NUM_CONSTRAINT_TYPES } SurfaceConstraint;
}
```

## Gotchas
- The ROTATE..ROTATE_P contiguity is load-bearing: `IsRotate` relies on it ("special ordering here").
- `NO_SURFACE_NO_OUTLINES` renders like NO_SURFACE but suppresses outlines — two values mean "no surface".
- Enum ordering is consumed by Joint.cpp per the TODO — do not reorder casually.
- Zero value means "no surface", so zero-init is safe-ish by design.

## UNKNOWN
- Where surface types map to joint creation rules now (Joint.cpp outside this slice).
