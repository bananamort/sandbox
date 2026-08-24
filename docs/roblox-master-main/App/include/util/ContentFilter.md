# util/ContentFilter.h

## Purpose
Datamodel service (`RBX::ContentFilter`, a `DescribedNonCreatable` Instance + `Service`) that checks whether user-supplied strings are "safe" via a server-side filter URL, caching results in a bounded dictionary with reference counts.

## Declared API
```cpp
extern const char* const sContentFilter;   // class name "ContentFilter"

class ContentFilter
    : public DescribedNonCreatable<ContentFilter, Instance, sContentFilter,
                                   Reflection::ClassDescriptor::RUNTIME_LOCAL>
    , public Service
{
public:
    typedef enum { Waiting, Succeeded, Failed } FilterResult;
    static const unsigned MAX_CONTENT_FILTER_SIZE;

    ContentFilter();
    ~ContentFilter();

    FilterResult getStringState(std::string& value);  // in/out: value may be truncated
    void setFilterUrl(std::string);
    void setFilterLimits(int, int);                   // (maxOutstandingRequests, maxTableSize) — order UNKNOWN
    void doFilterRequest(std::string value);          // fire async filter request
    void saveFilterResult(std::string value, bool result);
private:
    struct ResultEntry { bool result; int usageCount; };
    typedef std::map<std::string, ResultEntry> ResultsDictionary;
    typedef std::set<std::string> RequestSet;
    static void truncateString(std::string& text);
    bool isContentFilterReady(const std::string& value); // false if unknown; may truncate
    bool isStringSafe(std::string& value);
    void cleanTable();

    ResultsDictionary resultsDictionary;
    RequestSet requestSet;
    std::string url;
    unsigned maxOutstandingRequests;
    unsigned maxTableSize;
};
```

## Gotchas
- `getStringState` takes the string **by reference** and may truncate it to `MAX_CONTENT_FILTER_SIZE` before checking — callers' data can be modified.
- `Waiting` means a request is outstanding; poll again later (no callback in this interface).
- Result cache is keyed by exact string; entries carry usage counts and the table is cleaned when exceeding `maxTableSize`.
- RUNTIME_LOCAL descriptor: service exists locally per place, not replicated.
- No visible locking — thread-safety depends on the datamodel's serial semantics (UNKNOWN cross-thread use).

## UNKNOWN
- Exact meaning/order of `setFilterLimits(int,int)` parameters (implementation-side).
- Wire format of filter requests to `url`.
