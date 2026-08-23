# RbxG3D/RbxG3D.vcxproj.filters

## Purpose

Visual Studio Solution Explorer filter metadata for RbxG3D.vcxproj. Three standard buckets — `Source Files` (Frustum.cpp, RbxCamera.cpp, RbxRay.cpp), `Header Files` (include\RbxG3D\{Frustum,RbxCamera,RbxRay}.h), and an empty-by-content `Resource Files`. No build semantics whatsoever.

## API

N/A (display metadata). Standard VS4 GUIDs: `{4FC737F1-…}` sources, `{93995380-…}` headers, `{67DA6AB6-…}` resources.

## Usage

Opened only by Visual Studio to organize the project tree; msbuild ignores it.

## Gotchas

- Mirrors the vcxproj exactly (3 cpp + 3 h); like the vcxproj it omits RbxTime.h.
- File is BOM-prefixed UTF-8 (raw bytes begin with an EF BB BF byte-order mark) — normal for VS-generated filters files; don't "fix" it.
