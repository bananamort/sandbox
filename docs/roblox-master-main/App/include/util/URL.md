# util/URL.h

## Purpose
Modern RFC3986-focused URL parser/builder (HTTP subset): immutable `Url` value type with scheme/host/path/query/fragment accessors, automatic normalization (lowercased scheme+host, collapsed `//`, `/./`, `/../` path segments, forced leading '/'), validity checks per component, subdomain and path-equality helpers. Gated behind DFFlag `UseNewUrlClass`; header notes that once the flag is removed, HTW3C.h and all libwww references should go too.

## Declared API
```cpp
DYNAMIC_FASTFLAG(UseNewUrlClass);

// Format: https://www.roblox.com/very/long/path?query&arg=value#fragment
//   scheme  host        path          query(optional) fragment(optional)

class Url {
public:
    static Url fromString(const std::string& str);   // parse + normalize
    static Url fromString(const char* str);

    static Url fromComponents(const std::string& scheme,
                              const std::string& host,
                              const std::string& path = "/",
                              const std::string& query = "",
                              const std::string& fragment = "");   // + normalize

    const std::string& scheme() const;     // no "://"
    const std::string& host() const;       // domain name expected
    const std::string& path() const;       // always starts with '/'
    const std::string& query() const;      // no '?'
    const std::string& fragment() const;   // no '#'

    bool isValid() const;

    // NOTE: may produce malformed URLs if !isValid() for non-trivial reasons:
    std::string asString() const;

    bool hasValidScheme() const;
    bool hasHttpScheme() const;
    bool hasValidHost() const;
    bool hasValidPath() const;
    bool hasValidQuery() const;
    bool hasValidFragment() const;

    bool pathIsEmpty() const { return path_.length() < 2; }   // i.e. just "/"

    // "www.roblox.com" IS a subdomain of "roblox.com"; "roblox.com" IS of itself;
    // "notroblox.com" is NOT. Case-insensitive:
    bool isSubdomainOf(const char* domain) const;
    bool isSubdomainOf(const std::string& domain) const;

    // simple string compare (leading '/' optional in argument):
    bool pathEquals(const char* path) const;
    bool pathEqualsCaseInsensitive(const char* path) const;
    // + std::string overloads
private:
    void normalize();
    std::string scheme_, host_, path_, query_, fragment_;
};
```

## Gotchas
- Missing/empty scheme or host ⇒ **invalid** Url; "There are no guarantees for invalid Urls" — always check isValid().
- Userinfo (`user:pass@`) and `:port` deliberately NOT handled — such inputs may parse to garbage.
- No %-escaping/decoding at all — out of scope by design.
- Immutable type: build new instances rather than mutate.
- `pathIsEmpty()` means length < 2, i.e. exactly "/".
- Invalid characters or malformed %-sequences make the URL invalid (RFC3986 rules).

## UNKNOWN
- Which callers are flipped over via UseNewUrlClass flag (migration state).
