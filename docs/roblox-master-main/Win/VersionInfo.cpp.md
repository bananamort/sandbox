# VersionInfo.cpp

Source: `roblox-sandbox/Win/VersionInfo.cpp` (260 lines)

## Purpose

Implements CVersionInfo: `GetFileVersionInfoSizeW/GetFileVersionInfoW` blob acquisition, `VerQueryValue` for the root fixed info and `\VarFileInfo\Translation`, string-table queries built as `\StringFileInfo\<langID><codePage>\<Key>` (wide query, converted to UTF-8 std::string on return), and the dot-separated FileVersion reformatter using boost::tokenizer.

## API

```cpp
CVersionInfo::CVersionInfo();                       // nulls pointers; charset default 1252
void CVersionInfo::Unload();                        // delete[] m_pVerData; reset state
BOOL CVersionInfo::Load(HMODULE module);            // GetModuleFileNameW(500) → GetShortPathNameW → Load(wstring)
BOOL CVersionInfo::Load(const std::wstring& fileName);  // blob load; on failure frees memory, returns FALSE
VS_FIXEDFILEINFO* GetFixedFileInfo();               // raw pointer into blob
DWORD GetFileFlagsMask/GetFileFlags/GetOS/GetFileType/GetFileSubType();
FILETIME GetCreationTime();                         // dwFileDateMS/LS
std::string GetValue(const std::string& sKey);      // format_string("\\StringFileInfo\\%04x%04x\\%s", ...)
std::string GetFileVersionAsDotString();            // tokenizer split " ,." → join with '.'
std::string GetCompanyName/FileDescription/FileVersionAsString/InternalName/LegalCopyright/
            OriginalFilename/Productname("Productname")/ProductVersionAsString/Comments/
            LegalTrademarks/PrivateBuild/SpecialBuild ();
int  GetNumberOfTranslations();
TRANSLATION* GetTranslation(int nIndex);
void SetTranslation(int nIndex);                    // switch active lang/codepage for subsequent GetValue
```

Helpers used: `RBX::{SysPathString, utf8_decode, utf8_encode}` from ClientShared/StringConv.h and `format_string` via CVTS2W/CVTW2S conversion macros (from project stdafx conventions).

## Usage

Called at process startup paths to stamp version strings onto crash metadata and logs — Win/LogManager.cpp `GetAppVersion()` (FASTLOG'd under FLog::CrashReporterInit), WindowsClient/Application.cpp ×3, RCCService/RCCServiceSoapServiceImpl.cpp. Typical sequence: `CVersionInfo vi; vi.Load(_AtlBaseModule.m_hInst); vi.GetFileVersionAsString();`

## Gotchas

- `Load(HMODULE)` truncates module path at 500 WCHARs and converts to SHORT (8.3) path first — long Unicode install paths can break version lookup.
- `GetProductName()` asks for `"Productname"` — see header doc; effectively always empty.
- `GetFileVersion()/GetProductVersion()` declared in the header have no implementation here (link error if called).
- `GetValue` returns an empty string silently when the key or translation is missing; no error signal.
- Blob lifetime: all returned `VS_FIXEDFILEINFO*`/`TRANSLATION*` point INTO `m_pVerData`; any non-const call that triggers Unload invalidates previously fetched pointers.
