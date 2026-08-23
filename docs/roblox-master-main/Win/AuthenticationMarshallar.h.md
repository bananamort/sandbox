# AuthenticationMarshallar.h

Source: `roblox-sandbox/Win/AuthenticationMarshallar.h` (16 lines)

## Purpose

Declares `AuthenticationMarshallar`, per its own comment: "Keeps authentication cookies in sync between Protected Model IE and unprotected IE". One small class holding a domain string with two ways to exchange a stale auth ticket for a fresh one over HTTP.

## API

```cpp
class AuthenticationMarshallar
{
    std::string domain;
public:
    AuthenticationMarshallar(const char* domain);
    ~AuthenticationMarshallar(void);
    std::string Authenticate(const char* url, const char* ticket);          // blocking; "" on error
    RBX::HttpFuture AuthenticateAsync(const char* url, const char* ticket); // returns future
};
```

Includes `util/HttpAsync.h` for `RBX::HttpFuture`; the `boost/function.hpp` include is vestigial (nothing in the header uses boost::function).

## Usage

Included only by `WindowsClient/Application.cpp` (verified by tree-wide grep), which instantiates the class twice around browser/web-view authentication negotiation using the base-URL host name as the domain.

## Gotchas

- Despite the IE-specific comment, the class itself is host-agnostic: it just wraps two flavors of authenticated GET against `url?suggest=<ticket>`.
- No copy protection and no virtual destructor — fine for its stack-allocated usage pattern.
