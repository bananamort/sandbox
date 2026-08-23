# WinHttp.cpp

**Source**: `App/util/WinHttp.cpp` (338 lines) — Windows-only (`#ifdef _WIN32`). Implements `Http::httpGetPostWinHttp(...)`, the WinHTTP backend of `RBX::Http` (the default `Http::defaultApi` value on Windows, though the curl path normally preempts it).

## Purpose
Same contract as the WinInet backend but through `WinHttpOpen/WinHttpConnect/WinHttpOpenRequest/WinHttpSendRequest/WinHttpReceiveResponse`. Adds the accesskey header scheme and CDN redirect capture.

## API
```cpp
void Http::httpGetPostWinHttp(bool isPost, std::istream& data, const std::string& contentType,
                              bool compressData, const HttpAux::AdditionalHeaders& additionalHeaders,
                              bool externalRequest, std::string& response);
```

## Usage / request construction
1. URL = `alternateUrl.empty() ? url : alternateUrl`; `Http::trustCheck`; ATL `CUrl::CrackUrl`.
2. Session user agent **L"Roblox/WinHttp"**, `WINHTTP_ACCESS_TYPE_DEFAULT_PROXY`.
3. **Cookies disabled**: `WinHttpSetOption(hRequest, WINHTTP_OPTION_DISABLE_FEATURE, WINHTTP_DISABLE_COOKIES)` — unlike WinInet.
4. Headers: additional headers verbatim; POST adds Content-Type + non-external `X-CSRF-TOKEN: <getLastCsrfToken()>`. Access key: external requests send `accesskey: UserRequest`, otherwise `accesskey: <Http::accessKey>` when set (note: on this backend the header name is literally lowercase "accesskey"; curl uses `kAccessHeaderKey`). Always appends `Accept-Encoding: gzip\r\n` (wide string).
5. GET registers `redirectCallback` with `WINHTTP_CALLBACK_FLAG_REDIRECT`; context is the raw `this` Http pointer (`(DWORD_PTR) this`) → `Http::onWinHttpRedirect(status, url)` captures bitgravity/cloudfront alternate URLs.
6. POST: optional gzip body; >10 000-byte uploads add debug headers `Roblox-Content-Size` and `Roblox-Content-Hash` (MD5) — note no First/Last headers here unlike WinInet; single `WinHttpSendRequest` with body buffer.
7. Response: 204 skips body; gunzip if `WINHTTP_QUERY_CONTENT_ENCODING == "gzip"` via boost iostreams source `WinHttpRequest_source`; external requests enforce identity transfer encoding and `DFInt::ExternalHttpResponseSizeLimitKB`.
8. Non-2xx → 403 CSRF retry (query `X-CSRF-TOKEN` via `WINHTTP_QUERY_CUSTOM`, update global token, recursive call) else throw `http_status_error`.

## Gotchas
- No timeout options are set here except for external requests (`ExternalHttpResponseTimeoutMillis`); the four Http timeout setters are ignored by this backend.
- `WinHttpRequest_source::read` reports failures as a generic `"InternetReadFile failed"` runtime error even though it's WinHTTP underneath — misleading log text.
- The redirect callback casts the wide-string status info through `CString` to `LPCTSTR` — correct only for TCHAR=wchar builds.
- Like all native backends it only runs when curl is off (`useCurlHttpImpl == false`) or via `forceNativeHttp` reporting fallback; see Shared/Http.md for dispatch order.
