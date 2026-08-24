# util/LegacyContentTable.h

## Purpose
Lookup table mapping legacy content paths to content ids — used to translate old asset URLs to their modern equivalents at load time.

## Declared API
```cpp
class LegacyContentTable {
public:
    LegacyContentTable();   // presumably pre-populates the table
    void AddEntry(const std::string& path, const std::string& contentId);
    void AddEntryProd(const std::string& path, const std::string& contentId);
    const std::string& FindEntry(const std::string& path);
private:
    typedef boost::unordered_map<std::string, std::string> UrlMap;
    UrlMap mMap;
    std::string mEmpty;
};
```

## Gotchas
- `FindEntry` returns a reference to a persistent empty string for misses (no exception) — callers must check `empty()` on the result.
- `AddEntry` vs `AddEntryProd`: presumably staging vs production URL targets (distinction is .cpp-side, UNKNOWN).
- Duplicate `path` inserts overwrite silently (unordered_map semantics).

## UNKNOWN
- Table contents and which legacy paths are covered (.cpp data).
