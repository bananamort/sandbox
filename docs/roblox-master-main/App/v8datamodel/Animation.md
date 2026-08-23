# App/v8datamodel/Animation.cpp

## Purpose

Implements `Animation` ("Animation") — the lightweight creatable Instance that just holds an asset reference (`AnimationId`) pointing at a KeyframeSequence. It is the argument you pass to `Animator:LoadAnimation` / `Humanoid:LoadAnimation`.

## API

- `const char* const sAnimation = "Animation"`.
- Reflection: `prop_AnimationId` — `"AnimationId"` (category_Data), type AnimationId (Content), backed by `getAssetId`/`setAssetId`. The commented-out `Loop` and `Priority` property descriptors are disabled in this tree.
- Constructors: `Animation()` via `DescribedCreatable<Animation, Instance, sAnimation>`.
- `bool isEmbeddedAsset() const` — true when the assetId is neither http nor an asset reference.
- `shared_ptr<const KeyframeSequence> getKeyframeSequence() const` and `getKeyframeSequence(const Instance* context) const` — resolves the asset through the `KeyframeSequenceProvider` service (`ServiceProvider::create<KeyframeSequenceProvider>(context)->getKeyframeSequence(assetId, this)`); returns null for null assetId or missing provider.
- `void setAssetId(AnimationId value)` — sets and raises prop_AnimationId when changed.

## Usage

Created by scripts (`Instance.new("Animation")`) and by engine code (`Animator::passiveLoadAnimation` synthesizes one per replicated ContentId). The KeyframeSequence lookup is the bridge to the animation content cache in KeyframeSequenceProvider.

## Gotchas

- `getKeyframeSequence(context)` uses the *parent* of the Animator as context in Animator::loadAnimation, so the Animation must be resolvable inside a Workspace-backed provider chain ("Object must be in Workspace before loading animation." warning comes from the caller).
- No Loop/Priority properties exist on this class despite upstream Roblox API history — those live on KeyframeSequence/AnimationTrack here.
