# RbxPlatform.h

## Purpose
Minimal OS-header umbrella. Its only real job today is pulling `<windows.h>` on WIN32 with the right hygiene defines (`VC_EXTRALEAN`, `STRICT`, `WIN32_LEAN_AND_MEAN`, `NOMINMAX`) plus `<intrin.h>`, then undefining the hygiene macros so later includes are unaffected. Non-Windows platforms get nothing but the `RbxBase.h` chain. Comment in-file admits it "only supports windows at this time".

## API
No declarations; macro/environment setup only.

## Usage
Include wherever raw Win32 types/HANDLEs or intrinsics are needed without dragging full windows headers into every consumer. First include of `RbxAssert.cpp`.

## Gotchas
- Undefines `_WINSOCKAPI_`/`_G3D_INTERNAL_HIDE_WINSOCK_` after including windows.h, which allows winsock.h to be included later by other headers — deliberate but surprising ordering dependency.
- `NOMINMAX` is scoped: undefined again at end of block, so subsequent headers may reintroduce min/max macros.
