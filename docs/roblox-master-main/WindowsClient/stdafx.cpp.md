# WindowsClient/stdafx.cpp

## Purpose

The precompiled-header generator: its only statement is `#include "stdafx.h"`. The compiler builds the PCH from this translation unit; every other .cpp in WindowsClient consumes it via `/Yu"stdafx.h"` (see WindowsClient.vcxproj).

## API

None. One line: `#include "stdafx.h"`.

## Usage

Never edited except when stdafx.h's include set changes. Must remain the PCH source file referenced by the project's PrecompiledHeader settings.

## Gotchas

- If stdafx.h gains a heavy or order-sensitive include, this otherwise-trivial TU is where compile breakage surfaces first.
