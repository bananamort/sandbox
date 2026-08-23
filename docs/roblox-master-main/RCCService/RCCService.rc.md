# RCCService.rc

Source: `roblox-sandbox/RCCService/RCCService.rc` (111 lines)

## Purpose

Resource script for RCCService.exe: embeds the **version information block** (consumed at runtime by `CWebService` via `CVersionInfo::Load(_AtlBaseModule.m_hInst)` → `DebugSettings::robloxVersion`, reported through GetVersion/GetStatus SOAP ops), the application icon, and the compiled event-log message table.

## API (resources)

- `VS_VERSION_INFO VERSIONINFO`: `FILEVERSION 0,75,0,691`, `PRODUCTVERSION 0,75,0,0`; strings — CompanyName "ROBLOX Corporation", FileDescription "ROBLOX Compute Cloud Service", InternalName/OriginalFilename "RCCService.exe", ProductName "RCC Service", copyright 2013; language 0x409 / code page 1252.
- `IDI_ICON1 ICON "icon1.ico"` (line 95) — matches `resource.h`.
- `1 11 MSG00001.bin` (lines 43, 107): resource type 11 (`RT_MESSAGETABLE`) id 1 from the `mc.exe`-compiled binary of `Message.mc`. Declared twice (TEXTINCLUDE 3 template + final section), standard VS pattern.
- English (U.S.) guarded by `AFX_TARG_ENU`; code page 1252.

## Usage

Compiled by `rc.exe` into the exe's resource segment. Event-log reads rely on `EventMessageFile` pointing at this exe (see `EventLogInstall`) so `ReportEvent(..., 0x20000001L, ...)` resolves `%1` from the embedded message table.

## Gotchas

- Version numbers here are frozen build-time constants of this drop; `GetVersion` returns whatever `CVersionInfo` finds (i.e., these values), not a live service version.
- TEXTINCLUDE 2 references `afxres.h` while line 10 includes `winres.h` — the usual MFC-less wizard inconsistency; harmless with ATL-only builds.
- The copyright string contains a non-UTF8 © byte (mojibake in some viewers).
