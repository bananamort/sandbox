# App/include/v8datamodel/ContentProvider.h

## Purpose

`ContentProvider` (RUNTIME_LOCAL service) — the central content pipeline: resolves ContentIds to bytes via HTTP cache/disk/local folders, preloads with priorities, exposes base-URL configuration, script-signature verification, and asset-folder management. Hosts the `AsyncHttpCache<CachedContent>` and a heartbeat pump.

## Declared API

`class ContentProvider : public DescribedNonCreatable<ContentProvider, Instance, sContentProvider, ClassDescriptor::RUNTIME_LOCAL>, public Service, public HeartbeatInstance`

- Statics: logging hooks `static Log *appLog; static RBX::mutex *appLogLock;` priority ladder `PRIORITY_DEFAULT, PRIORITY_MFC, PRIORITY_SCRIPT, PRIORITY_MESH, PRIORITY_SOLIDMODEL, PRIORITY_INSERT, PRIORITY_CHARACTER, PRIORITY_ANIMATION, PRIORITY_TEXTURE, PRIORITY_DECAL, PRIORITY_SOUND, PRIORITY_GUI, PRIORITY_SKY` (all static float); asset folders (`assetFolderPath`, `platformAssetFolderPath`, string twins, `assetFolderAlreadyInit`); `static boost::mutex preloadContentBlockingMutex;`
- Reflection: `static Reflection::PropDescriptor<ContentProvider, std::string> desc_baseUrl;`
- URL config: `getBaseUrl()`, `getApiBaseUrl()`, `getUnsecureApiBaseUrl()` (+static overloads taking a baseUrl), `setBaseUrl(std::string)`.
- Capacity: `void setThreadPool(int count); void setCacheSize(int count);`
- Preload: `void preloadContentWithCallback(ContentId, float priority, function<void(AsyncHttpQueue::RequestResult)> callback, ResultJob = AsyncInline, const std::string& expectedType = "");` `preloadContent(ContentId)`; `preloadContentBlockingList(shared_ptr<const Reflection::ValueArray> idList, resumeFn, errorFn)` + helper + result callback; nested `class PreloadAsyncRequest { int outstanding; int failed; };`
- Queries: `bool isUrlBad(ContentId)`; `bool isRequestQueueEmpty();` `int getRequestQueueSize() const`; `bool hasContent(const ContentId& id);` (true if available) ; `shared_ptr<const std::string> requestContentString(id, priority)` — non-null if available, else kicks async fetch for later; failed/request queues as ValueArrays: `getFailedUrls()`, `getRequestQueueUrls()`, `getRequestedUrls()`.
- Async loads: `getContent(id, priority, RequestCallback, jobType=AsyncInline, expectedType="")`; `loadContent(id, priority, callback(Result, shared_ptr<Instances>, shared_ptr<std::exception>), jobType)`; `loadContentString(...const std::string variant...)`.
- Blocking ("throw upon failure or return NULL"): `shared_ptr<const std::string> getContentString(ContentId)`; `std::auto_ptr<std::istream> getContent(const ContentId&, expectedType="")`; `std::string getFile(ContentId)`; statics `registerContent(std::istream&) → ContentId`, `getAssetFile(const char* filePath)`, `findAsset(ContentId)`, `isUrl/isHttpUrl(std::string)`.
- Security: static `verifyScriptSignature(const ProtectedString& source, bool required)` / `verifyRequestedScriptSignature(source, assetId, required)` — "throws an exception".
- Maintenance: `clearContent()`, `invalidateCache(ContentId)`, `printContentNames()` (debug), `setAssetFetchMediator(AssetFetchMediator*)`; overrides `onServiceProvider` (resets cache stats item, hooks heartbeat) and `onHeartbeat`.
- Folder mgmt: static `setAssetFolder(const char* path)`, `assetFolder()`, `platformAssetFolder()`.
- Private: `enum RequestType { NoHttpRequest, AsyncHttpRequest, SyncHttpRequest, FullAsyncRequest }` (comment: FullAsyncRequest returns disk requests as memory streams like http); `clearFinishFlag`, `afm`, `baseUrl`; internals `isContentLoaded`, `blockingLoadContent(id, CachedContent* result, expectedType)`, `privateLoadContent(...)`, `findHashFile`, `findLocalFile(url, filename*)`, `registerFile`, `isInSandbox(path, sandbox)`; two cleanup threads (`legacyContentCleanupThread`, `contentCleanupThread`).
- Cache value: `struct CachedContent { shared_ptr<const std::string> data; shared_ptr<const std::string> filename; ...ctors... };` member `boost::shared_ptr<AsyncHttpCache<CachedContent>> contentCache;`
- Extension point: `class AssetFetchMediator { virtual boost::optional<std::string> findCachedAssetOrEmpty(const ContentId& contentId, int universeId) = 0; };`

## Gotchas

- Two cleanup threads exist side by side (legacy vs current) — double eviction paths.
- `requestContentString` may return NULL after triggering an async fetch: callers must re-request later.
- Script-signature verification throws when `required` and signature fails — hard failure path.
- Static mutable state everywhere (priorities, folders, log pointer): process-global configuration.

## UNKNOWN

- Cache eviction policy parameters of AsyncHttpCache (.util header; no impl doc exists at time of writing).

## Cross-links

- Kin providers subclassing the pattern: [MeshContentProvider.md](MeshContentProvider.md), [TextureContentProvider.md](TextureContentProvider.md), [SolidModelContentProvider.md](SolidModelContentProvider.md), [CacheableContentProvider.md](CacheableContentProvider.md); service [HttpService.md](HttpService.md).
