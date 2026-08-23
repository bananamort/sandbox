# Darwin/HttpCocoa.mm

**Source**: `App/util/Darwin/HttpCocoa.mm` (483 lines) — Objective-C++ Apple HTTP backend. Provides `RBX::Cocoa::httpGetPostCocoa(...)` (called from Shared/Http.cpp's `httpGetPostImpl` when curl is off on Apple platforms) plus legacy extern C helpers `rbx_isRobloxSite`, `rbx_isMoneySite`.

## Purpose
Implements blocking GET/POST over the deprecated `NSURLConnection` API with a private NSRunLoop, gzip request/response handling, CSRF token retry, and 10.6-era redirect/authentication workarounds.

## API
```cpp
namespace RBX { namespace Cocoa {
void httpGetPostCocoa(const std::string& url, const std::string& authDomainUrl, bool isPost,
                      std::istream& data, const std::string& contentType, bool compressData,
                      HttpAux::AdditionalHeaders& additionalHeaders, bool externalRequest,
                      std::string& response, bool useDefaultTimeout, int requestTimeoutMillis);
}}
extern "C" int rbx_isRobloxSite(const char* url);   // host contains ".roblox.com" or ".robloxlabs.com"
extern "C" int rbx_isMoneySite(const char* url);    // host contains ".paypal.com" or ".rixty.com"
```
Obj-C class `MacHttpController : NSObject` with `initWithUrl:additionalHeaders:`, `setPostDataFromStream:`, `setPostCompressedDataFromString:`, `doGetPost:contentType:useDefaultTimeout:requestTimeoutMillis:`, and the full NSURLConnection delegate set (`didReceiveResponse/didReceiveData/didFailWithError/connectionDidFinishLoading/willSendRequest/canAuthenticateAgainstProtectionSpace/didReceiveAuthenticationChallenge`). Public ivar `responseCsrfToken`.

## Usage / request construction
- `createSanitizedURL(std::string)` strips trailing whitespace and any `#anchor` before `[NSURL URLWithString:]`.
- Request headers: `Accept-Encoding: gzip`; optional compressed body sets `Content-Encoding: gzip`; every entry of `additionalHeaders`; POST adds Content-Type; User-Agent is `"Roblox/Darwin"` (iOS delegates to `getUserAgentString()`); non-empty auth domain sets header `RBXAuthenticationNegotiation`.
- CSRF: for internal posts the caller-side injects `X-CSRF-TOKEN` into `additionalHeaders` before controller construction; on 403 the delegate captures a new token from response headers into `responseCsrfToken`, and after the run loop unwinds `httpGetPostCocoa` updates the global token and recursively retries.
- Redirects: instead of returning the redirect request (crashes on macOS 10.6.3/10.6.4), the old connection is cancelled/released and a new one started with the mutable copy — see `willSendRequest:` `#if 1` block.
- TLS trust workaround pre-10.8: `canAuthenticateAgainstProtectionSpace`/`didReceiveAuthenticationChallenge` accept **any** server-trust challenge whose host contains `.robloxlabs.com`.
- Synchronous pump: private NSRunLoop mode `@"RobloxHttpController"` spun with `runMode:beforeDate:[NSDate distantFuture]` until done.

## Gotchas
- Uses manual retain/release (pre-ARC); `MacHttpController` released manually; leak-prone if exceptions propagate past `[pool drain]`.
- POST body assembly copies byte-by-byte through `std::istream::get` — explicitly marked slow TODO (should use `setHTTPBodyStream`).
- `didReceiveResponse` clears `receivedData` on *every* intermediate response, so only bytes after the last response callback survive.
- Host matching is substring-based (`.roblox.com` anywhere in host), same loose rule as the WinInet certificate check.
- Only reached when `useCurlHttpImpl == false` or `forceNativeHttp` on Apple builds; default Apple egress is curl.
