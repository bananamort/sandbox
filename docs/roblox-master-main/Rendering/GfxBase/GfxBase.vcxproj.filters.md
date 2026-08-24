# GfxBase.vcxproj.filters

Source: `roblox-sandbox/Rendering/GfxBase/GfxBase.vcxproj.filters` (125 lines)

## Purpose

Visual Studio Solution-Explorer display-filter metadata for GfxBase.vcxproj — three standard buckets (Source Files / Header Files / Resource Files) mapping each item. No build semantics.

## API

- Filters: `Source Files` {ED173019-2702-4d5d-9B8F-861C554BA151} cpp/c/... ; `Header Files` {3EC32423-84F6-4bbb-9F54-2F648B14225C} h/hpp/inl...; `Resource Files` {87ED97D5-0D75-49ef-92BF-8BA0ED473FBA} rc/ico/resx... (resource filter defined but EMPTY — no resource items).
- ClCompile mappings: all 14 .cpp → Source Files.
- ClInclude mappings: 21 headers → Header Files, mirroring the vcxproj's ClInclude list exactly (AdornSurface.h/AdornBillboarder2D.h appended at the end of the list).

## Usage

Consumed only by Visual Studio UI. Must stay in sync with GfxBase.vcxproj item lists or files show up unfiltered/orphaned in the IDE.

## Gotchas
- Same header-list drift as the parent vcxproj: AsyncResult.h and PartIdentifier.h appear NOWHERE here either.
- UTF-8 BOM at file start.
