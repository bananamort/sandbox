# stdafx.cpp

Source: `roblox-sandbox/RCCService/stdafx.cpp` (8 lines)

## Purpose

Precompiled-header builder for the project. Contains exactly `#include "stdafx.h"` plus wizard comments. Compiling this one TU produces `RCCService.pch`; all other TUs are set to use/force-include it (see `RCCService.vcxproj`).

## API

None — no symbols defined.

## Usage

Must remain the only TU that compiles `stdafx.h` *without* PCH reuse settings; deleting it breaks the whole project's PCH configuration.

## Gotchas

- Purely a build-system artifact; nothing to port or test.
