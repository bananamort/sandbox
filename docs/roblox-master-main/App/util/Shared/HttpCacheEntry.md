# Shared/HttpCacheEntry.cpp

**Source**: `App/util/Shared/HttpCacheEntry.cpp` (341 lines) — implements the disk-cache primitives declared in `App/include/util/HttpPlatformImpl.h` under `RBX::HttpPlatformImpl::Cache`.

## Purpose
Maps URLs to hashed files under `<cacheDir>/http/`, stores/validates cached HTTP responses (headers + body + status), and prunes the cache directory. Used by the curl backend (Shared/HttpPlatformImpl.cpp) and the Xbox backend (XboxHttp2.cpp) for `PolicyFinalRedirect` caching.

## API
```cpp
boost::filesystem::path cacheFilePath(const char* url);   // MD5(url) hex string as filename in gCachePath()
void cleanCache(const CacheCleanOptions& options);        // sort by mtime, unlink oldest beyond numFilesToKeep
CacheResult CacheResult::open(const char* assetUrl, const char* cdnUrl);
CacheResult CacheResult::update(const char* assetUrl, const char* cdnUrl, const uint32_t responseCode,
                                const Data& headers, const Data& body);
CacheEntry::CacheEntry(const Header&, const Data& responseHeaders, const Data& responseBody);
const Data CacheEntry::getResponseHeader() const;         // first responseHeadersSize bytes of data[]
const Data CacheEntry::getResponseBody() const;           // following responseBodySize bytes
```

## Usage
- File name: MD5 of `assetUrl ? assetUrl : cdnUrl` (`MD5Hasher`) inside `FileSystem::getCacheDirectory(true, "http")`.
- Validation on open: magic `htonl(RBX_CACHE_FILE_MAGIC)` ("RBXH"), version == 1, URL bytes equal to `cdnUrl` (when opening by CDN URL) or exact-length memcmp, XXH32 hash match for headers (seed 12903780) and body, and `responseCode == 200`.
- On success, entry mtime is refreshed (`last_write_time = now`) so LRU cleanup keeps hot entries.
- `update()` writes a fresh file only when `responseCode == 200`; anything else returns an invalid CacheResult with a reason string.
- Concurrency: all open/update/clean share one process-wide `static boost::mutex assetCacheMutex`; Windows callers additionally take a per-URL named mutex (`ScopedNamedMutex`, see NamedMutex.cpp) keyed by an XXH32-of-URL name before calling in (that logic lives in HttpPlatformImpl.cpp).
- I/O helpers are local statics `readWholeFile`/`writeWholeFile` using fopen/_wfopen whole-file reads; `ceDeleter` casts the CacheEntry back to its char[] allocation.

## Gotchas
- Only 2 KB of validation — no signature/HMAC — so the cache is tamperable on disk; integrity relies solely on unkeyed XXH32 hashes.
- The stored `url` field is truncated at `RBX_CACHE_URL_MAX_LENGTH` (1024) with `std::min`, and `memcpy(const_cast<uint8_t*>(cacheHeader.url), cdnUrl, ...)` reads up to that many bytes from `cdnUrl` without re-checking length beyond the min — a >1024-byte URL truncates rather than fails.
- Non-200 entries from older versions fail open() with reason "Non 200 Responses are not opened" and decay via mtime-based cleanup instead of being deleted eagerly (comment explains the historical 404-caching bug).
- `cleanCache` counts directories in `dirents.size()` too but skips unlinking them; the count includes them against `numFilesRequiredBeforeCleaning`.
