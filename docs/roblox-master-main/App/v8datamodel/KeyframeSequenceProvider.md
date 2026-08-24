# KeyframeSequenceProvider.cpp

## Purpose

Implements `KeyframeSequenceProvider` ("KeyframeSequenceProvider") — the animation asset loader/cache: 100-entry LRU of KeyframeSequences keyed by resolved URL, async/blocking fetch paths (InsertService fast path vs ContentProvider), active:// solo-mode registry, and GetAnimations web query (assetTypeId=24).

## Key types and API

Descriptors:
- `func_setActiveKeyframeSequence("RegisterActiveKeyframeSequence", "keyframeSequence", Security::None)` — SOLO MODE ONLY (throws otherwise); stores under `active://<n>` incrementing id.
- `func_setKeyframeSequence("RegisterKeyframeSequence", Security::None)` — solo/CloudEdit only; binary-serializes into registered content.
- `func_getKeyframeSequence("GetKeyframeSequence", "assetId", Security::None)` — blocking-ish cached fetch returning a CLONE.
- `func_getKeyframeSequenceById("GetKeyframeSequenceById", "assetId","useCache", Security::None)` — int id variant (useCache param ignored by implementation).
- `func_getAnimations("GetAnimations", "userId","page"[1], Security::None)` — yield func ValueTable.

Flags: AnimationAllowProdUrls(true), DontUseInsertServiceOnAnimLoad(false), AnimationFailedToLoadContext(false).

Behavior:
- `privateGetKeyframeSequence(assetId, blocking, useCache, context, contextInstance)` — normalizes rbxassetid/http ids to `<base>/asset/?id=N&serverplaceid=<placeId>` (prod URL preserved under flag; studio sends placeID 0 via getPlaceIDOrZeroInStudio); active:// lookup throws on unknown; cache hit returns SHARED pointer (Lua paths clone); MISS inserts empty sequence immediately then fills: non-blocking http/asset ids go through InsertService::loadAsset (callback copies data under DataModel Write task, then internalDelete cleanup — comment warns cleanup can be missed on shutdown), else ContentProvider sync/async with PRIORITY_ANIMATION. Failure logging only under AnimationFailedToLoadContext.
- copyLoadedData requires EXACTLY one loaded instance; copies Loop/Priority + luaCloned children ([KeyframeSequence](KeyframeSequence.md)::copyKeyframeSequence).
- getAnimations validates userId/page >0, GETs ownership/assets JSON, parsed under LegacyLock Write.

## Usage / reflection touchpoints

Consumed by [Animation](Animation.md)::getKeyframeSequence and [Animator](Animator.md) passive loads; InsertService handoff documented in [InsertService](InsertService.md).

## Gotchas

- getKeyframeSequence Lua variants return CLONES but the engine path returns the CACHED instance shared across tracks — editing one mutates all users of that id.
- The placeholder-in-cache-on-miss design means a FAILED load leaves an empty KeyframeSequence cached forever (no eviction on failure).
- GetKeyframeSequenceById's useCache parameter is accepted and IGNORED — the call site hardcodes useCache=FALSE, so this path always SKIPS the cache read (though it still inserts its fresh sequence into the cache).
