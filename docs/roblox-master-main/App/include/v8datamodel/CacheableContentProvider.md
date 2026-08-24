# App/include/v8datamodel/CacheableContentProvider.h

## Purpose

Abstract base for content services that fetch, cache, and serve binary blobs by `ContentId` (ancestor of Mesh/Terrain/Texture-style providers). Combines an LRU cache + failure cache with an async HTTP job and a per-frame heartbeat pump; subclasses implement the decode step (`ProcessTask`) and error handling.

## Declared API

`class CacheableContentProvider : public DescribedNonCreatable<..., Instance, sCacheableContentProvider, ClassDescriptor::RUNTIME_LOCAL>, public Service, public HeartbeatInstance`

- Constructor: `CacheableContentProvider(CacheSizeEnforceMethod enforceMethod, unsigned long size);`
- Cache control: `void setCacheSize(int size);` `void setImmediateMode();` `bool clearContent();`
- Request surface: `bool hasContent(const ContentId& id);` `shared_ptr<void> requestContent(const ContentId&, float priority, bool markUsed, AsyncHttpQueue::RequestResult& result);` `shared_ptr<void> blockingRequestContent(const ContentId&, bool markUsed);` `shared_ptr<void> fetchContent(const ContentId&);` `bool isRequestQueueEmpty() { return pendingRequests == 0; }` (atomic counter).
- Failure tracking: `bool isAssetFailed(const ContentId& id);` protected `markContentFailed(const std::string& id)`, `getContentStatus(const std::string& id)`, `isAssetContent(ContentId id)`.
- Overrides: `onHeartbeat(const Heartbeat&)`, `onServiceProvider(old,new)`.
- Subclass contract: `virtual TaskScheduler::StepResult ProcessTask(const std::string& id, shared_ptr<const std::string> data) = 0;` (pure) with static trampoline `ProcessTaskHelper(weak_ptr<...>, ...)`; `virtual void ErrorTask(const std::string& id);` (+static Helper); `virtual void updateContent(const std::string& id, shared_ptr<CachedItem> cachedItem);`
- HTTP plumbing: static `LoadContentCallbackHelper(weak_ptr<...>, AsyncHttpQueue::RequestResult, std::istream* filestream, shared_ptr<const std::string> data, std::string id)` and member `LoadContentCallback(...)`; member `shared_ptr<ContentProviderJob> contentJob;`
- Storage: nested `class CachedItem { AsyncHttpQueue::RequestResult requestResult; shared_ptr<void> data; CachedItem(data=nullptr, result=Waiting); ~CachedItem(){data.reset();} };` LRU via scoped `ConcurrentControlledLRUCache<std::string, shared_ptr<CachedItem>> lruCache;` failures in mutex-guarded global-typedef `Set failedCache` (`boost::unordered_set<std::string>`, typedef'd at file scope as `Set`). `bool immediateMode; rbx::atomic<int> pendingRequests;`

## Gotchas

- File-scope `typedef boost::unordered_set<std::string> Set;` leaks into every includer — name-collision hazard.
- Callbacks hold `weak_ptr<CacheableContentProvider>` — provider destruction mid-download silently drops results.
- `CachedItem::data` is type-erased `shared_ptr<void>`; casts happen in subclass code.
- `immediateMode` bypasses async queueing (set once; no unsetter).

## UNKNOWN

- Eviction policy mapping of `CacheSizeEnforceMethod` to LRU behavior (.cpp / util/ControlledLRUCache — no impl doc exists for this header at time of writing).

## Cross-links

- Siblings: [MeshContentProvider.md](MeshContentProvider.md), [TextureContentProvider.md](TextureContentProvider.md), [SolidModelContentProvider.md](SolidModelContentProvider.md), base [ContentProvider.md](ContentProvider.md).
