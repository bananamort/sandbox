# ProtectedString.cpp

**Source**: `App/util/ProtectedString.cpp` (198 lines) — implements `RBX::ProtectedString` (declared in `App/include/util/ProtectedString.h`), the tamper-evident container for Lua script source/bytecode (the `Source` property of Script instances).

## Purpose
Holds a script `source` and/or precompiled `bytecode` together with an MD5 hash computed at write time, so later mutation of the source can be detected (`getOriginalHash()` vs a freshly calculated one). All mutations funnel through the private `setString`, which recomputes the hash.

## API
```cpp
static const ProtectedString emptyString;
static ProtectedString fromTrustedSource(const std::string& stringRef); // sets source, clears bytecode
static ProtectedString fromBytecode(const std::string& stringRef);      // sets bytecode only
static ProtectedString fromTestSource(const std::string&);              // unit tests only
const std::string& getSource() const;
const std::string& getBytecode() const;
bool empty() const;                       // both empty
const std::string& getOriginalHash() const;   // hash captured at last setString
void calculateHash(std::string* out) const;  // MD5( __TIME__ || source )
bool operator==/!=(const ProtectedString&) const;   // compares source AND bytecode
ProtectedString& operator=(const ProtectedString&);
size_t hash_value(const ProtectedString&);          // boost combine(source, bytecode)
```

## Usage
- Hash = `MD5Hasher` over build-time salt `__TIME__` concatenated with the source ("adding salt to hash computation… randomize the salt between builds") — so hashes are comparable only within the same binary build.
- Non-studio builds set `DataModel::sendStats |= HATE_LUA_SCRIPT_HASH_CHANGED` when assignment changes the source — telemetry for in-memory script tampering.
- Reflection integration: `XmlNameValuePair::getValue(ProtectedString&)` and `StringConverter<ProtectedString>` treat any XML/serialization text as **trusted source** via `fromTrustedSource`; `Type::getSingleton<ProtectedString>()` registers type name `"ProtectedString"`; property read/write, Variant conversion, `getDataSize`, and string-value accessors are specialized here.
- Copy constructor deliberately copies all fields verbatim (including a stale hash) to preserve tamper evidence; `operator=` instead re-hashes.

## Gotchas
- The "protection" is integrity detection only — nothing is encrypted; `getSource()` returns the plaintext.
- Because the salt is `__TIME__` (link/build time), hash comparison across different builds always fails; persisted hashes can't be validated after an update. UNKNOWN: whether any server-side check relies on this exact scheme.
- `operator==` ignores the cached hash; two objects with identical source but built through different paths compare equal even if one was tampered post-hash.
- Bytecode-only strings have an empty hash (calculateHash returns "" when source empty).
