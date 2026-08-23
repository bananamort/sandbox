# WindowsClient/stdafx.h

## Purpose

Precompiled-header umbrella for the WindowsClient project: Win32 + ATL headers, CRT/C++ basics, the Boost subset the client uses, and the `#import` of shdocvw.dll that generates the IWebBrowser2 smart-pointer wrappers needed for ActiveX browser hosting (RbxWebView/WebBrowserAxDialog). Every .cpp includes it first.

## API

Preprocessor/imports only — no code symbols:

- Defines: `WIN32_LEAN_AND_MEAN`; `_CRT_SECURE_NO_WARNINGS 1` (comment: "Microsoft's standard function deprecation crap" — silences strcpy etc.).
- Windows/ATL: `<windows.h>`, `<atlsync.h>`, `<atlwin.h>`, `<atlbase.h>`, `<Sensapi.h>` (network-connectivity sensing), `<Shellapi.h>`, `<Softpub.h>`+`<wintrust.h>`+`<wincrypt.h>` (WinVerifyTrust / crypto — used by release-patching/auth plumbing), `<comutil.h>` (`_bstr_t`, `_variant_t`).
- CRT/C++: stdlib, malloc, memory, tchar, fstream.
- Boost (2016-era): format, bind (included twice), iostreams/copy, program_options, scoped_ptr.
- `#import "shdocvw.dll" include("OLECMDID", "OLECMDF", "OLECMDEXECOPT", "tagREADYSTATE")` — generates `shdocvw.tlh/.tli` at build time; supplies `SHDocVw::IWebBrowser2Ptr` and the OLE command enums used by the in-game browser.

## Usage

Included verbatim as the first line of every translation unit in this module; the PCH it seeds is what keeps client build times sane. Nothing else may appear before it under /Yu.

## Gotchas

- The `#import` requires `shdocvw.dll` present at compile time on the build machine (any Windows system DLL location) and emits generated headers into the intermediate dir — a common first failure when building this project on non-Windows-hostile toolchains.
- Duplicate `#include <boost/bind.hpp>` (lines 34 and 38) — harmless, verbatim.
- `WIN32_LEAN_AND_MEAN` means anything needing e.g. WinSock must include it explicitly elsewhere.
