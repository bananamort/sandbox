# App/include/v8xml/Serializer.h

## Purpose

Declares `Serializer`, the classic place-file serializer: extends SerializerV2 with a static `canWriteChild` policy implementing per-SaveFilter service whitelists (SAVE_WORLD keeps Workspace/Lighting/SoundService/ServerStorage/ReplicatedStorage/CSGDictionaryService; SAVE_GAME keeps StarterGui/StarterPack/StarterPlayer/ServerScriptService/ReplicatedFirst).

## Declared API

- `class Serializer : public SerializerV2`
  - Static inline `bool canWriteChild(const shared_ptr<RBX::Instance> instance, RBX::Instance::SaveFilter saveFilter);`
    - First gate: non-archivable instances never written.
    - `SAVE_ALL` → true; `SAVE_WORLD` → whitelisted services above, else false; `SAVE_GAME` → its whitelist, else false; default → true.

## Usage notes

- Pulls a large set of v8datamodel headers to enable the fastDynamicCast checks — heavy include.
- All other serialization machinery inherited from [SerializerV2.md](SerializerV2.md).

## Gotchas

- The whitelists are exact-type casts: subclasses of Workspace etc. still match via fastDynamicCast's isA semantics, but unrelated services are dropped silently under SAVE_WORLD/SAVE_GAME.
- StarterGuiService/StarterPackService referenced here but not included directly — they must arrive transitively (Hopper.h chain) or the TU breaks.
