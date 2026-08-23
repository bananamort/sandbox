# AppSettings.xml

Source: `roblox-sandbox/RCCService/AppSettings.xml` (11 lines)

## Purpose

Deployed-alongside-the-exe runtime settings file read at `CWebService` construction by `LoadAppSettings()` (RCCServiceSoapServiceImpl.cpp:1462). Only `<BaseUrl>` is consumed by this folder's code; the remaining keys are read by engine subsystems (ContentProvider, crash reporter, asset-upload services) that share the file.

## API (document contents)

```xml
<Settings>
  <BaseUrl>http://www.gametest1.robloxlabs.com</BaseUrl>
  <ContentFolder>..\..\..\content</ContentFolder>
  <SilentCrashReport>1</SilentCrashReport>
  <cBQ4U>1</cBQ4U>
  <xqsd5>../Lua/</xqsd5>
  <IsScriptAssetUploadEnabled>1</IsScriptAssetUploadEnabled>
  <IsAnimationAssetUploadEnabled>1</IsAnimationAssetUploadEnabled>
  <IsImageModelAssetUploadEnabled>1</IsImageModelAssetUploadEnabled>
</Settings>
```

- `BaseUrl`: web-tier endpoint; feeds `SetBaseURL`, which every grid/security/settings URL is derived from (`GetGridUrl`, `GetSecurityKeyUrl2`, …). Points at the internal test farm `gametest1.robloxlabs.com`.
- `ContentFolder`: relative content root.
- `SilentCrashReport`: matches `RobloxCrashReporter::silent = true` hardcoding in the service bootstrap.
- `cBQ4U`, `xqsd5`: obfuscated-name keys (UNKNOWN consumer; `xqsd5` suggests a Lua path override).
- `Is*AssetUploadEnabled`: toggles for script/animation/imagemodel upload paths in the engine.

## Usage

Lives next to RCCService.exe; loaded from the exe directory via `RBX::FileSystem::getUserDirectory(false, DirExe, NULL)` + `TextXmlParser`.

## Gotchas

- **Missing BaseUrl ⇒ hard crash later**: `fetchAllowedSecurityVersions()` calls `RBXCRASH()` when BaseURL was never set ("y u no set BaseURL??").
- The checked-in value targets Roblox's *internal* test environment — production deployments overwrite this file.
- Unknown keys are ignored silently by the parser used here (`findFirstChildByTag`).
