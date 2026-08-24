# SurfaceSelection.cpp

## Purpose

Implements `SurfaceSelection` ("SurfaceSelection"), a DescribedCreatable PartAdornment highlighting one face of a part with a colored surface quad — the Studio surface-picker visual. File tail also hosts anti-tamper decoy `Security::hackFlag0`.

## Key types and API

Descriptor:
- `prop_Surface("TargetSurface")` — EnumPropDescriptor NormalId, category_Data, default NORM_X.

Rendering: when visible and adornee alive → `DrawAdorn::partSurface(part, surfaceId, adorn, color)`.

Tail decoy: `namespace RBX::Security { unsigned int hackFlag0 = 0; }` under "Randomized Locations for hackflags" (same pattern as PhysicsInstructions.md's hackFlag6).

## Usage / reflection touchpoints

Script-creatable adornment; pairs with SelectionBox.md family in this folder.

## Gotchas
- Only ONE surface per adornment — six needed for full-part highlight.
- No render-dirty call on setSurface (relies on property-change render invalidation upstream).
