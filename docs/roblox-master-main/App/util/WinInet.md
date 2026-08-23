# WinInet.cpp

**Source**: `App/util/WinInet.cpp` (572 lines) — Windows-only (`#ifdef _WIN32`, compiled out elsewhere). Implements `Http::httpGetPostWinInet(...)` and `Http::setCookiesForDomainWinInet(...)`, the legacy WinINet backend of `RBX::Http`.

## Purpose
Performs HTTP GET/POST through the WinINet API (`InternetOpen/InternetConnect/HttpOpenRequest/HttpSendRequest[Ex]`) when `RBX::Http` runs with `instanceApi == Http::WinInet` and curl is disabled. Handles gzip request compression, gzip response decoding, CSRF-token retry on 403, CDN redirect capture for the alternate-URL fallback, external-request limits, and an SSL certificate subject check.

## API
```cpp
void Http::httpGetPostWinInet(bool isPost, std::istream& data, const std::string& contentType,
                              bool compressData, const HttpAux::AdditionalHeaders& additionalHeaders,
                              bool externalRequest, std::string& response);
void Http::setCookiesForDomainWinInet(const std::string& domain, const std::string& cookies);
```
(Both are private members of `RBX::Http`; this file is linked only on Windows.)

## Usage / request construction
1. URL = `alternateUrl.empty() ? url : alternateUrl`; trust check via `Http::trustCheck`.
2. ATL `CUrl::CrackUrl` splits host/port/path; session opened with user agent **"Roblox/WinInet"** and `PRE_CONFIG_INTERNET_ACCESS` (honors IE proxy config).
3. Flags: `INTERNET_FLAG_SECURE` for https else `INTERNET_FLAG_KEEP_CONNECTION | INTERNET_FLAG_NEED_FILE`; `INTERNET_FLAG_NO_COOKIES` for external requests; `INTERNET_FLAG_RELOAD` if `doNotUseCachedResponse`.
4. Headers: all `additionalHeaders` as `Key: value\r\n`; POST adds `Content-Type` and (non-external) `X-CSRF-TOKEN: <getLastCsrfToken()>`; always adds `Accept-Encoding: gzip`.
5. Timeouts via `InternetSetOption` (send/connect/data-send/receive) only when `useDefaultTimeouts == false`; external requests override receive timeout with `DFInt::ExternalHttpResponseTimeoutMillis`.
6. GET: installs status callback (`INTERNET_STATUS_REDIRECT` → `Http::onWinHttpRedirect`, capturing bitgravity/cloudfront alternate URLs), then blocking `HttpSendRequest`.
7. POST: optional gzip body (`Content-Encoding: gzip`) buffered into a string; uploads >10 000 bytes also send debug headers `Roblox-Content-Size`, `Roblox-Content-First`, `Roblox-Content-Last`, `Roblox-Content-Hash` (MD5); sent via `HttpSendRequestEx` + `InternetWriteFile` + `HttpEndRequest`.
8. Response: skips body on 204; wraps `WiniInetRequest_source` in boost::iostreams and gunzips when `HTTP_QUERY_CONTENT_ENCODING == "gzip"`; external requests reject non-identity `CONTENT_TRANSFER_ENCODING` and enforce `DFInt::ExternalHttpResponseSizeLimitKB`.
9. Status handling: 201 returns immediately ("Youtube video uploaded"); non-2xx triggers the CSRF dance — on 403 with csrf headers in play, queries `X-CSRF-TOKEN` from the response, and if different from the one sent, `setLastCsrfToken(newToken)` and **recursive retry**; otherwise throws `http_status_error(statusCode[, statusText])`.
10. HTTPS certificate check: reads `INTERNET_OPTION_SECURITY_CERTIFICATE_STRUCT` and walks the subject info lines looking for `.roblox.com` / `.robloxlabs.com`; failure throws terse runtime errors `"mc"`, `"mi"`, or `"ud"` (obfuscated strings built as `std::string su = "u"; su += "d";`). External requests skip the loop.

## Gotchas
- The whole file is inert unless `_WIN32` and the caller selected the WinInet backend (`Http::SetUseCurl(false)` + `API WinInet`); default Windows routing is curl.
- `WiniInetRequest_source::read` busy-waits `Sleep(100)` on `ERROR_IO_PENDING` from `InternetQueryDataAvailable` — synchronous stall, not async completion.
- Certificate check frees cert fields with `LocalFree` but ignores failures of `lpszProtocolName` etc. ordering; the "mc"/"ud" error strings are intentionally cryptic anti-tamper artifacts — do not "fix" them without checking callers.
- Cookie setting goes through `InternetSetCookie` per `key=value` pair split on `;`/`=`, prefixed `http://` if missing scheme.
- `_NOOPT` builds inject magic admin cookies (`ThisCookieGetsYouInToSt3`, `HTTPAccessByAdminCookie`) — test-only backdoor code guarded by build type.
