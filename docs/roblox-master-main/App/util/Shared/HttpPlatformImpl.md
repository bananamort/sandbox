# Shared/HttpPlatformImpl.cpp

**Source**: `App/util/Shared/HttpPlatformImpl.cpp` (1,366 lines) — implements `RBX::HttpPlatformImpl` (declared in `App/include/util/HttpPlatformImpl.h`): the **libcurl HTTP backend** plus the on-disk HTTP response cache (`RBX::HttpPlatformImpl::Cache`).

## Purpose
This is the default egress implementation for all non-Xbox platforms (selected when `useCurlHttpImpl == true`, see Shared/Http.md). Each request builds a `CurlHandle` around a libcurl easy handle, applies TLS/redirect/proxy/cookie/timeout options, performs the transfer, enforces 2xx success (with special 202 handling), and optionally reads/writes a file-backed cache of CDN responses.

## API
From the header:
```cpp
namespace RBX { namespace HttpPlatformImpl {
void init(Http::CookieSharingPolicy cookieSharingPolicy);   // not thread-safe; curl_global_init + shared handle + threads
void setCookiesForDomain(const std::string& domain, const std::string& cookies);
void getCookiesForDomain(const std::string& domain, std::string& cookies); // note: domain currently ignored, returns ALL cookies
boost::filesystem::path getRobloxCookieJarPath();
void setProxy(const std::string& host, long port = 0);
void perform(HttpOptions& options, std::string& response);  // throws http_status_error unless 2xx (202 counts as failure)

struct HttpOptions {   // constructed by RBX::Http in Http.cpp
    const std::string& url; bool externalRequest; HttpCache::Policy cachePolicy;
    long connectTimeoutMillis; long performTimeoutMillis;
    std::istream* postData; bool compressedPostData;
    std::string const* hdrContentType; HttpAux::AdditionalHeaders const* addlHeaders;
    HttpOptions(url, externalRequest, cachePolicy, connectTimeoutMillis, performTimeoutMillis);
    void setPostData(std::istream*, bool compressed);
    void setHeaders(const std::string* contentType, const HttpAux::AdditionalHeaders*);
};

namespace Cache {
boost::filesystem::path cacheFilePath(const char* url);       // <cache>/http/<md5-of-url>
void cleanCache(const CacheCleanOptions& options);            // LRU-by-mtime unlink
struct CacheResult { static CacheResult open(const char* assetUrl, const char* cdnUrl);
                     static CacheResult update(const char* assetUrl, const char* cdnUrl,
                                               uint32_t responseCode, const Data& headers, const Data& body);
                     bool isValid() const; const Header& getCacheHeader() const;
                     const Data getResponseHeader() const; const Data getResponseBody() const;
                     const std::string& getInvalidReason() const; };
}}}
```

