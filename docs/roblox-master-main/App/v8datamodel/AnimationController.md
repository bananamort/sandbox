# App/v8datamodel/AnimationController.cpp

## Purpose

Implements `AnimationController` ("AnimationController") — the non-Humanoid animation host Instance. It lazily creates and parents an `Animator` child and forwards its Lua API (LoadAnimation, GetPlayingAnimationTracks, AnimationPlayed) to that Animator; it also steps the Animator from the Stepped event.

## API

Reflection:
- `BoundFuncDesc desc_GetPlayingAnimationTracks` — `"GetPlayingAnimationTracks"()` → ValueArray of tracks, Security::None.
- `BoundFuncDesc desc_LoadAnimation` — `"LoadAnimation"(animation:Instance)` → the new track Instance, Security::None.
- `EventDesc event_AnimationPlayed` — `"AnimationPlayed"(animationTrack:Instance)`.

Methods/overrides: `bool askSetParent(const Instance*) const` — always true (parent anywhere); `void onStepped(const Stepped&)` forwards to animator; `Animator* getAnimator()` — lazily creates via `Creatable<Instance>::create<RBX::Animator>(this)`, parenting it under self only when parent's class name is "Model"; `getPlayingAnimationTracks()` / `loadAnimation(instance)` delegate to the Animator; `onServiceProvider` chains Super + `onServiceProviderIStepped` (Stepped hookup).

## Usage

Scripts do `local c = Instance.new("AnimationController", model); local track = c:LoadAnimation(anim); track:Play()`. All real logic (track creation via KeyframeSequence fetch, replication events OnPlay/OnStop/OnAdjustSpeed/OnSetTimePosition) lives in Animator.cpp; this class is a thin facade plus lifecycle glue.

## Gotchas

- The lazy Animator is only parented under the controller when the controller itself is inside a "Model" — otherwise it exists unparented; either way LoadAnimation works through the pointer.
- GetPlayingAnimationTracks will instantiate an Animator as a side effect.
- Keep-in-sync note in Animator.cpp: this proxy interface mirrors Humanoid's animation methods.
