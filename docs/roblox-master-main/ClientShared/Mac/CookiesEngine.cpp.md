# CookiesEngine.cpp (Mac variant)

Source: `roblox-sandbox/ClientShared/Mac/CookiesEngine.cpp` (244 lines)

## Purpose

macOS implementation of `CookiesEngine`: same `key=value&key=value&` file format as Windows, but the cookie path comes from the `CPath` key of the `com.roblox.RobloxPlayer` plist via CoreFoundation preferences. Identical parse/flush logic to the Win variant minus any locking.

## API

```cpp
bool   CookiesEngine::reportValue(CookiesEngine&, std::string key, std::string value); // 11x retry w/ usleep(50ms)
std::wstring CookiesEngine::getCookiesFilePath();      // CFPreferencesCopyAppValue("CPath", bundleId); mkdir -p parent if missing
void   CookiesEngine::setCookiesFilePath(std::wstring&); // EMPTY: handled by bootstrapper (controller.m::ModifyClientInfoList)
int/GetValue/DeleteValue — same semantics as Win variant, no mutex
```

## Usage

Selected by Mac builds via `Base/Base.xcodeproj` (which wires `../ClientShared/Mac/CookiesEngine.cpp`); ClientShared/CMakeLists.txt merely lists it alongside the Win/Mobile variants without building any of them. Includes `<CoreFoundation/CoreFoundation.h>` directly.

## Gotchas

- `setCookiesFilePath` is a documented no-op — writing app preferences after launch is too late; the bootstrapper modifies the Info.plist instead.
- getCookiesFilePath shells out (`system("mkdir -p ...")`) when the directory is missing — a command-injection-shaped pattern if the path ever contained shell metacharacters (path originates from our own plist).
- NO cross-process mutex: concurrent writers from bootstrapper + player can interleave FlushContent output, unlike Win.
- Uses `convert_w2s` on a wide filename for fopen (ANSI codepage) — non-ASCII paths may misbehave.
