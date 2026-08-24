# util/MD5Hasher.h

## Purpose
RBX-facing interface over MD5 hashing: an abstract factory-created hasher plus two convenience free functions. Wraps the low-level `md5.h` machinery behind an RBXInterface class so game/engine code never touches MD5_CTX directly.

## Declared API
```cpp
namespace RBX {
class RBXInterface MD5Hasher {
public:
    static MD5Hasher* create();
    virtual ~MD5Hasher() {}
    virtual void addData(std::istream& data) = 0;
    virtual void addData(const std::string& data) = 0;
    virtual void addData(const char* data, size_t nBytes) = 0;
    virtual const std::string& toString() = 0;   // hex digest
    virtual const char* c_str() = 0;
    virtual void toBuffer(char (&result)[16]) = 0; // raw 16-byte digest

    // Before 03-12-07 the hashing function didn't pad bytes with '0'
    static std::string convertToLegacyHash(std::string hash);
};

std::string CollectMd5Hash(const std::string& fileName);   // hash a file's contents
std::string ComputeMd5Hash(const std::string& data);       // hash an in-memory string
}// namespace
```

## Gotchas
- Factory pattern (`create()` returns an owned `MD5Hasher*`): caller must delete (virtual dtor provided).
- `toString()` returns a reference — presumably valid until the next `addData`; treat as invalidated by further mutation (UNKNOWN: exact lifetime guarantee).
- `convertToLegacyHash` reproduces pre-03-12-07 behavior where bytes were not zero-padded; only use for backward compatibility with old stored hashes.
- `CollectMd5Hash(fileName)` semantics on missing/unreadable file are unspecified here (UNKNOWN: error return value).

## UNKNOWN
- Concrete implementing subclass and its .cpp location (interface-only header; likely implemented out-of-tree or in a platform layer).
- Whether `toString()`/`c_str()` return lowercase hex.
