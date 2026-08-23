# AuthenticationMarshallar.cpp

Source: `roblox-sandbox/Win/AuthenticationMarshallar.cpp` (61 lines)

## Purpose

Implements the authentication-ticket "re-negotiation" round trip declared in AuthenticationMarshallar.h: given an auth endpoint and a stale ticket, it issues a GET whose response body is the replacement ticket, attaching the owning domain either as the HTTP auth domain (sync path) or as an `RBX::Http::kRBXAuthenticationNegotiation` header (async path). The class comment frames the intent as keeping auth cookies in sync between browser hosts.

## API

```cpp
AuthenticationMarshallar::AuthenticationMarshallar(const char* domain);   // stores domain
AuthenticationMarshallar::~AuthenticationMarshallar(void);                // trivial

static-file-scope std::string buildUrl(const char* url, const char* ticket);
    // url + ("?suggest=" + ticket) when ticket non-NULL

std::string AuthenticationMarshallar::Authenticate(const char* url, const char* ticket);
    // Http(buildUrl(url,ticket)); http.setAuthDomain(domain); http.get(result);
    // any std::exception → returns "" (error swallowed, only a "//Report Error!" TODO)

RBX::HttpFuture AuthenticationMarshallar::AuthenticateAsync(const char* url, const char* ticket);
    // HttpOptions header kRBXAuthenticationNegotiation = domain; RBX::HttpAsync::get(...)
```

## Usage

Consumed by WindowsClient/Application.cpp (lines ~396 and ~405), which constructs one per browser-auth negotiation with `AuthenticationMarshallar(baseUrl.GetHostName())`. Note the sync/async paths attach the domain differently: `setAuthDomain` vs. a dedicated negotiation header.

## Gotchas

- `buildUrl` appends the ticket as a raw `?suggest=` query parameter with no URL encoding — tickets containing `&`, `=`, spaces or `+` corrupt the query.
- `Authenticate` performs a GET (despite "Post our ticket back" in the comment) and treats ANY exception as empty-string failure; callers cannot distinguish network errors from an legitimately-empty ticket.
- `buildUrl` is a non-static free function at file scope (external linkage), not a class member.
