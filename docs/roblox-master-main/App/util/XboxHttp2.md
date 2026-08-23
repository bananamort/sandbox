# XboxHttp2.cpp

**Source**: `App/util/XboxHttp2.cpp` (458 lines) — compiled only under `RBX_PLATFORM_DURANGO` (Xbox One). Implements `Http::httpGetPostXbox(...)` using **IXMLHTTPRequest2** (`FreeThreadedXMLHTTP60`) and provides do-nothing stubs of the entire `RBX::HttpPlatformImpl` namespace (curl is never used on Xbox).

## Purpose
The native Xbox HTTP backend: asynchronous XHR2 request driven to completion by a Win32 event wait (120 s timeout `kWaitTimeoutMs`), with disk-cache integration and CSRF retry.

## API
```cpp
void Http::httpGetPostXbox(bool isPost, std::istream& data, const std::string& contentType,
                           bool compressData, const HttpAux::AdditionalHeaders& additionalHeaders,
                           bool externalRequest, HttpCache::Policy cachePolicy, std::string& response);
// stubs (RBXASSERT(0) bodies): HttpPlatformImpl::init, setCookiesForDomain, getCookiesForDomain,
//   getRobloxCookieJarPath, setProxy, perform
```

## Usage / request construction
- Compile-time knobs: `kForceHttpAssets = 0` (would downgrade https asset URLs to http), `kReportHttpTimings = 0`, `kReportHttpRedirects = 1`.
- Headers sent: `User-Agent: <Http::rbxUserAgent> ROBLOX Xbox App 1.0.0`; for internal requests `XboxAccessKey: b9309a51-7b54-458c-ad73-7b2c287497e2` (**hardcoded GUID access key**); all `additionalHeaders`; POST adds Content-Type and non-external `X-CSRF-TOKEN: <getLastCsrfToken()>`.
- `XHR_PROP_ONDATA_THRESHOLD = XHR_PROP_ONDATA_NEVER`; body streamed via custom `ISequentialStream` wrapper (`Stream`) over the std::istream.
- `Callback : IXMLHTTPRequest2Callback` records timings (start/redirect/headers/data/done), captures last redirect URL, and on 200/201 stores response; `OnRedirect` also probes `Cache::CacheResult::open(url, redirectUrl)` and short-circuits with cached bytes when valid.
- Completion path: success if status ∈ {200, 201} or cache served; GET + `PolicyFinalRedirect` + fresh fetch writes `Cache::update(url, redirectUrl, statusCode, headers, body)`.
- 403 on internal POST → read `X-CSRF-TOKEN` response header, `setLastCsrfToken`, recursive retry.
- `RBX_XBOX_SITETEST1` builds inject a `SnickerdoodleConstraint` cookie for `.sitetest1.robloxlabs.com/`.

## Gotchas
- The hardcoded `XboxAccessKey` GUID is an embedded credential in source.
- `request->Send(...)` failure in the POST branch calls `RBX::runtime_error(...)` constructor but **does not throw** (missing `throw`) — execution continues into the wait and reports a timeout instead.
- `s2ws` is a naive widening (no UTF-8 decode); non-ASCII URLs/headers get mangled.
- `Callback::wait()` returns false on both timeout and error-waits; caller aborts with generic "http TIMEOUT".
- Success requires exactly 200/201 — other 2xx codes throw `http_status_error`.
