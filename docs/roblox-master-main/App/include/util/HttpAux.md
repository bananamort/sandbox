# util/HttpAux.h

## Purpose
One-type helper namespace for HTTP: the `AdditionalHeaders` map type shared by HttpAsync/HttpOptions.

## Declared API
```cpp
namespace RBX::HttpAux {
    typedef boost::unordered_map<std::string, std::string> AdditionalHeaders;
}
```

## Gotchas
- Unordered map: header ordering on the wire is unspecified — don't rely on it.
- Duplicate header keys collapse (map semantics), unlike true multi-value HTTP headers.

## UNKNOWN
- Other HttpAux helpers, if any, living only in the .cpp.
