# util/ScriptInformationProvider.h

## Purpose
Datamodel service (`ScriptInformationProvider`, DescribedNonCreatable + Service) that holds the asset URL and access key used to fetch script-related information (e.g., script source for named assets). In this header only configuration setters are exposed; fetching presumably lives in subclasses/implementation.

## Declared API
```cpp
extern const char* const sScriptInformationProvider;

class ScriptInformationProvider
    : public DescribedNonCreatable<ScriptInformationProvider, Instance, sScriptInformationProvider>
    , public Service
{
public:
    ScriptInformationProvider();
    void setAssetUrl(std::string url);      // inline setter
    void setAccessKey(std::string access);  // inline setter
private:
    std::string assetUrl;
    std::string access;
};
```

## Gotchas
- Header includes AsyncHttpCache.h / HeartbeatInstance.h / boost posix_time but declares nothing using them — vestigial or implementation inherited elsewhere; the interesting logic is NOT in this header.
- No getters: other code must be a friend or use reflection.
- Access key stored in plain std::string member.

## UNKNOWN
- Where the actual fetch/cache behavior lives (derived classes or .cpp; likely ties to ContentId named-asset resolution).
