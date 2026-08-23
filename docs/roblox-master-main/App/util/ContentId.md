# ContentId.cpp

**Source**: `App/util/ContentId.cpp` (385 lines) — implements `RBX::ContentId` (declared in `App/include/util/ContentId.h`), the engine's content-URL value type (`rbxasset://`, `rbxassetid://`, http(s) asset URLs, `rbxgameasset://`).

## Purpose
Wraps a content identifier string and provides scheme classification, legacy-content remapping, and **URL reconstruction against a base URL** — including the hardcoded production hosts. This is where content URLs get rewritten to concrete hosts before any HTTP request happens (upstream of RBX::Http).

## API
Header (inline parts):
```cpp
explicit ContentId(const char* id);            // CorrectBackslash: '\\' -> '/'
explicit ContentId(const std::string& id);
static ContentId fromUrl(const std::string& url);
static ContentId fromAssets(const char* filePath);          // "rbxasset://" + filePath
static ContentId fromGameAssetName(const std::string& n);   // "rbxgameasset://" + n
bool isNull() const;                          // empty string
bool isAsset() const;                         // prefix "rbxasset://"
bool isAssetId() const;                       // prefix "rbxassetid://"
bool isHttp() const;                          // prefix "http"  (matches http/https/anything-http*)
bool isFile() const;                          // prefix "file://"
bool isRbxHttp() const;                       // prefix "rbxhttp://"
bool isAppContent() const;                    // prefix "rbxapp://"
bool isNamedAsset() const;                    // prefix "rbxgameasset://"
bool isConvertedNamedAsset() const;           // contains "assetName="
```
Implemented here:
```cpp
void convertToLegacyContent(const std::string& baseUrl);      // LegacyContentTable remap for rbxasset:// ids? no — for isAsset()
void convertAssetId(const std::string& baseUrl, int universeId);
bool reconstructUrl(const std::string& baseUrl, const char* const paths[], const int pathCount);
bool reconstructAssetUrl(const std::string& baseUrl);         // uses kValidAssetPaths below
std::string getAssetId() const;        // digits after "rbxassetid://" or the id= query param
std::string getAssetName() const;
std::string getUnConvertedAssetName() const;                 // urlDecode of assetName= param
std::size_t hash_value(const ContentId&);                    // boost hash of full string
bool operator< / == / !=(const ContentId&, const ContentId&);
```

## Hardcoded hosts / URL rewriting (precision target)
- `kValidAssetPaths[]` — paths eligible for reconstruction: `asset`, `asset/`, `asset/bodycolors.ashx`, `thumbs/asset.ashx`, `thumbs/avatar.ashx`, `thumbs/script.png`, `thumbs/staticimage`, `game/tools/thumbnailasset.ashx`, `game/edit.ashx`, `game/gameserver.ashx`, `game/join.ashx`, `game/visit.ashx`.
- New-URL-class path (`DFFlag::UseNewUrlClass`): only http(s) URLs are rewritten; when the path matches one of `paths[]`:
  - With `DFFlag::UrlReconstructToAssetGame`: base URL on `robloxlabs.com` + source not on robloxlabs → host forced to **`assetgame.roblox.com`**; otherwise scheme/host come from baseUrl with leading `www.` → `assetgame.`; `UrlReconstructToAssetGameSecure` forces scheme **https**.
  - Without that flag: non-labs source → rewritten to literal **`http://www.roblox.com/<path>`**; labs source → `<baseUrl>/<path>`.
- Legacy HTParse path: same outcomes, string-spliced (`"http://www.roblox.com/" + path`, `"https://assetgame." + ...`). Non-http schemes return true untouched.
- `convertAssetId(baseUrl, universeId)`: `rbxassetid://123` → `<baseUrl>/asset/?id=123`; `rbxhttp://x/y` → `<baseUrl>/y`; `rbxgameasset://Name` → `<baseUrl>/asset/?universeId=<universeId>&assetName=<urlEncoded>&skipSigningScripts=1`.
- Spaces are stripped from the whole id before parsing (handles `"…/?id= 1818"`).

## Usage
- `convertToLegacyContent` consults the process-wide `LegacyContentTable` (boost call_once singleton, see LegacyContentTable.cpp) to map old content names to numeric asset ids, then builds `<baseUrl>/asset/?id=<n>`.
- Consumers pass their own path whitelist via `reconstructUrl(baseUrl, paths, count)`; `reconstructAssetUrl` is the asset-path flavor used by ContentProvider.

## Gotchas
- `isHttp()` matches the 4-char prefix "http", so `httpfoo://` counts as http; `getAssetId()` lowercases a copy and searches `"id="`, so it also matches `mid=`/`uid=` substrings anywhere in the URL.
- `isAsset()` checks only 11 chars ("rbxasset://") so `rbxassetid://` does NOT hit it first in code that tests `isAsset()` before `isAssetId()` — order matters at call sites.
- Reconstruction mutates the id in place and returns false without change if the path doesn't match; callers must treat false as "leave as-is".
- The three DFFlags `UrlReconstructToAssetGame(_Secure)` and `UrlReconstructRejectInvalidSchemes` all default false, so default behavior pins rewritten URLs to plaintext **http://www.roblox.com** unless flags are flipped remotely.
