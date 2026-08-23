# XStudioBuild.h

## Purpose
Kill-switch for a special in-house Roblox Studio build used only to develop Xbox-specific CoreScripts. Defines `ENABLE_XBOX_STUDIO_BUILD`, forced to 0 everywhere except MSVC, and even there shipped as 0.

## API
```cpp
#define ENABLE_XBOX_STUDIO_BUILD 0 // forced 0 on non-_MSC_VER
```

## Usage
Code gated behind `#if ENABLE_XBOX_STUDIO_BUILD` compiles Xbox CoreScript dev support into Studio only when someone flips the define locally.

## Gotchas
- In-file directive: "DO NOT SUBMIT TO CI OR TRUNK WITH THIS SET TO ON."
- Non-MSVC path undefs then redefines to 0, so accidental `-DENABLE_XBOX_STUDIO_BUILD=1` on clang/gcc is neutralized.
