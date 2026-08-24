# Animation.cpp

## Purpose

Implements `Animation` ("Animation"), the thin asset-reference object pointing at a KeyframeSequence. The TU is nearly all accessor logic: resolve the referenced asset through the context's KeyframeSequenceProvider.

## Key types and API

Descriptors:
- `prop_AnimationId("AnimationId", category_Data)` — `AnimationId` typed asset id, get/set with change-tracked raise. No Security:: arguments. A commented-out `Loop` prop and `Priority` enum prop exist in source but are NOT registered.

Constants: `sAnimation = "Animation"`.

Behavior:
- ctor `DescribedCreatable<Animation, Instance, sAnimation>` — name shell only.
- `isEmbeddedAsset()` — true when the id is neither http nor asset scheme (i.e. embedded/local content).
- `getKeyframeSequence()` / `getKeyframeSequence(const Instance* context)` — null id → empty shared_ptr; otherwise `ServiceProvider::create<KeyframeSequenceProvider>(context)->getKeyframeSequence(assetId, this)` ([KeyframeSequenceProvider](KeyframeSequenceProvider.md)).
- `setAssetId(AnimationId)` — change-tracked setter.

## Usage / reflection touchpoints

Referenced by AnimationTrack's track state machinery ([AnimationTrack](AnimationTrack.md), [AnimationTrackState](AnimationTrackState.md)); assets fetched via [AssetService](AssetService.md)-backed provider paths.

## Gotchas

- Loop/Priority live commented out in this TU — they were never descriptor-registered here despite being public Animation API elsewhere.
- getKeyframeSequence returns const shared_ptr and caches nothing itself; repeated calls go back through the provider.
