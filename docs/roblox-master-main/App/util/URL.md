# URL.cpp

**Source**: `App/util/URL.cpp` (427 lines) — implements `RBX::Url` (declared in `App/include/util/URL.h`), a small RFC 3986 URL parser/normalizer that replaces the legacy W3C `HTParse` code when `DFFlag::UseNewUrlClass` is on (defined here, **default true**).

## Purpose
Parses `scheme://host/path?query#fragment`, normalizes scheme/host to lowercase and collapses `//`, `/.`, `/..` in paths, and provides case-insensitive subdomain/path comparisons used by trust checks (`Http::isRobloxSite`, `isMoneySite`, `isExternalRequest`) and ContentId reconstruction.

## API
```cpp
static Url Url::fromString(const char* str);
static Url Url::fromComponents(const std::string& scheme, const std::string& host,
                               const std::string& path, const std::string& query,
                               const std::string& fragment);
void normalize();                 // lowercase scheme/host; resolve . / .. segments
std::string asString() const;     // reassembles scheme://host/path?query#fragment
bool isValid() const;             // all five components valid
bool hasValidScheme() const;      // ALPHA *( ALPHA / DIGIT / + / - / . )
bool hasHttpScheme() const;       // "http" || "https"
bool hasValidHost() const;        // RFC3986 reg-name only (no userinfo@ or :port!)
bool hasValidPath() const;
bool hasValidQuery() const;
bool hasValidFragment() const;
bool isSubdomainOf(const char* domain) const;   // host == domain or ends ".domain" (case-insensitive)
bool pathEquals(const char*) const;
bool pathEqualsCaseInsensitive(const char*) const;
// accessors scheme()/host()/path()/query()/fragment(), pathIsEmpty() live in the header
```

## Usage
- `fromString` splits manually: scheme run terminated by `"://"`, host up to first `/`, fragment at first `#`, query at first `?` (fragment searched first since both allow `?`). Missing path defaults to `"/"`; missing scheme leaves `scheme_` empty (relative reference).
- Character classification uses a 256-entry bit table (`RFC3986::charClassTable_`) with classes Unreserved/PercentEncoded/SubDelim/HexDigit/Pchar/RegName/Path/QueryOrFragment/Scheme; percent escapes validated as `%XX`.
- Consumers across the HTTP layer: `HTTPStatistics::getServiceCategory` (`pathEquals(DataStore::urlApiPath())`), `Http::isStrictlyRobloxSite/isRobloxSite/isMoneySite/isExternalRequest/trustCheck` (`isSubdomainOf("roblox.com")`, exact host+path matches for facebook/google/youtube auth endpoints), and `ContentId::reconstructUrl` (`fromComponents(...).asString()` rebuild).

## Gotchas
- `hasValidHost` accepts only reg-name hosts — URLs containing `user@host` or `host:port` are *invalid*, so validation-gated logic will reject legitimate port-bearing URLs.
- `hasValidQuery`/`hasValidFragment` validate the **path_** member instead of query_/fragment_ (copy-paste bug): a malformed path can make a valid query look invalid and vice versa.
- `isSubdomainOf` finds the last case-insensitive occurrence of `domain`; because it requires the match to end at host end and be preceded by `.`, `evil-roblox.com` correctly fails, but a host like `a.b.c.roblox.com` passes for domain `roblox.com` as intended.
- No IPv6/IPv4-literal host support; no port parsing; `normalize()`'s in-place `..` collapse cannot climb above root (extra `..` are dropped).
