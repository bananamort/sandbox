// =============================================================================
// ci_atl_loader_shim.h - CI-only forced include (wired in Directory.Build.targets
// alongside the ATLMFC injection; local builds without ATLMFC_ROOT never see it).
//
// WHY: windows-latest ships VS "18" whose ONLY installed ATLMFC component lives
// under MSVC 14.51.36231 while our v143 projects compile with CL 14.44
// (toolset inventory logged by the "Locate ATLMFC" step, run 32746195933).
// That ATL generation calls the Win8+ loader API SetDefaultDllDirectories
// unconditionally (atlcore.h:663), and its declaration can be invisible to us
// twice over:
//   (a) the modern platform SDK gates it behind _WIN32_WINNT >= 0x0602 while
//       the tree pins XP/Win7-era surfaces (runs 32704355280, 32743525757,
//       32746195933: 52x C2065 + 26x C2039, every error this one symbol);
//   (b) the vendored Library/SDK headers (7.1-era; they shadow the platform
//       SDK because ..\Library\SDK\Include precedes INCLUDE on every /I path)
//       predate the API entirely - no _WIN32_WINNT value can produce it.
// Declared here verbatim as in Windows 8.0 SDK um/libloaderapi.h so the
// injected ATL compiles unchanged. If a TU does see the real declaration
// later, the identical declaration merges silently; nothing else changes.
// Link note: vendored Library/SDK/Lib/Kernel32.Lib predates the export, but
// the linker resolves per-symbol in library order and falls through to the
// platform SDK's kernel32.lib, whose entry maps to kernel32.dll.
// =============================================================================
#pragma once

#ifdef _WIN32
#ifndef RBX_CI_ATL_LOADER_SHIM_H
#define RBX_CI_ATL_LOADER_SHIM_H

#ifndef LOAD_LIBRARY_SEARCH_APPLICATION_DIR
#define LOAD_LIBRARY_SEARCH_APPLICATION_DIR 0x00000200
#endif
#ifndef LOAD_LIBRARY_SEARCH_USER_DIRS
#define LOAD_LIBRARY_SEARCH_USER_DIRS 0x00000400
#endif
#ifndef LOAD_LIBRARY_SEARCH_SYSTEM32
#define LOAD_LIBRARY_SEARCH_SYSTEM32 0x00000800
#endif
#ifndef LOAD_LIBRARY_SEARCH_DEFAULT_DIRS
#define LOAD_LIBRARY_SEARCH_DEFAULT_DIRS 0x00001000
#endif

__declspec(dllimport) int __stdcall SetDefaultDllDirectories(unsigned long DirectoryFlags);

#endif // RBX_CI_ATL_LOADER_SHIM_H
#endif // _WIN32
