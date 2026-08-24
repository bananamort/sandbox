# AnimationController.cpp

## Purpose

Implements `AnimationController` ("AnimationController"), the legacy (non-Humanoid) animation host: a lazily created child [Animator](Animator.md) does all the work, and the controller forwards its stepped tick so tracks advance even outside a Humanoid.

## Key types and API

Descriptors:
- `desc_LoadAnimation("LoadAnimation", "animation", Security::None)` — BoundFunc returning the created track Instance.
- `desc_GetPlayingAnimationTracks("GetPlayingAnimationTracks", Security::None)` — BoundFunc returning ValueArray of playing tracks.
- `event_AnimationPlayed("AnimationPlayed", "animationTrack")` — plain Event on `animationPlayedSignal`. No other Security:: tiers in this TU.

Constants: `sAnimationController = "AnimationController"`.

Behavior:
- `getAnimator()` — lazy-creates an Animator via `Creatable<Instance>::create<RBX::Animator>(this)`; parents it to self ONLY if parent's class name is exactly "Model".
- `loadAnimation` / `getPlayingAnimationTracks` — straight delegation to animator.
- `onStepped(const Stepped&)` — forwards to `animator->onStepped` (controller is IStepped-registered via `onServiceProviderIStepped`).
- `askSetParent` always true — can be parented anywhere.
- ctor/dtor FASTLOG ISteppedLifetime markers.

## Usage / reflection touchpoints

Script API surface for animating non-character parts; pairs with Humanoid's internal Animator usage ([AnimationTrack](AnimationTrack.md), [AnimationTrackState](AnimationTrackState.md)).

## Gotchas

- If the controller is NOT under a Model when first used, the Animator stays unparented (still functional, invisible to scripts iterating children).
- All real logic lives in Animator.cpp — this TU is a façade; debugging track issues means reading Animator.md.
