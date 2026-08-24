# PartCookie.cpp

## Purpose

Implements `PartCookie::compute`, a one-function utility that folds a PartInstance's render-relevant child inventory into a bitmask "cookie". The cookie lets downstream code (extrusion/character-mesh consumers such as ExtrudedPartInstance and character assembly) cheaply ask "does this part carry a SpecialShape/FileMesh/HeadMesh, and does it have decals, notably a front-face decal?" without walking children each time. Preserves the part's pre-existing IS_HUMANOID_PART bit as the base.

## Key types and API

- `static unsigned int PartCookie::compute(PartInstance*)` — the entire TU. Starts from `part->getCookie() & IS_HUMANOID_PART`, then ORs flags while iterating direct children:
  - Any `DataModelMesh` child → `HAS_SPECIALSHAPE`, and explicitly CLEARS `HAS_FILEMESH|HAS_HEADMESH` first ("all data about the special shape refers to the last special shape" comment) because multiple mesh children may exist:
    - `SpecialShape` with `getMeshType() == FILE_MESH` → `HAS_FILEMESH`; `HEAD_MESH` → `HAS_HEADMESH`;
    - plain `FileMesh` child (non-SpecialShape) → `HAS_FILEMESH`.
  - `Decal` child with non-null Texture → `HAS_DECALS`; additionally `Face == NORM_Z_NEG` → `HAS_DECALS_Z_NEG`.
  Flag names come from the header enum (`IS_HUMANOID_PART`, `HAS_SPECIALSHAPE`, `HAS_FILEMESH`, `HAS_HEADMESH`, `HAS_DECALS`, `HAS_DECALS_Z_NEG`); only their usage is visible here.

## Usage / reflection touchpoints

No REFLECTION macros in this TU; the cookie is an internal cache value on PartInstance (`getCookie()`), never exposed to Lua directly.

## Gotchas

- "Last wins": if a part has several mesh children, only the LAST one's kind is reflected — earlier HAS_FILEMESH/HAS_HEADMESH bits are deliberately wiped per DataModelMesh encountered.
- Decals count only when their Texture string is non-empty; texture-less Decal children are invisible to the cookie.
- Only NORM_Z_NEG (front) face decals get their dedicated bit; other faces just set generic HAS_DECALS.
- Only DIRECT children are inspected — meshes/decales nested deeper are not seen.
- UNKNOWN: numeric flag values and any additional cookie bits live in V8DataModel/PartCookie.h / PartInstance.h outside this TU.