## How a request is built (CurlHandle)
- `curl_easy_init()` per request; options set: `CURLOPT_SSLVERSION = CURL_SSLVERSION_TLSv1`, `CURLOPT_SHARE` to a process-global `CURLSH` (shares COOKIE/DNS/SSL_SESSION under mutexes `curlshCookieMutex/curlshDNSMutex/curlshSSLMutex`), `CURLOPT_URL`, `CURLOPT_CONNECTTIMEOUT_MS`, `CURLOPT_TIMEOUT_MS`, proxy from `DFString::HttpCurlProxyHostAndPort` or module-statics `proxyHost/proxyPort` (set via `setProxy`), `CURLOPT_USERAGENT` = `Http::rbxUserAgent`, header capture callback, `CURLOPT_AUTOREFERER`, `CURLOPT_ACCEPT_ENCODING ""` (gzip/deflate), **`CURLOPT_SSL_VERIFYPEER = 0`** ("Less secure, but means we don't have to install certificates"), `CURLOPT_NOSIGNAL 1`.
- Redirects are followed only for `PolicyDefault` (`CURLOPT_FOLLOWLOCATION`, max `DFInt::HttpMaxRedirects`=10). For `PolicyFinalRedirect` the code manually walks 301/302 via `CURLINFO_REDIRECT_URL`, consulting/writing the disk cache keyed by the final redirect URL.
- Cookies: if policy has `CookieSharingMultipleProcessesRead`, loads cookie jar `<cache>/http/cookies.txt` (`CURLOPT_COOKIEFILE`); with Write, writes a temp jar and renames it over the real one in `~CurlHandle`. `CURLOPT_COOKIESESSION 1` drops session cookies from previous runs.
- POST: optional gzip compression (`Content-Encoding: gzip`) into `postData`; attaches `X-CSRF-TOKEN: <token>` from `Http::getLastCsrfToken()` for non-external posts; `CURLOPT_POSTFIELDS` + `CURLOPT_POSTFIELDSIZE_LARGE` (not chunked).
- CSRF rotation loop lives in `perform(HttpOptions&)`: after each attempt, `while (options.postData && 403 == statusCode && curlHandle->getCsrfTokenChanged())` re-performs with the new token captured from the response's `X-CSRF-TOKEN` header (`headerCallback` → `addResponseHeader` → `updateCsrfToken`, which also patches the in-flight curl_slist entry). Final rule: any status outside [200,299], **including 202**, throws `http_status_error(statusCode, reason)` (the queue layer retries 202).
- Zero-latency caching: under `DFFlag::HttpZeroLatencyCaching` and `PolicyFinalRedirect`, `getOldCachedData()` returns stale cached content immediately while `updateCachedData` refreshes the cache on a background 4-thread pool (`kNumberThreadPoolThreads = 4` here).

## Usage
- `Cache::CacheEntry` file layout (header struct in HttpPlatformImpl.h): magic `0x52425848` "RBXH" (network byte order), version 1, URL ≤1024 bytes, response code, sizes + XXH32 hashes of headers/body. `calculateHash` uses XXH32 seed 12903780 in 64 KB chunks; `getMutexName` uses XXH32 seed 123890 for Windows named-mutex keys.
- Only **200** responses are cached (`update` refuses others; `open` refuses stored non-200s left from older versions). Opening bumps mtime so LRU cleanup keeps hot entries.
- `cleanCache` triggers when file count ≥ `DFInt::HttpCacheCleanMinFilesRequired` (3000) keeping `HttpCacheCleanMaxFilesToKeep` (1500), or when free space GB ≤ `HttpCacheCleanIfGBLessThan` (5) and `DFFlag::HttpCacheCleanBasedOnMemory`.
- Background thread `"rbx_http_cache_stats_report"` reports hit/miss counters (`HTTPCacheHit/Miss/Total/Bytes-<platform><appName>`) every `DFInt::HttpCacheSendStatsEveryXSeconds` (60 s); `"rbx_http_cache_clean"` starts 10 s late (after ClientSettings load).
- Cookie override pre-init: `setCookiesForDomain` before `init()` stashes into `robloxCookieOverrideDomain/robloxCookieOverride` and replays them at init.

## Gotchas
- **SSL peer verification is disabled** (`CURLOPT_SSL_VERIFYPEER 0`) — MITM is possible on this path; relevant for any egress-proxy redesign.
- Proxy comes from two places: DFString `HttpCurlProxyHostAndPort` wins over `setProxy(host,port)` statics.
- `sanitizeUrl` only escapes spaces to `%20`; other invalid characters pass through untouched.
- `addResponseHeader` writes `buffer[size*nitems-2] = '\0'` unconditionally — assumes CRLF-terminated headers.
- Domain trimming for cookie sharing (`DFFlag::HttpCurlDomainTrimmingWithBaseURL`): propagates cookies only from `www.<baseURL>` / `m.<baseURL>` to the base domain; without the flag it strips everything before the first dot (non-studio), i.e. cookies land on the registrable-domain suffix.
- `getCookiesForDomain(domain, ...)` ignores the domain argument entirely and serializes the whole jar.
- On Android, `curl_global_init` is skipped (done in JNIMain.cpp); Xbox build replaces this whole namespace with stubs that `RBXASSERT(0)` (see XboxHttp2.cpp bottom).
- `_DEBUG/_NOOPT` builds append one CSV row per fetch to `<cache>/httpstats.csv` (asset URL, CDN URL, sizes, hit/miss).
