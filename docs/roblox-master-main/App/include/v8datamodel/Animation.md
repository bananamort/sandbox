# App/include/v8datamodel/Animation.h

## Purpose

`Animation` Instance ("Animation") — a thin handle that names a keyframe-sequence asset by id (`AnimationId`/`ContentId assetId`) and resolves it to the actual `KeyframeSequence` data on demand.

## Declared API

`class Animation : public DescribedCreatable<Animation, Instance, sAnimation>`

- `Animation();`
- `AnimationId getAssetId() const { return assetId; }`
- `void setAssetId(AnimationId value);`
- `shared_ptr<const KeyframeSequence> getKeyframeSequence() const;`
- `shared_ptr<const KeyframeSequence> getKeyframeSequence(const Instance* context) const;` — context-sensitive resolution.
- `bool isEmbeddedAsset() const;`
- Overrides: `askSetParent` → true; `getPersistentDataCost()` = super + `Instance::computeStringCost(getAssetId().toString())`.

## Gotchas

- The object stores only the asset id — all sequence data is fetched through content resolution at `getKeyframeSequence()` time.
- `getPersistentDataCost` counts the serialized asset-id string, so save-file size scales with the id text.

## UNKNOWN

- What "embedded asset" means exactly for `isEmbeddedAsset()` (resolved in .cpp).

## Cross-links

- Implementation: [App/v8datamodel/Animation.md](../../v8datamodel/Animation.md).
- Consumers: [Animator.md](Animator.md), [AnimationTrack.md](AnimationTrack.md), [KeyframeSequence.md](KeyframeSequence.md).
