# DummyWindow.cpp

Source: `roblox-sandbox/RCCService/DummyWindow.cpp` (64 lines)

## Purpose

Creates a minimal, invisible (`WS_DISABLED`, empty caption) Win32 window. RCCService is a headless service, but some engine/rendering or message-loop components need a real `HWND` to attach to; this supplies a throwaway one.

## API

Free helpers (file-local linkage only by convention — none are static, so technically extern):

- `WNDCLASS DefineMyClass(WNDPROC winProc, LPCTSTR className, HINSTANCE hInst)` (line 6): fills a `WNDCLASS` with style 0, no icon/cursor/background/menu, given proc/class/instance.
- `HWND CreateMyWindow(LPCTSTR caption, LPCTSTR className, HINSTANCE hInstance, int width, int height)` (line 24): `::CreateWindow(className, caption, WS_DISABLED, CW_USEDEFAULT ×2, width, height, ...)`.

Class method:

- `DummyWindow::DummyWindow(int width, int height)` (line 49): `GetModuleHandle(0)`, registers class `"DummyWindow"` via `DefineMyClass(WindowProcedure, ...)`, then `CreateMyWindow(_T(""), ...)`. Stores `HWND handle`.
- `DummyWindow::~DummyWindow()` (line 62): `::DestroyWindow(handle)` only.
- `WindowProcedure` (line 39): default-proc everything except `WM_DESTROY → PostQuitMessage(0)`.

Public member (from `DummyWindow.h`): `HWND handle;`.

## Usage

Constructed wherever the service needs a placeholder window target (e.g., rendering/DirectX surface bootstrap in ThumbnailGenerator paths). Destroy via destructor/scoped ownership.

## Gotchas

- **`RegisterClass` runs on every construction** and is never unregistered — repeated construction leaks window-class registrations until process exit (harmless for a singleton-style use, sloppy otherwise).
- `WM_DESTROY → PostQuitMessage` inside a service process can post a quit to whatever thread pumps messages — surprising if this window's lifetime spans multiple owners.
- Window is created disabled and untitled; it is never shown.
- Includes are case-sensitive-inconsistent on disk: `"StdAfx.h"` here vs file `stdafx.h` (fine on Windows/macOS case-insensitive FS, breaks on case-sensitive builds).
