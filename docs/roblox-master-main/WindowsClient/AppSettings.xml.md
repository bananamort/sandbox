# WindowsClient/AppSettings.xml

## Purpose

The on-disk bootstrap settings file read by `Application::LoadAppSettings` (Application.cpp) at step 4 of `_tWinMain`, before any window exists. It is copied next to the built exe by a CustomBuild step in WindowsClient.vcxproj. It is the sole source of `BaseUrl` in this client (per ReadMe.txt priority list).

## API

XML document, root `<Settings>`, four recognized child elements (matched via `Name::declare` tags in LoadAppSettings):

- `<BaseUrl>` = `http://www.gametest2.robloxlabs.com/` — every HTTP join/auth/stats URL is derived from it (`GetBaseURL()`); LoadAppSettings appends `/` if missing and calls `SetBaseURL(valBaseUrl)`.
- `<ContentFolder>` = `..\..\..\content` — relative path resolved against the exe directory (current directory is set to the exe dir first); passed to `ContentProvider::setAssetFolder`.
- `<SilentCrashReport>` = `0` — default for silent crash reporting; registry `HKCU\Software\ROBLOX Corporation\Roblox\SilentCrashReport` overrides only when XML does not force 0.
- `<HideChatWindow>` = `0` — becomes `Application::hideChat`; inverted into Document::Initialize's `useChat` parameter.

## Usage

For sandbox use, editing this file (in a deployed copy — never in the read-only source tree) redirects the whole client to a private web service: PlaceLauncher.ashx, login/v1, dmp upload, UploadMedia endpoints, MachineIdUploader all build URLs off BaseUrl. ContentFolder can also be overridden by the `--content` command-line switch (higher priority per ReadMe.txt).

## Gotchas

- The file must sit in the same directory as the exe; LoadAppSettings does `SetCurrentDirectoryW(exeDir)` before parsing, which also changes the meaning of the relative ContentFolder.
- Only these four tags are consumed here; unknown tags are ignored silently.
- `SilentCrashReport=0` short-circuits the registry read (comment: "Don't bother reading from registry if value to set to 0 in AppSettings").
- Missing file or parse error → exception caught by LoadAppSettings → handleError → Initialize never runs; process exits FALSE.
