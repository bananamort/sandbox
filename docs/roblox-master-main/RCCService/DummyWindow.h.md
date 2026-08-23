# DummyWindow.h

Source: `roblox-sandbox/RCCService/DummyWindow.h` (9 lines)

## Purpose

Declares `DummyWindow`, a tiny RAII wrapper around an invisible Win32 window used to give the headless RCC service a valid `HWND`.

## API

```cpp
class DummyWindow
{
public:
    HWND handle;                       // raw window handle (valid after ctor)
    DummyWindow(int width, int height);
    ~DummyWindow(void);                // DestroyWindow(handle)
};
```

`#pragma once`; relies on Windows headers being included before it (no includes of its own).

## Usage

Construct with desired pixel size, pass `.handle` to whatever needs an HWND (render targets, message pumps), let it fall out of scope.

## Gotchas

- Header does not include `<windows.h>` itself — include order matters.
- Each construction re-registers the `"DummyWindow"` window class (see `DummyWindow.cpp.md`).
