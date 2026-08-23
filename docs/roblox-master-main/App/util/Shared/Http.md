# Shared/Http.cpp

**Source**: `App/util/Shared/Http.cpp` (1,447 lines) — implementation of `RBX::Http` (declared in `App/include/util/Http.h`).

## Purpose
The central HTTP client of the engine. Every GET/POST the game makes to web services funnels through `RBX::Http::httpGetPost()`, which dispatches to one of four platform backends: **libcurl** (`HttpPlatformImpl`, default on all platforms except Xbox), **WinInet**, **WinHttp** (Windows native), **Cocoa NSURLConnection** (Apple native), or **IXMLHTTPRequest2** (Xbox/Durango). It also owns URL trust classification (`trustCheck`, `isRobloxSite`, `isMoneySite`, ...), global identity headers, CDN alternate-URL fallback retry, CSRF token caching, and HTTP success/failure statistics reporting.

## Backend selection / routing (the egress seam)
- `typedef enum { Uninitialized=-1, WinInet=0, WinHttp=1, XboxHttp=2 } API;` — per-instance backend; `static API defaultApi` is initialized to `Http::WinHttp` on `_WIN32`, `Uninitialized` elsewhere.
- Anonymous-namespace static `bool useCurlHttpImpl` — **defaults to `true` everywhere except `RBX_PLATFORM_DURANGO`** (where it is `false`). So on Windows/Mac/Android/iOS the curl path in `HttpPlatformImpl::perform()` is the *default* egress path; WinInet/WinHttp run only when `SetUseCurl(false)` is called or via `forceNativeHttp`.
- `void Http::init(API api, CookieSharingPolicy cookieSharingPolicy)` — creates the 16-thread request `ThreadPool` (`kNumberThreadPoolThreads = 16`), stores the cookie policy and calls `Http::SetUseCurl(useCurlHttpImpl)`, which lazily calls `HttpPlatformImpl::init()` exactly once.
- `httpGetPost(bool isPost, std::istream& dataStream, const std::string& contentType, bool compressData, const HttpAux::AdditionalHeaders& additionalHeaders, bool externalRequest, std::string& response, bool forceNativeHttp = false)` dispatch order:
  1. `__APPLE__`: if `!useCurlHttpImpl || forceNativeHttp` → `httpGetPostImpl(...)` → `Cocoa::httpGetPostCocoa(...)`.
  2. Always runs `ThrowIfFailure(trustCheck(url.c_str(), externalRequest), "Trust check failed")` before any network I/O.
  3. External requests are size-limited: POST body ≥ `DFInt::ExternalHttpRequestSizeLimitKB` throws.
  4. `RBX_PLATFORM_DURANGO`: native → `httpGetPostXbox(...)`.
  5. `_WIN32`: native → `switch (instanceApi) { case WinInet: httpGetPostWinInet(...); case WinHttp: httpGetPostWinHttp(...); }`.
  6. Otherwise (and as default when curl is enabled): builds `HttpPlatformImpl::HttpOptions httpOpts(url, externalRequest, cachePolicy, connectTimeoutMillis, responseTimeoutMillis)`, optional `setPostData(&dataStream, compressData)`, `setHeaders(&contentType, &headers)`, then `HttpPlatformImpl::perform(httpOpts, response)`.

## Request construction (header injection)
For **non-external** requests, headers not already present are added from statics:
- `kGameSessionHeaderKey` ← `Http::gameSessionID`; `kGameIdHeaderKey` ← `Http::gameID`; `kPlaceIdHeaderKey` ← `Http::placeID`; `kRequesterHeaderKey` ← `Http::requester`; `kPlayerCountHeaderKey` ← formatted `Http::playerCount`.
- Only on the curl path: `kAccessHeaderKey` ← `"UserRequest"` for external requests, else `Http::accessKey` when non-empty.
- Header key strings themselves are defined in `Utilities.cpp` (e.g. `kGameSessionHeaderKey`); `rbxUserAgent` defaults per-platform to `"Roblox/Darwin"`, `"Roblox/XboxOne"`, or `"Roblox/WinInet"`.
- `void setAuthDomain(std::string domain)` sets `authDomainUrl` plus header `kRBXAuthenticationNegotiation`; `setExpectedAssetType(const std::string&)` adds `kAssetTypeKey` only when `DFFlag::UseAssetTypeHeader` is set.

