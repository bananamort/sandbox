# WindowsClient/ReleasePatcher.h

## Purpose

Declares `RBX::Security::patchMain()` — entry point of "version 2 of the golden hash patcher" (header comment in the .cpp notes version 1 was an external program; that external program survives as RobloxGoldenHashPatcher/). patchMain rewrites the client's own exe on disk with per-build security metadata and produces the patched `<exe>.tmp`.

## API

```cpp
namespace RBX { namespace Security {
    __declspec(code_seg(".zero")) bool patchMain();
} }
```

The `.zero` code segment is deliberate: all patcher code lives there so `createUpdatedExe` can zero it out of the output file (see ReleasePatcher.cpp.md).

## Usage

Called from Application.cpp:1057 inside the obfuscated command-line gate (`-w <key>` where key ≡ 0x0BADC0DE mod both 0x01234567 and 0x89ABCDEF): `protectVmpSections(); RBX::Security::patchMain(); return false;` — a self-reprocessing mode, not a game join.

## Gotchas

- The declaration carries the same `.zero` segment attribute as every definition in ReleasePatcher.cpp — required so the linker places them together.
