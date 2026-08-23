# Tracer.cpp

Source: `roblox-sandbox/Win/Tracer.cpp` (11 lines)

## Purpose

Empty shell: a copyright banner, `#include "stdafx.h"`, `#include "rbx/Debug.h"`, and an empty `namespace RBX { }`. No symbols are defined. It exists only as a compilation-unit placeholder in the Win project — likely the residue of a stripped tracing utility.

## API

None. The translation unit contributes zero functions, classes, or globals.

## Usage

Nothing includes it (headers can't) and nothing references it; it compiles to an empty object file wherever the Win sources are listed. Keep-or-delete is free of behavioral risk.

## Gotchas

- Despite the name suggesting a profiler/tracer utility, there is nothing here — do not assume tracing functionality lives in this file when instrumenting the sandbox logger.
