# App/include/util/Http.h

## Purpose

Declares `RBX::Http`, the engine's central synchronous/asynchronous HTTP client wrapper, plus `RBX::http_status_error` and the `HttpCache::Policy` enum. The class abstracts over platform HTTP stacks (WinInet / WinHttp / Xbox Http / Apple impl selected via `API` enum and preprocessor branches) and layers Roblox-specific concerns on top: standard identity headers (game session, place id, access key, requester, player count), CDN-vs-Roblox-domain statistics, CSRF-token caching, cookie persistence per domain, and URL trust classification (`trustCheck`, `isRobloxSite`, `isMoneySite`).

## Declared API

- `namespace RBX::HttpCache { enum Policy { PolicyDefault, PolicyFinalRedirect }; }` — no caching by default; `PolicyFinalRedirect` caches under the post-302 URL.
- `class http_status_error : public std::runtime_error` — carries `int statusCode`; ctors `(statusCode)` and `(statusCode, message)`.
- `class Http`
  - Types: `enum API { Uninitialized=-1, WinInet=0, WinHttp=1, XboxHttp=2 }`; `enum CookieSharingPolicy` bitmask (`Undefined`, `MultipleProcessesRead`, `MultipleProcessesWrite`, `SingleProcessMultipleThreads`) with `operator|`/`operator|=`.
  - Global config (statics): `accessKey`, `gameSessionID`, `gameID`, `placeID`, `requester`, `rbxUserAgent`, `playerCount`, `useDefaultTimeouts`; header-name constants `kGameSessionHeaderKey`, `kGameIdHeaderKey`, `kPlaceIdHeaderKey`, `kRequesterHeaderKey`, `kPlayerCountHeaderKey`, `kAccessHeaderKey`, `kAssetTypeKey`, `kRBXAuthenticationNegotiation`, and content-type constants (`kContentTypeDefaultUnspecified/UrlEncoded/ApplicationJson/ApplicationXml/TextPlain/TextXml`) — defined in Utilities.cpp.
  - Static lifecycle: `static void init(API api, CookieSharingPolicy policy)`; `SetUseStatistics(bool)`; `SetUseCurl(bool)`; `setProxy(host, port=0)`.
  - Statistics: atomic counters `cdnSuccessCount/cdnFailureCount/alternateCdnSuccessCount/alternateCdnFailureCount/robloxSuccessCount/robloxFailureCount`, `double lastCdnFailureTimeSpan`, response-time `WindowAverage<double,double> robloxResponce/cdnResponce` with paired mutexes `getRobloxResponceLock()/getCdnResponceLock()`.
  - Instance state (public fields): `std::string url`; `bool recordStatistics`, `shouldRetry`, `doNotUseCachedResponse`; `HttpAux::AdditionalHeaders additionalHeaders`; ctors `Http()`, `Http(const char*[, API])`, `Http(const std::string&[, API])`.
  - Header helpers: `void setAuthDomain(std::string domain)` (sets `authDomainUrl` + `kRBXAuthenticationNegotiation` header); `void setExpectedAssetType(const std::string&)` (gated by DFFlag `UseAssetTypeHeader`).
  - Cookies: `static setCookiesForDomain(domain, cookies)` / `static getCookiesForDomain(domain, &cookies)`.
  - Timeouts/cache: `setResponseTimeout/setSendTimeout/setDataSendTimeout/setConnectionTimeout(int ms)`, `setCachePolicy(HttpCache::Policy)`.
  - Async API: `post(input, contentType, compress, handler(string*, exception*), externalRequest=false)` (string or `shared_ptr<std::istream>` body), `get(handler, allowExternal=false)`.
  - Sync API: `post(std::istream&, contentType, compress, string& response, externalRequest=false)`, `get(std::string& response, allowExternal=false)`.
  - URL classification statics: `isExternalRequest`, `trustCheck(url, allowExternal=false)`, `trustCheckBrowser`, `isScript`, `isRobloxSite`, `isStrictlyRobloxSite`, `isMoneySite` — all `const char* url` based.
  - Utility: `static std::string urlEncode(s)`; `static std::string urlDecode(fragment)` (only round-trips its own encoding); `applyAdditionalHeaders(AdditionalHeaders& out)`.
  - Errors/proxy: `static void ThrowIfFailure(bool success, const char* url, const char* msg)`; instance `ThrowIfFailure(bool, const char* msg)`; `_WIN32` only `ThrowLastError`, `onWinHttpRedirect`, `setCookiesForDomainWinInet`.
  - CSRF: `static std::string getLastCsrfToken()` / `setLastCsrfToken(newToken)` backed by `lastCsrfToken` + `lastCsrfTokenMutex`.
  - Private: per-instance timeouts, `cachePolicy`, `alternateUrl` (CDN-failure fallback GET target), platform dispatchers `httpGetPost(...)` plus `httpGetPostXbox/httpGetPostWinInet/httpGetPostWinHttp/httpGetPostImpl` per platform, `doHttpGetPostWithNativeFallbackForReporting(...)`, `init()`.

## Usage notes

- Construct with a URL, tune optional flags, then call sync `get`/`post` or the callback-flavored async variants; all requests funnel through the private `httpGetPost` dispatcher which picks WinInet/WinHttp/Xbox/native-per-platform.
- The static header strings are meant to be filled in once at startup (session/place/player info) so every subsequent request carries them.

## Gotchas

- `getLastCsrfToken`/`setLastCsrfToken` carry an explicit comment: not safe from static initializers because they touch static members with unspecified init order.
- `urlDecode` is only guaranteed for strings produced by `urlEncode`.
- Platform bodies diverge heavily via `#if defined(RBX_PLATFORM_DURANGO) / _WIN32 / __APPLE__` — non-Windows/non-Apple builds rely on the generic path; `_WIN32` adds WinInet-specific cookie plumbing.
- The typo'd names (`robloxResponceLock`, `cdnResponceLock`, `robloxResponce`, `cdnResponce`) are the public API spelling — do not "fix" call sites independently.
- `CookieSharingPolicy::operator|=` takes both operands by value and returns a value, so it does not mutate its left argument like a normal compound assignment.
