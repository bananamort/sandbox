# App/include/v8datamodel/KeyframeSequenceProvider.h

## Purpose

`KeyframeSequenceProvider` (RUNTIME_LOCAL service) — animation asset registry/resolver: registers in-memory sequences to synthetic ContentIds, resolves ids (including real asset ids with optional cache and context) for playback, and proxies the web "get animations" listing.

## Declared API

`class KeyframeSequenceProvider : public DescribedNonCreatable<..., Instance, sKeyframeSequenceProvider, ClassDescriptor::RUNTIME_LOCAL>, public Service`

- Registration: `ContentId registerKeyframeSequence(shared_ptr<Instance>); ContentId registerActiveKeyframeSequence(shared_ptr<Instance>);`
- Resolution: `shared_ptr<Instance> getKeyframeSequenceLua(ContentId assetId); shared_ptr<Instance> getKeyframeSequenceByIdLua(int assetId, bool useCache); shared_ptr<const KeyframeSequence> getKeyframeSequence(ContentId, const Instance* context);`
- Web: `void getAnimations(int userId, int page, resume(ValueTable), error);` private `JSONHttpHelper(response, exception, resume, error)`.
- State: `int activeKeyframeId; std::map<std::string, shared_ptr<KeyframeSequence>> activeKeyframeTable; typedef SizeEnforcedLRUCache<std::string, shared_ptr<KeyframeSequence>> KeyframeSequenceCache; boost::mutex keyframeSequenceCacheMutex ("synchronizes the keyframeSequenceCache"); KeyframeSequenceCache keyframeSequenceCache;`
- Private resolver core: `privateGetKeyframeSequence(ContentId assetId, bool blocking, bool useCache, const std::string& contextString = "", const Instance* contextInstance = NULL);`

## Gotchas

- Two registration flavors — "active" sequences stay pinned via activeKeyframeTable beyond LRU eviction.
- Cache access is mutex-guarded; blocking fetches can stall the calling thread.

## UNKNOWN

- Synthetic ContentId format for registered sequences (.cpp — see [KeyframeSequenceProvider.md](../../v8datamodel/KeyframeSequenceProvider.md)).

## Cross-links

- Implementation: [App/v8datamodel/KeyframeSequenceProvider.md](../../v8datamodel/KeyframeSequenceProvider.md).
- Assets: [KeyframeSequence.md](KeyframeSequence.md), [Animation.md](Animation.md).
