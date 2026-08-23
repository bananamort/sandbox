# dinput.h

Source: `roblox-sandbox/Win/dinput.h` (4417 lines)

## Purpose

**Verbatim vendored Microsoft DirectX SDK header** — the DirectInput API definitions (`Copyright (C) 1996-2000 Microsoft Corporation`), carrying the full `IDirectInput8`/`IDirectInputDevice8` COM interfaces, `DIK_*` scan-code constants, `DIDEVICEOBJECTDATA`, c_dfDIMouse/c_dfDIKeyboard data formats, and `HRESULT` codes. No Roblox modifications (verified — zero "roblox" hits).

## API

The standard DirectInput 8.x surface; nothing project-specific is declared here.

## Usage

Pulled in by `Win/UserInputUtil.{h,cpp}` after `#define DIRECTINPUT_VERSION 0x0800`. Because WindowsClient's include directories list `..\Win` ahead of the platform SDK's usual position for this legacy header, this vendored copy is what those TUs actually compile against.

## Gotchas

- This is a year-2000 snapshot of the header; it shadows whatever ships with the installed Windows SDK. Any DirectInput feature added later will not be visible through it.
- Being a vendored copy, it bypasses SDK security/retarget fixes — relevant to the v143 posture work.
