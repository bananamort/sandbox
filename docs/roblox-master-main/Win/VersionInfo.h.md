# VersionInfo.h

Source: `roblox-sandbox/Win/VersionInfo.h` (84 lines)

## Purpose

Declares `CVersionInfo`, PJ Naughter's classic Win32 version-resource wrapper (2000, public-domain style header notice), locally "refactored to use std::string instead of CString" per in-source note. Reads the VS_VERSIONINFO blob of a module/file and exposes fixed-file-info fields, string-table values (CompanyName, FileVersion...), and the translation table. Links `version.lib` via pragma.

## API

```cpp
class CVersionInfo {
public:
    struct TRANSLATION { WORD m_wLangID; WORD m_wCodePage; };

    CVersionInfo();  ~CVersionInfo();
    BOOL Load(HMODULE module);                       // module path → short path → Load(wstring)
    BOOL Load(const std::wstring& fileName);
    VS_FIXEDFILEINFO* GetFixedFileInfo();
    DWORD GetFileFlagsMask();  DWORD GetFileFlags();
    DWORD GetOS();  DWORD GetFileType();  DWORD GetFileSubType();
    FILETIME GetCreationTime();
    unsigned __int64 GetFileVersion();               // declared only — see Gotchas
    unsigned __int64 GetProductVersion();            // declared only — see Gotchas
    std::string GetValue(const std::string& sKeyName);
    std::string GetComments();          std::string GetCompanyName();
    std::string GetFileDescription();   std::string GetFileVersionAsString();
    std::string GetFileVersionAsDotString();
    std::string GetInternalName();      std::string GetLegalCopyright();
    std::string GetLegalTrademarks();   std::string GetOriginalFilename();
    std::string GetPrivateBuild();      std::string GetProductName();
    std::string GetProductVersionAsString();  std::string GetSpecialBuild();
    int GetNumberOfTranslations();
    TRANSLATION* GetTranslation(int nIndex);
    void SetTranslation(int nIndex);
protected:
    void Unload();
    // data: m_wLangID, m_wCharset(=code page), m_pVerData blob, m_pTranslations, m_nTranslations, m_pffi
};
```

## Usage

Consumers: `Win/LogManager.cpp` (`GetAppVersion()` feeds crash-dump metadata + log filenames), `WindowsClient/Application.cpp` (three separate uses around lines 512/1021/1315), and `RCCService/RCCServiceSoapServiceImpl.cpp` line 1253. The MMC.h hits in the grep are an unrelated COM interface name collision.

## Gotchas

- **Header declares `GetFileVersion()`/`GetProductVersion()` returning `unsigned __int64` but VersionInfo.cpp never defines them** — any TU that actually calls them fails at link time; all current consumers use the AsString variants.
- `GetProductName()` queries the key `"Productname"` (lowercase n) — version resources normally store `"ProductName"`; returns "" on typical files.
