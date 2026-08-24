# util/HttpPlatformImpl.h

## Purpose
Platform HTTP layer contract: disk cache format for HTTP responses (magic `RBXH` header, URL-keyed files), a fully-specified `HttpOptions` struct for `perform()`, cookie-jar/proxy control, and cache cleaning policy. Implementation lives per-platform.

## Declared API
```cpp
namespace RBX::HttpPlatformImpl {

namespace Cache {
    boost::filesystem::path cacheFilePath(const char* url);   // hashed file location for a url

    struct Header {   // on-disk format, version 1, magic 0x52425848 "RBXH"
        const uint32_t magic;              // RBX_CACHE_FILE_MAGIC
        const uint32_t version;            // RBX_CACHE_FILE_VERSION = 1
        const uint32_t urlBytes;
        const uint8_t  url[1024];          // RBX_CACHE_URL_MAX_LENGTH; NOT null-terminated
        const uint32_t responseCode;
        const uint32_t responseHeadersSize;
        const uint32_t responseHeadersHash;
        const uint32_t responseBodySize;
        const uint32_t responseBodyHash;
        const uint32_t reserved;
    };

    class Data {   // read-only byte view
    public:
        Data(const uint8_t* data, size_t bytes);
        Data(const char* data, size_t bytes);
        uint8_t operator[](size_t index) const;
        const uint8_t* data() const;
        std::string toString() const;
        size_t size() const;
    };

    struct CacheEntry {   // word-aligned; header followed by payload blob
        Header cacheHeader;
        uint8_t data[1];                   // flexible-array-style payload
        const Data getResponseHeader() const;
        const Data getResponseBody() const;
        CacheEntry(const Header&, const Data& headers, const Data& body);
    };

    class CacheResult {
    public:
        explicit CacheResult(const std::string& invalidReason);       // failure
        explicit CacheResult(shared_ptr<CacheEntry> entry, size_t size);
        bool isValid() const;
        const std::string& getInvalidReason() const;
        const Header& getCacheHeader() const;
        const Data getResponseHeader() const;
        const Data getResponseBody() const;
        const size_t size() const;
        static CacheResult open(const char* assetUrl, const char* cdnUrl);
            // open cached file for url; NULL-equivalent if unopenable
        static CacheResult update(const char* assetUrl, const char* cdnUrl,
                                  const uint32_t responseCode,
                                  const Data& headers, const Data& body);
            // atomically rewrite the file, return new entry
    };

    struct CacheCleanOptions {
        size_t numFilesRequiredBeforeCleaning;
        size_t numFilesToKeep;
        size_t numGigaBytesAvailableTrigger;
        bool flagCleanUpBasedOnMemory;
    };
    void cleanCache(const CacheCleanOptions& options);
}

struct HttpOptions {
    const std::string& url;
    bool externalRequest;
    HttpCache::Policy cachePolicy;
    long connectTimeoutMillis;
    long performTimeoutMillis;
    std::istream* postData;                // NULL => GET
    bool compressedPostData;
    std::string const* hdrContentType;     // all optional pointers default NULL
    HttpAux::AdditionalHeaders const* addlHeaders;

    HttpOptions(const std::string& url, bool externalRequest, HttpCache::Policy cachePolicy,
                long connectTimeoutMillis, long performTimeoutMillis);
    void setPostData(std::istream* dataStream, bool compressed);
    void setHeaders(const std::string* contentType, const HttpAux::AdditionalHeaders* headers);
};

void init(Http::CookieSharingPolicy cookieSharingPolicy);  // NOT thread-safe
void setCookiesForDomain(const std::string& domain, const std::string& cookies);
void getCookiesForDomain(const std::string& domain, std::string& cookies);
boost::filesystem::path getRobloxCookieJarPath();
void setProxy(const std::string& host, long port = 0);
void perform(HttpOptions& options, std::string& response);  // blocking request
}
```

## Gotchas
- `init()` is explicitly documented as **not thread-safe** — call once at startup.
- Cached URL field is capped at 1024 bytes and not NUL-terminated; longer URLs presumably fail hashing/storage.
- `CacheResult::update` is the only sanctioned write path ("data in this structure is read-only... update via update()"); it writes atomically.
- `HttpOptions` holds raw references/pointers (`url`, `postData`, header pointers): all referenced data must outlive the `perform()` call.
- Response body returned via `std::string&` out-param — whole response buffered.
- `perform` is synchronous; async paths live in Http.h / AsyncHttpQueue.md.

## UNKNOWN
- Hash algorithm used for `cacheFilePath` and the header body hashes (.cpp per platform).
