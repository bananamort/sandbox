# util/ContentId.h

## Purpose
Value type for a content URL/URI (`rbxasset://`, `rbxassetid://`, http(s), `file://`, `rbxhttp://`, `rbxapp://`, named assets). Central to referencing textures/meshes/sounds/etc.; provides scheme tests, asset-id/name extraction, and legacy/base-URL conversions.

## Declared API
```cpp
class ContentId {
public:
    static ContentId fromUrl(const std::string& url);
    static ContentId fromAssets(const char* filePath);   // relative path inside the "Content" directory
    static ContentId fromGameAssetName(const std::string& gameAssetName);

    explicit ContentId(const char* id);        // ctors are EXPLICIT on purpose:
    explicit ContentId(const std::string& id); // "use static ctors above if not fully qualified"
    ContentId();                               // null

    void clear();
    const char* c_str() const;
    const std::string& toString() const;

    void convertToLegacyContent(const std::string& baseUrl);
    void convertAssetId(const std::string& baseUrl, int universeId);
    bool reconstructUrl(const std::string& baseUrl, const char* const paths[], const int pathCount);
    bool reconstructAssetUrl(const std::string& baseUrl);

    std::string getAssetId() const;
    std::string getAssetName() const;
    std::string getUnConvertedAssetName() const;

    bool isNull() const        { return id.size()==0; }
    bool isAsset() const       { return id.compare(0, 11, "rbxasset://") == 0; }
    bool isAssetId() const     { return id.compare(0, 13, "rbxassetid://") == 0; }
    bool isHttp() const        { return id.compare(0, 4, "http") == 0; }
    bool isFile() const        { return id.compare(0, 7, "file://") == 0; }
    bool isRbxHttp() const     { return id.compare(0, 10, "rbxhttp://") == 0; }
    bool isAppContent() const  { return id.compare(0, 9, "rbxapp://") == 0; }
    bool isNamedAsset() const;
    bool isConvertedNamedAsset() const;

    friend bool operator<(const ContentId&, const ContentId&);
    friend bool operator==(const ContentId&, const ContentId*);
    friend bool operator!=(const ContentId&, const ContentId&);
private:
    static void CorrectBackslash(std::string& id);  // normalizes '\' -> '/' on construct
    std::string id;
};

std::size_t hash_value(const ContentId& id);   // boost hash support
```

## Gotchas
- Constructors normalize backslashes via `CorrectBackslash` — Windows-style paths in content ids become forward slashes at construction.
- `isHttp()` matches any prefix "http" (covers https:// too).
- Scheme checks use fixed-length `compare(0, N, ...)` — safe for short strings (compare handles length mismatch).
- The header comment warns: prefer `fromUrl`/`fromAssets`/`fromGameAssetName` over raw string construction when the input isn't already fully qualified.
- Comparison and hashing are over the full normalized string; case sensitivity follows the stored form (no lowering here).

## UNKNOWN
- Semantics of `getUnConvertedAssetName` vs `getAssetName` (named-asset conversion table lives elsewhere).
- Where named assets get resolved (`isNamedAsset`) — likely ScriptInformationProvider or similar outside this slice.