## Public API (selected real signatures)
```cpp
class http_status_error : public std::runtime_error { public: int statusCode;
    http_status_error(int statusCode);
    http_status_error(int statusCode, const std::string& message); };

// sync
void post(std::istream& input, const std::string& contentType, bool compress, std::string& response, bool externalRequest = false);
void get(std::string& response, bool allowExternal = false);
// async (run on internal 16-thread ThreadPool)
void post(const std::string& input, const std::string& contentType, bool compress,
          boost::function<void(std::string*, std::exception*)> handler, bool externalRequest = false);
void post(boost::shared_ptr<std::istream> input, const std::string& contentType, bool compress,
          boost::function<void(std::string*, std::exception*)> handler, bool externalRequest = false);
void get(boost::function<void(std::string*, std::exception*)> handler, bool allowExternal = false);

// classification
static bool isExternalRequest(const char* url);      // true if http(s) host NOT roblox.com/robloxlabs.com subdomain
static bool trustCheck(const char* url, bool allowExternal = false);
static bool trustCheckBrowser(const char* url);      // trustCheck(url) || isMoneySite(url)
static bool isScript(const char* url);               // "javascript:" / "jscript:" prefix
static bool isRobloxSite(const char* url);           // roblox.com|robloxlabs.com + whitelisted facebook/youtube/google auth paths
static bool isStrictlyRobloxSite(const char* url);   // roblox domains only
static bool isMoneySite(const char* url);            // paypal.com | rixty.com subdomains
static std::string urlEncode(const std::string& s);
static std::string urlDecode(const std::string& fragment);

// config / cookies / csrf
static void init(API api, CookieSharingPolicy cookieSharingPolicy);
static void SetUseStatistics(bool value);            // spawns "rbx_http_stats_report" thread
static void SetUseCurl(bool value);                  // toggles curl vs native; lazily inits HttpPlatformImpl
static void setCookiesForDomain(const std::string& domain, const std::string& cookies);
static void getCookiesForDomain(const std::string& domain, std::string& cookies);
static void setProxy(const std::string& host, long port = 0); // forwards to HttpPlatformImpl::setProxy
static std::string getLastCsrfToken();
static void setLastCsrfToken(const std::string& newToken);
void applyAdditionalHeaders(RBX::HttpAux::AdditionalHeaders& outHeaders);
```
Timeout setters: `setResponseTimeout/setSendTimeout/setDataSendTimeout/setConnectionTimeout(int)` (millis, defaults from DFInts `HttpResponseDefaultTimeoutMillis` etc., all 60000). Cache policy: `void setCachePolicy(HttpCache::Policy policy)` with `enum Policy { PolicyDefault, PolicyFinalRedirect }`.

## Usage
- Statistics counters: atomics `cdnSuccessCount/cdnFailureCount/alternateCdnSuccessCount/alternateCdnFailureCount/robloxSuccessCount/robloxFailureCount`, `double lastCdnFailureTimeSpan`, `WindowAverage<double,double> robloxResponce/cdnResponce` guarded by lazily-created `robloxResponceLock`/`cdnResponceLock` (allocated by file-static `Http::MutexGuard lockGuard`).
- Anonymous-namespace singleton `HTTPStatistics` aggregates success/failure counts and delays split into DataStore/MarketPlace/Other categories (by matching `DataStore::urlApiPath()` / `MarketplaceService::urlApiPath()` against the URL path), reports every `DFInt::HttpSendStatsEveryXSeconds` (60 s) via `Analytics::EphemeralCounter`, samples failures into Google Analytics (`RobloxGoogleAnalytics::trackEvent(GA_CATEGORY_GAME,"HTTPFailure",...)`) at `DFInt::HttpGAFailureReportPercent`, RBX events at `DFInt::HttpRBXEventFailureReportHundredthsPercent`, and Influx points (`sendInfluxEvent`, throttled extra for `/moderation/filtertext`) at `DFInt::HttpInfluxHundredthsPercentage` to `DFString::HttpInfluxURL`.
- Apple glue: extern "C" `int rbx_trustCheckBrowser(const char*)` exported here; `Cocoa::httpGetPostCocoa` declared extern.

## Gotchas
- **`trustCheck` is a no-op**: first lines are `static const bool kSkipTrustCheck = true; if (kSkipTrustCheck) return true;`. The entire roblox/facebook/youtube/google whitelist below is dead code unless that constant is flipped. Callers must not assume trust checking happens here.
- **GET auto-retry**: `get(std::string&, bool)` catches any `RBX::base_exception` once, clears the response, and retries — using `alternateUrl` if one was captured, otherwise re-requesting the same URL. `shouldRetry` is per-instance and reset to `true` only in `init()`; a second failure propagates.
- **CDN alternate URL capture**: `onWinHttpRedirect(unsigned long dwInternetStatus, std::string redirectUrl)` (Windows-only) sniffs redirects containing `bg.roblox` (bitgravity) or `-cf.roblox` (cloudfront) and rewrites them into an S3-style `alternateUrl` used on retry.
- **Native fallback for stats URLs only**: `doHttpGetPostWithNativeFallbackForReporting` retries with `forceNativeHttp=true` when the failing URL starts with the Google Analytics base URL, counters increment URLs (`GetCountersMultiIncrementUrl`/`GetCountersUrl`), `%sgame/report-stats`, or the Influx base URL; suppressed entirely on Android.
- `isExternalRequest`'s WinInet-era branch uses substring `find("roblox.com")` (not suffix match), so `notroblox.com.evil.test` would classify as non-external there — but only when `useCurlHttpImpl == false` on Windows.
- The legacy HTParse path of `isRobloxSite` contains truthiness bugs like `("login.facebook.com" == host && "/login.php")` (missing path comparison) — the new `RBX::Url` path under `DFFlag::UseNewUrlClass` fixes this; behavior differs between flag states.
- Async handlers receive borrowed pointers (`std::string*`, `std::exception*`) valid only inside the callback; exceptions thrown in callbacks are caught by `StandardOut::print_exception` wrappers.
- `HTTPStatistics::reportingThreadHandler` loops forever — thread never joins; started by `SetUseStatistics(true)` only.
